using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Dashboard_admin_feedefinition : System.Web.UI.Page
{
    public class FeeDefinition
    {
        public int FeeDefinitionID { get; set; }
        public string FeeName { get; set; }
        public string Code { get; set; }
        public string Frequency { get; set; }
        public decimal DefaultAmount { get; set; }
        public bool IsActive { get; set; }
    }

    private int EditingFeeDefinitionID
    {
        get { return ViewState["EditingFeeDefinitionID"] != null ? (int)ViewState["EditingFeeDefinitionID"] : 0; }
        set { ViewState["EditingFeeDefinitionID"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDefaultDueDate.Text = DateTime.Today.ToString("yyyy-MM-dd");
            RegisterAsyncTask(new PageAsyncTask(async () =>
            {
                await BindFeeDefinitionsGridViewAsync();
                PopulateStatsFromCache();
            }));
        }
    }

    private async Task<List<FeeHeadApi>> FetchFeeHeadsAsync()
    {
        var filter = new FeeHeadFilterApi { deleted = false, status = null, id = null, pageNo = null };
        var res = await ApiHelper.PostAsync("api/Fees/getFeeHeadList", filter, HttpContext.Current);
        if (res == null || res.response_code != "200")
            return null;

        try
        {
            var json = JsonConvert.SerializeObject(res.obj);
            return JsonConvert.DeserializeObject<List<FeeHeadApi>>(json);
        }
        catch
        {
            return null;
        }
    }

    private void CacheFeeHeads(List<FeeHeadApi> list)
    {
        try
        {
            ViewState["feeHeadsCache"] = JsonConvert.SerializeObject(list ?? new List<FeeHeadApi>());
        }
        catch { }
    }

    private List<FeeHeadApi> GetFeeHeadsFromCache()
    {
        try
        {
            var raw = ViewState["feeHeadsCache"] as string;
            if (string.IsNullOrWhiteSpace(raw)) return new List<FeeHeadApi>();
            return JsonConvert.DeserializeObject<List<FeeHeadApi>>(raw) ?? new List<FeeHeadApi>();
        }
        catch { return new List<FeeHeadApi>(); }
    }

    private void PopulateStatsFromCache()
    {
        var list = GetFeeHeadsFromCache();
        litTotalFeeTypes.Text = list.Count.ToString(CultureInfo.InvariantCulture);
        litFeeStructuresInUse.Text = list.Count(x => x.status.HasValue ? x.status.Value : true).ToString(CultureInfo.InvariantCulture);
        litUpcomingDueDates.Text = "-";
    }

    private async Task BindFeeDefinitionsGridViewAsync()
    {
        var heads = await FetchFeeHeadsAsync();
        if (heads == null) heads = new List<FeeHeadApi>();

        CacheFeeHeads(heads);

        var rows = heads
            .OrderBy(x => x.name)
            .Select(x => new FeeDefinition
            {
                FeeDefinitionID = x.id,
                FeeName = x.name,
                Code = x.code,
                Frequency = x.frequency,
                DefaultAmount = x.default_amount,
                IsActive = x.status.HasValue ? x.status.Value : true
            })
            .ToList();

        gvFeeDefinitions.DataSource = rows;
        gvFeeDefinitions.DataBind();
    }

    protected void btnAddFeeType_Click(object sender, EventArgs e)
    {
        if (!IsValid) return;

        RegisterAsyncTask(new PageAsyncTask(async () =>
        {
            decimal amt;
            if (!decimal.TryParse(txtDefaultAmount.Text, NumberStyles.Any, CultureInfo.InvariantCulture, out amt) &&
                !decimal.TryParse(txtDefaultAmount.Text, NumberStyles.Any, CultureInfo.CurrentCulture, out amt))
                amt = 0m;

            var req = new SaveFeeHeadRequestApi
            {
                id = null,
                name = txtFeeName.Text.Trim(),
                code = string.IsNullOrWhiteSpace(txtFeeDescription.Text) ? null : txtFeeDescription.Text.Trim(),
                frequency = string.IsNullOrWhiteSpace(ddlApplicableClass.SelectedValue) ? null : ddlApplicableClass.SelectedValue,
                default_amount = amt,
                status = chkIsActive.Checked,
                created_by_id = null
            };

            var res = await ApiHelper.PostAsync("api/Fees/saveFeeHead", req, HttpContext.Current);
            if (res != null && res.response_code == "200")
            {
                ClearForm();
                await BindFeeDefinitionsGridViewAsync();
                PopulateStatsFromCache();
                ScriptManager.RegisterStartupScript(this, GetType(), "success", "alert('Fee head saved successfully!');", true);
            }
            else
            {
                var msg = res != null && res.obj != null ? res.obj.ToString() : "Failed.";
                msg = msg.Replace("'", "\\'");
                ScriptManager.RegisterStartupScript(this, GetType(), "error", "alert('" + msg + "');", true);
            }
        }));
    }

    protected void gvFeeDefinitions_RowEditing(object sender, GridViewEditEventArgs e)
    {
        gvFeeDefinitions.EditIndex = -1;

        int feeDefID = (int)gvFeeDefinitions.DataKeys[e.NewEditIndex].Value;
        EditingFeeDefinitionID = feeDefID;

        var heads = GetFeeHeadsFromCache();
        var head = heads.FirstOrDefault(x => x.id == feeDefID);
        if (head != null)
        {
            txtFeeName.Text = head.name;
            txtFeeDescription.Text = head.code;
            txtDefaultAmount.Text = head.default_amount.ToString("F2", CultureInfo.InvariantCulture);
            ddlApplicableClass.SelectedValue = head.frequency ?? "";
            chkIsActive.Checked = head.status.HasValue ? head.status.Value : true;

            btnAddFeeType.Visible = false;
            btnUpdateFeeType.Visible = true;
            btnCancelEdit.Visible = true;
        }
    }

    protected void btnUpdateFeeType_Click(object sender, EventArgs e)
    {
        if (!IsValid) return;

        RegisterAsyncTask(new PageAsyncTask(async () =>
        {
            decimal amt;
            if (!decimal.TryParse(txtDefaultAmount.Text, NumberStyles.Any, CultureInfo.InvariantCulture, out amt) &&
                !decimal.TryParse(txtDefaultAmount.Text, NumberStyles.Any, CultureInfo.CurrentCulture, out amt))
                amt = 0m;

            var req = new SaveFeeHeadRequestApi
            {
                id = EditingFeeDefinitionID,
                name = txtFeeName.Text.Trim(),
                code = string.IsNullOrWhiteSpace(txtFeeDescription.Text) ? null : txtFeeDescription.Text.Trim(),
                frequency = string.IsNullOrWhiteSpace(ddlApplicableClass.SelectedValue) ? null : ddlApplicableClass.SelectedValue,
                default_amount = amt,
                status = chkIsActive.Checked,
                created_by_id = null
            };

            var res = await ApiHelper.PostAsync("api/Fees/saveFeeHead", req, HttpContext.Current);
            if (res != null && res.response_code == "200")
            {
                ClearForm();
                EditingFeeDefinitionID = 0;
                await BindFeeDefinitionsGridViewAsync();
                PopulateStatsFromCache();
                ScriptManager.RegisterStartupScript(this, GetType(), "success", "alert('Fee head updated successfully!');", true);
            }
            else
            {
                var msg = res != null && res.obj != null ? res.obj.ToString() : "Failed.";
                msg = msg.Replace("'", "\\'");
                ScriptManager.RegisterStartupScript(this, GetType(), "error", "alert('" + msg + "');", true);
            }
        }));
    }

    protected void gvFeeDefinitions_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int feeDefID = (int)gvFeeDefinitions.DataKeys[e.RowIndex].Value;

        RegisterAsyncTask(new PageAsyncTask(async () =>
        {
            var res = await ApiHelper.PostAsync("api/Fees/deleteFeeHead", new DeleteFeeHeadRequestApi { id = feeDefID, deleted_by_id = null }, HttpContext.Current);
            if (res != null && res.response_code == "200")
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "success", "alert('Fee head deleted successfully!');", true);
            }
            else
            {
                var msg = res != null && res.obj != null ? res.obj.ToString() : "Failed.";
                msg = msg.Replace("'", "\\'");
                ScriptManager.RegisterStartupScript(this, GetType(), "error", "alert('" + msg + "');", true);
            }

            ClearForm();
            EditingFeeDefinitionID = 0;
            await BindFeeDefinitionsGridViewAsync();
            PopulateStatsFromCache();
        }));
    }

    protected void btnCancelEdit_Click(object sender, EventArgs e)
    {
        ClearForm();
        EditingFeeDefinitionID = 0;
    }

    private void ClearForm()
    {
        txtFeeName.Text = "";
        txtFeeDescription.Text = "";
        txtDefaultAmount.Text = "";
        ddlApplicableClass.SelectedValue = "";
        chkIsActive.Checked = true;

        btnAddFeeType.Visible = true;
        btnUpdateFeeType.Visible = false;
        btnCancelEdit.Visible = false;

        foreach (BaseValidator validator in Page.Validators)
            validator.Validate();
    }
}
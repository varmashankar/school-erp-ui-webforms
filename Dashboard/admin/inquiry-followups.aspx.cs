using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Dashboard_admin_inquiry_followups : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["authToken"] == null)
        {
            Response.Redirect("~/login.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
            return;
        }

        if (!IsPostBack)
        {
            hfInquiryId.Value = Request.QueryString["inquiryId"] ?? "";

            // Default: now + 30 minutes
            txtFollowUpAt.Text = DateTime.Now.AddMinutes(30).ToString("yyyy-MM-ddTHH:mm");

            RegisterAsyncTask(new PageAsyncTask(LoadInquiryPicker));
            RegisterAsyncTask(new PageAsyncTask(LoadDue));
        }
    }

    private async System.Threading.Tasks.Task LoadInquiryPicker()
    {
        // Bind inquiry dropdown (latest items). Keep selection if inquiryId was passed.
        ddlInquiry.Items.Clear();
        ddlInquiry.Items.Add(new ListItem("-- Select Inquiry --", ""));

        try
        {
            var res = await ApiHelper.PostAsync("api/Inquiries/getInquiryList", new { }, HttpContext.Current);
            if (res == null || res.response_code != "200" || res.obj == null)
                return;

            var json = JsonConvert.SerializeObject(res.obj);
            var list = JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(json) ?? new List<Dictionary<string, object>>();

            // Show latest first (if createdAt exists, otherwise keep as returned)
            list.Reverse();

            foreach (var x in list)
            {
                object idObj;
                if (!x.TryGetValue("id", out idObj) && !x.TryGetValue("Id", out idObj))
                    continue;

                var idStr = Convert.ToString(idObj);
                if (string.IsNullOrWhiteSpace(idStr))
                    continue;

                object noObj;
                object fnObj;
                object lnObj;

                var inquiryNo = (x.TryGetValue("inquiryNo", out noObj) ? Convert.ToString(noObj)
                               : (x.TryGetValue("inquiry_no", out noObj) ? Convert.ToString(noObj)
                               : null)) ?? string.Empty;

                var firstName = (x.TryGetValue("firstName", out fnObj) ? Convert.ToString(fnObj)
                               : (x.TryGetValue("first_name", out fnObj) ? Convert.ToString(fnObj)
                               : null)) ?? string.Empty;

                var lastName = (x.TryGetValue("lastName", out lnObj) ? Convert.ToString(lnObj)
                              : (x.TryGetValue("last_name", out lnObj) ? Convert.ToString(lnObj)
                              : null)) ?? string.Empty;

                var text = string.IsNullOrWhiteSpace(inquiryNo)
                    ? (idStr + " - " + (firstName + " " + lastName).Trim())
                    : (inquiryNo + " - " + (firstName + " " + lastName).Trim());

                ddlInquiry.Items.Add(new ListItem(text.Trim(' ', '-'), idStr));
            }

            long inquiryId;
            if (long.TryParse(hfInquiryId.Value, out inquiryId) && inquiryId > 0)
            {
                var item = ddlInquiry.Items.FindByValue(inquiryId.ToString());
                if (item != null) ddlInquiry.SelectedValue = inquiryId.ToString();
            }

            UpdateSelectedInquiryBadge();
        }
        catch
        {
            UpdateSelectedInquiryBadge();
        }
    }

    private static DateTime? ParseDateTime(string value)
    {
        if (string.IsNullOrWhiteSpace(value)) return null;

        DateTime dt;
        if (DateTime.TryParseExact(value.Trim(), "yyyy-MM-dd'T'HH:mm", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
            return dt;

        if (DateTime.TryParse(value, out dt))
            return dt;

        return null;
    }

    private long? GetSelectedInquiryId()
    {
        long id;
        if (long.TryParse(hfInquiryId.Value, out id) && id > 0) return id;
        if (ddlInquiry != null && long.TryParse(ddlInquiry.SelectedValue, out id) && id > 0) return id;
        return null;
    }

    private async System.Threading.Tasks.Task LoadDue()
    {
        try
        {
            var payload = new
            {
                toDate = DateTime.Now
            };

            var res = await ApiHelper.PostAsync("api/Inquiries/getDueFollowUps", payload, HttpContext.Current);
            if (res == null || res.response_code != "200")
            {
                gvDue.DataSource = new List<object>();
                gvDue.DataBind();
                return;
            }

            var json = JsonConvert.SerializeObject(res.obj);
            var rawList = JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(json) ?? new List<Dictionary<string, object>>();

            var selectedInquiryId = GetSelectedInquiryId();
            if (selectedInquiryId.HasValue)
            {
                rawList = rawList.FindAll(x =>
                {
                    object v;
                    if (x.TryGetValue("inquiryId", out v) || x.TryGetValue("inquiry_id", out v) || x.TryGetValue("InquiryId", out v) || x.TryGetValue("Inquiry_Id", out v))
                    {
                        long id;
                        return long.TryParse(Convert.ToString(v), out id) && id == selectedInquiryId.Value;
                    }
                    return false;
                });
            }

            var dt = new System.Data.DataTable();
            dt.Columns.Add("id");
            dt.Columns.Add("inquiryId");
            dt.Columns.Add("followUpAt");
            dt.Columns.Add("channel");
            dt.Columns.Add("remarks");
            dt.Columns.Add("isReminded");

            foreach (var x in rawList)
            {
                object v;
                var r = dt.NewRow();

                r["id"] = x.TryGetValue("id", out v) ? v : (x.TryGetValue("Id", out v) ? v : null);
                r["inquiryId"] = x.TryGetValue("inquiryId", out v) ? v : (x.TryGetValue("InquiryId", out v) ? v : (x.TryGetValue("inquiry_id", out v) ? v : null));
                r["followUpAt"] = x.TryGetValue("followUpAt", out v) ? v : (x.TryGetValue("FollowUpAt", out v) ? v : (x.TryGetValue("follow_up_at", out v) ? v : null));
                r["channel"] = x.TryGetValue("channel", out v) ? v : (x.TryGetValue("Channel", out v) ? v : null);
                r["remarks"] = x.TryGetValue("remarks", out v) ? v : (x.TryGetValue("Remarks", out v) ? v : null);
                r["isReminded"] = x.TryGetValue("isReminded", out v) ? v : (x.TryGetValue("IsReminded", out v) ? v : (x.TryGetValue("is_reminded", out v) ? v : null));

                dt.Rows.Add(r);
            }

            gvDue.DataSource = dt;
            gvDue.DataBind();
        }
        catch (Exception ex)
        {
            lblInfo.Text = "Error: " + ex.Message;
        }
    }

    private void UpdateSelectedInquiryBadge()
    {
        long inquiryId;
        var selected = GetSelectedInquiryId();
        if (selected.HasValue)
            lblSelectedInquiry.Text = "<i class='bi bi-info-circle'></i> Inquiry #" + selected.Value;
        else
            lblSelectedInquiry.Text = "<i class='bi bi-info-circle'></i> Select an inquiry";
    }

    protected void btnPreset30_Click(object sender, EventArgs e)
    {
        txtFollowUpAt.Text = DateTime.Now.AddMinutes(30).ToString("yyyy-MM-ddTHH:mm");
    }

    protected void btnPreset2h_Click(object sender, EventArgs e)
    {
        txtFollowUpAt.Text = DateTime.Now.AddHours(2).ToString("yyyy-MM-ddTHH:mm");
    }

    protected void btnPresetTomorrow_Click(object sender, EventArgs e)
    {
        var t = DateTime.Today.AddDays(1).AddHours(10);
        txtFollowUpAt.Text = t.ToString("yyyy-MM-ddTHH:mm");
    }

    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        RegisterAsyncTask(new PageAsyncTask(LoadDue));
    }

    protected void btnSaveFollowUp_Click(object sender, EventArgs e)
    {
        RegisterAsyncTask(new PageAsyncTask(async () =>
        {
            try
            {
                var inquiryIdToSave = GetSelectedInquiryId();
                if (!inquiryIdToSave.HasValue)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "bad", "Swal.fire('ERROR','Select an inquiry first.','error');", true);
                    return;
                }

                var dtVal = ParseDateTime(txtFollowUpAt.Text);
                if (!dtVal.HasValue)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "bad2", "Swal.fire('ERROR','Invalid Follow Up At.','error');", true);
                    return;
                }

                var payload = new
                {
                    inquiryId = inquiryIdToSave.Value,
                    followUpAt = dtVal.Value,
                    channel = ddlChannel.SelectedValue,
                    remarks = txtRemarks.Text,
                    isReminded = false,
                    remindedAt = (DateTime?)null
                };

                var res = await ApiHelper.PostAsync("api/Inquiries/saveInquiryFollowUp", payload, HttpContext.Current);
                if (res != null && res.response_code == "200")
                {
                    txtRemarks.Text = string.Empty;

                    string msg = (res.obj == null ? "Follow-up saved." : res.obj.ToString()).Replace("'", "\\'");
                    ScriptManager.RegisterStartupScript(this, GetType(), "ok", "Swal.fire('SUCCESS','" + msg + "','success');", true);
                    await LoadDue();
                    return;
                }

                string err = (res != null && res.obj != null) ? res.obj.ToString() : "Failed to save follow-up.";
                err = err.Replace("'", "\\'");
                ScriptManager.RegisterStartupScript(this, GetType(), "bad3", "Swal.fire('ERROR','" + err + "','error');", true);
            }
            catch (Exception ex)
            {
                string msg = ex.Message.Replace("'", "\\'");
                ScriptManager.RegisterStartupScript(this, GetType(), "err", "Swal.fire('ERROR','" + msg + "','error');", true);
            }
        }));
    }

    protected void gvDue_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName != "MarkReminded") return;

        RegisterAsyncTask(new PageAsyncTask(async () =>
        {
            try
            {
                long followUpId;
                if (!long.TryParse(Convert.ToString(e.CommandArgument), out followUpId))
                    return;

                var payload = new
                {
                    followUpId = (long?)followUpId,
                    remindedAt = DateTime.UtcNow,
                    userId = (long?)null,
                    roleId = (long?)null
                };

                var res = await ApiHelper.PostAsync("api/Inquiries/markFollowUpReminded", payload, HttpContext.Current);
                if (res != null && res.response_code == "200")
                {
                    string msg = (res.obj == null ? "Marked." : res.obj.ToString()).Replace("'", "\\'");
                    ScriptManager.RegisterStartupScript(this, GetType(), "ok2", "Swal.fire('SUCCESS','" + msg + "','success');", true);
                    await LoadDue();
                    return;
                }

                string err = (res != null && res.obj != null) ? res.obj.ToString() : "Failed to mark reminded.";
                err = err.Replace("'", "\\'");
                ScriptManager.RegisterStartupScript(this, GetType(), "bad4", "Swal.fire('ERROR','" + err + "','error');", true);
            }
            catch (Exception ex)
            {
                string msg = ex.Message.Replace("'", "\\'");
                ScriptManager.RegisterStartupScript(this, GetType(), "err2", "Swal.fire('ERROR','" + msg + "','error');", true);
            }
        }));
    }

    protected void ddlInquiry_SelectedIndexChanged(object sender, EventArgs e)
    {
        UpdateSelectedInquiryBadge();
        RegisterAsyncTask(new PageAsyncTask(LoadDue));
    }
}

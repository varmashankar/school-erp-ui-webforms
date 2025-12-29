using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Dashboard_admin_inquiries : System.Web.UI.Page
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
            BindStatusDropdown(ddlStatus, includeAll: true);
            RegisterAsyncTask(new PageAsyncTask(LoadInquiries));
        }
    }

    private void BindStatusDropdown(DropDownList ddl, bool includeAll)
    {
        ddl.Items.Clear();
        if (includeAll)
            ddl.Items.Add(new ListItem("-- All Status --", ""));

        ddl.Items.Add(new ListItem("NEW", "NEW"));
        ddl.Items.Add(new ListItem("IN_PROGRESS", "IN_PROGRESS"));
        ddl.Items.Add(new ListItem("FOLLOW_UP", "FOLLOW_UP"));
        ddl.Items.Add(new ListItem("VISITED", "VISITED"));
        ddl.Items.Add(new ListItem("CONVERTED", "CONVERTED"));
        ddl.Items.Add(new ListItem("LOST", "LOST"));
    }

    private static DateTime? ParseDate(string value)
    {
        if (string.IsNullOrWhiteSpace(value)) return null;

        DateTime dt;
        if (DateTime.TryParseExact(value.Trim(), "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
            return dt;

        return null;
    }

    private void EnsureDataTablesInit()
    {
        var script = @"(function(){
            if (typeof initDataTable === 'function') { initDataTable('#gvInquiries'); }
            else if (window.jQuery && window.jQuery.fn && window.jQuery.fn.DataTable) { $('#gvInquiries').DataTable(); }
        })();";

        ScriptManager.RegisterStartupScript(this, GetType(), "activateDT_inq", script, true);
    }

    private async System.Threading.Tasks.Task LoadInquiries()
    {
        try
        {
            var filter = new
            {
                inquiryNo = string.IsNullOrWhiteSpace(txtSearchInquiryNo.Text) ? null : txtSearchInquiryNo.Text.Trim(),
                status = string.IsNullOrWhiteSpace(ddlStatus.SelectedValue) ? null : ddlStatus.SelectedValue,
                fromDate = ParseDate(txtFromDate.Text),
                toDate = ParseDate(txtToDate.Text)
            };
    
            var res = await ApiHelper.PostAsync("api/Inquiries/getInquiryList", filter, HttpContext.Current);
            if (res == null)
            {
                gvInquiries.DataSource = new List<object>();
                gvInquiries.DataBind();
                lblInfo.Text = "No response from server.";
                return;
            }

            if (res.response_code != "200")
            {
                gvInquiries.DataSource = new List<object>();
                gvInquiries.DataBind();
                lblInfo.Text = res.obj == null ? "Failed to load inquiries." : res.obj.ToString();
                return;
            }

            var json = JsonConvert.SerializeObject(res.obj);
            var rawList = JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(json) ?? new List<Dictionary<string, object>>();

            // GridView binds reliably to DataTable columns
            var dt = new System.Data.DataTable();
            dt.Columns.Add("id");
            dt.Columns.Add("inquiryNo");
            dt.Columns.Add("firstName");
            dt.Columns.Add("lastName");
            dt.Columns.Add("phone");
            dt.Columns.Add("email");
            dt.Columns.Add("status");
            dt.Columns.Add("nextFollowUpAt");

            foreach (var x in rawList)
            {
                object v;
                var r = dt.NewRow();

                r["id"] = x.TryGetValue("id", out v) ? v : (x.TryGetValue("Id", out v) ? v : null);
                r["inquiryNo"] = x.TryGetValue("inquiryNo", out v) ? v : (x.TryGetValue("InquiryNo", out v) ? v : (x.TryGetValue("inquiry_no", out v) ? v : null));
                r["firstName"] = x.TryGetValue("firstName", out v) ? v : (x.TryGetValue("FirstName", out v) ? v : (x.TryGetValue("first_name", out v) ? v : null));
                r["lastName"] = x.TryGetValue("lastName", out v) ? v : (x.TryGetValue("LastName", out v) ? v : (x.TryGetValue("last_name", out v) ? v : null));
                r["phone"] = x.TryGetValue("phone", out v) ? v : (x.TryGetValue("Phone", out v) ? v : null);
                r["email"] = x.TryGetValue("email", out v) ? v : (x.TryGetValue("Email", out v) ? v : null);
                r["status"] = x.TryGetValue("status", out v) ? v : (x.TryGetValue("Status", out v) ? v : (x.TryGetValue("inquiry_status", out v) ? v : null));
                r["nextFollowUpAt"] = x.TryGetValue("nextFollowUpAt", out v) ? v : (x.TryGetValue("NextFollowUpAt", out v) ? v : (x.TryGetValue("next_follow_up_at", out v) ? v : null));

                dt.Rows.Add(r);
            }

            gvInquiries.DataSource = dt;
            gvInquiries.DataBind();

            foreach (GridViewRow row in gvInquiries.Rows)
            {
                var ddlRowStatus = row.FindControl("ddlRowStatus") as DropDownList;
                if (ddlRowStatus != null)
                {
                    BindStatusDropdown(ddlRowStatus, includeAll: false);
                    var currentStatusObj = DataBinder.Eval(row.DataItem, "status");
                    var currentStatus = currentStatusObj == null ? string.Empty : currentStatusObj.ToString();
                    var item = ddlRowStatus.Items.FindByValue(currentStatus);
                    if (item != null) ddlRowStatus.SelectedValue = currentStatus;
                }
            }

            lblInfo.Text = dt.Rows.Count + " record(s).";

            EnsureDataTablesInit();
        }
        catch (Exception ex)
        {
            lblInfo.Text = "Error: " + ex.Message;
        }
    }

    protected void gvInquiries_RowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType != DataControlRowType.Header) return;

        gvInquiries.UseAccessibleHeader = true;
        e.Row.TableSection = TableRowSection.TableHeader;

        var parent = e.Row.Parent;
        if (parent == null) return;

        // Avoid adding the filters row multiple times
        for (int i = 0; i < parent.Controls.Count; i++)
        {
            var existing = parent.Controls[i] as GridViewRow;
            if (existing != null && string.Equals(existing.CssClass, "filters", StringComparison.OrdinalIgnoreCase))
                return;
        }

        var filterRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Normal);
        filterRow.CssClass = "filters";

        filterRow.Cells.Add(new TableHeaderCell());
        filterRow.Cells.Add(MakeFilterCell("Search Inquiry No"));
        filterRow.Cells.Add(MakeFilterCell("Search First"));
        filterRow.Cells.Add(MakeFilterCell("Search Last"));
        filterRow.Cells.Add(MakeFilterCell("Search Phone"));
        filterRow.Cells.Add(MakeFilterCell("Search Email"));
        filterRow.Cells.Add(MakeFilterCell("Search Status"));
        filterRow.Cells.Add(MakeFilterCell("Search Next"));
        filterRow.Cells.Add(new TableHeaderCell());

        var insertIndex = parent.Controls.Count > 0 ? 1 : 0;
        if (insertIndex > parent.Controls.Count) insertIndex = parent.Controls.Count;
        parent.Controls.AddAt(insertIndex, filterRow);
    }

    private static TableHeaderCell MakeFilterCell(string placeholder)
    {
        var cell = new TableHeaderCell();
        var tb = new TextBox();
        tb.CssClass = "form-control form-control-sm";
        tb.Attributes["placeholder"] = placeholder;
        cell.Controls.Add(tb);
        return cell;
    }

    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        RegisterAsyncTask(new PageAsyncTask(LoadInquiries));
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        RegisterAsyncTask(new PageAsyncTask(LoadInquiries));
    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        txtSearchInquiryNo.Text = string.Empty;
        ddlStatus.SelectedIndex = 0;
        txtFromDate.Text = string.Empty;
        txtToDate.Text = string.Empty;

        RegisterAsyncTask(new PageAsyncTask(LoadInquiries));
    }

    protected void gvInquiries_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName != "ChangeStatus") return;

        RegisterAsyncTask(new PageAsyncTask(async () =>
        {
            try
            {
                long inquiryId;
                if (!long.TryParse(Convert.ToString(e.CommandArgument), out inquiryId))
                    return;

                var row = ((Control)e.CommandSource).NamingContainer as GridViewRow;
                var ddlRowStatus = row != null ? row.FindControl("ddlRowStatus") as DropDownList : null;
                if (ddlRowStatus == null || string.IsNullOrWhiteSpace(ddlRowStatus.SelectedValue))
                    return;

                var payload = new
                {
                    id = (long?)inquiryId,
                    status = ddlRowStatus.SelectedValue
                };

                var res = await ApiHelper.PostAsync("api/Inquiries/changeInquiryStatus", payload, HttpContext.Current);
                if (res != null && res.response_code == "200")
                {
                    string msg = (res.obj == null ? "Status updated." : res.obj.ToString()).Replace("'", "\\'");
                    ScriptManager.RegisterStartupScript(this, GetType(), "ok", "Swal.fire('SUCCESS','" + msg + "','success');", true);
                    await LoadInquiries();
                }
                else
                {
                    string msg = (res != null && res.obj != null) ? res.obj.ToString() : "Failed to update status.";
                    msg = msg.Replace("'", "\\'");
                    ScriptManager.RegisterStartupScript(this, GetType(), "bad", "Swal.fire('ERROR','" + msg + "','error');", true);
                }
            }
            catch (Exception ex)
            {
                string msg = ex.Message.Replace("'", "\\'");
                ScriptManager.RegisterStartupScript(this, GetType(), "err", "Swal.fire('ERROR','" + msg + "','error');", true);
            }
        }));
    }
}

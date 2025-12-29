using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;

public partial class Dashboard_admin_accountability_dashboard : AuthenticatedPage
{
    protected async void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            InitDefaultDates();
            await BindAcademicYears();
            await LoadAll();
        }
    }

    protected async void btnRefresh_Click(object sender, EventArgs e)
    {
        await LoadAll();
    }

    private void InitDefaultDates()
    {
        try
        {
            var today = DateTime.Today;
            txtTo.Text = today.ToString("yyyy-MM-dd");
            txtFrom.Text = today.AddDays(-30).ToString("yyyy-MM-dd");
        }
        catch { }
    }

    private DateTime? TryParseDate(string yyyyMmDd)
    {
        if (string.IsNullOrWhiteSpace(yyyyMmDd)) return null;
        DateTime d;
        if (DateTime.TryParseExact(yyyyMmDd, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out d))
            return d;
        return null;
    }

    private int? TryParseInt(string s)
    {
        if (string.IsNullOrWhiteSpace(s)) return null;
        int v;
        if (int.TryParse(s, out v)) return v;
        return null;
    }

    private object BuildFilterPayload()
    {
        DateTime? from = TryParseDate(txtFrom.Text);
        DateTime? to = TryParseDate(txtTo.Text);

        int? maxDays = TryParseInt(txtMaxDaysOverdue.Text);
        int? academicYearId = null;
        if (!string.IsNullOrWhiteSpace(ddlAcademicYear.SelectedValue))
            academicYearId = TryParseInt(ddlAcademicYear.SelectedValue);

        return new
        {
            fromDate = from,
            toDate = to,
            maxDaysOverdue = maxDays,
            academicYearId = academicYearId
        };
    }

    private async Task BindAcademicYears()
    {
        try
        {
            var res = await ApiHelper.PostAsync("api/AcademicYear/getAcademicYearList", new { }, HttpContext.Current);
            ddlAcademicYear.Items.Clear();
            ddlAcademicYear.Items.Add(new System.Web.UI.WebControls.ListItem("-- All --", ""));

            if (res != null && res.response_code == "200")
            {
                var json = JsonConvert.SerializeObject(res.obj);
                var years = JsonConvert.DeserializeObject<List<dynamic>>(json);

                foreach (var y in years)
                {
                    string id = Convert.ToString(y.id);
                    string code = Convert.ToString(y.yearCode);
                    if (string.IsNullOrWhiteSpace(code)) code = id;
                    ddlAcademicYear.Items.Add(new System.Web.UI.WebControls.ListItem(code, id));
                }
            }
        }
        catch
        {
            // ignore; still allow dashboard to load
        }
    }

    private async Task LoadAll()
    {
        pnlError.Visible = false;
        litError.Text = "";

        try
        {
            var filter = BuildFilterPayload();

            await LoadStaffFollowUps(filter);
            await LoadMissedInquiries(filter);
            await LoadAdmissionLossReasons(filter);
            await LoadFeeDelays(filter);
        }
        catch (Exception ex)
        {
            pnlError.Visible = true;
            litError.Text = HttpUtility.HtmlEncode(ex.Message);
        }
    }

    private async Task LoadStaffFollowUps(object filter)
    {
        var res = await ApiHelper.PostAsync("api/AccountabilityDashboard/getStaffFollowUpSummary", filter, HttpContext.Current);
        if (res == null || res.response_code != "200")
            throw new Exception("Staff follow-ups: " + (res != null ? Convert.ToString(res.obj) : "API error"));

        var json = JsonConvert.SerializeObject(res.obj);
        var rawList = JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(json) ?? new List<Dictionary<string, object>>();

        var dt = new System.Data.DataTable();
        dt.Columns.Add("staffId");
        dt.Columns.Add("staffName");
        dt.Columns.Add("dueFollowUps");
        dt.Columns.Add("overdueFollowUps");
        dt.Columns.Add("lastFollowUpAt");

        foreach (var x in rawList)
        {
            object v;
            var r = dt.NewRow();

            r["staffId"] = x.TryGetValue("staffId", out v) ? v : (x.TryGetValue("staff_id", out v) ? v : null);
            r["staffName"] = x.TryGetValue("staffName", out v) ? v : (x.TryGetValue("staff_name", out v) ? v : null);
            r["dueFollowUps"] = x.TryGetValue("dueFollowUps", out v) ? v : (x.TryGetValue("due_follow_ups", out v) ? v : null);
            r["overdueFollowUps"] = x.TryGetValue("overdueFollowUps", out v) ? v : (x.TryGetValue("overdue_follow_ups", out v) ? v : null);
            r["lastFollowUpAt"] = x.TryGetValue("lastFollowUpAt", out v) ? v : (x.TryGetValue("last_follow_up_at", out v) ? v : null);

            if (r["staffName"] == null || string.IsNullOrWhiteSpace(Convert.ToString(r["staffName"])))
                r["staffName"] = "All Staff";

            dt.Rows.Add(r);
        }

        gvStaff.DataSource = dt;
        gvStaff.DataBind();
    }

    private async Task LoadMissedInquiries(object filter)
    {
        var res = await ApiHelper.PostAsync("api/AccountabilityDashboard/getMissedInquiries", filter, HttpContext.Current);
        if (res == null || res.response_code != "200")
            throw new Exception("Missed inquiries: " + (res != null ? Convert.ToString(res.obj) : "API error"));

        var json = JsonConvert.SerializeObject(res.obj);
        var rows = JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(json) ?? new List<Dictionary<string, object>>();

        var dt = new DataTable();
        dt.Columns.Add("inquiryId");
        dt.Columns.Add("studentName");
        dt.Columns.Add("phone");
        dt.Columns.Add("status");
        dt.Columns.Add("inquiryDate");
        dt.Columns.Add("nextFollowUpAt");
        dt.Columns.Add("daysOverdue");
        dt.Columns.Add("assignedToStaffId");
        dt.Columns.Add("assignedToStaffName");

        foreach (var x in rows)
        {
            object v;
            var r = dt.NewRow();

            r["inquiryId"] = x.TryGetValue("inquiryId", out v) ? v : (x.TryGetValue("inquiry_id", out v) ? v : null);
            r["studentName"] = x.TryGetValue("studentName", out v) ? v : (x.TryGetValue("student_name", out v) ? v : null);
            r["phone"] = x.TryGetValue("phone", out v) ? v : null;
            r["status"] = x.TryGetValue("status", out v) ? v : null;
            r["inquiryDate"] = x.TryGetValue("inquiryDate", out v) ? v : (x.TryGetValue("inquiry_date", out v) ? v : null);
            r["nextFollowUpAt"] = x.TryGetValue("nextFollowUpAt", out v) ? v : (x.TryGetValue("next_follow_up_at", out v) ? v : null);
            r["daysOverdue"] = x.TryGetValue("daysOverdue", out v) ? v : (x.TryGetValue("days_overdue", out v) ? v : null);

            r["assignedToStaffId"] = x.TryGetValue("assignedToStaffId", out v)
                ? v
                : (x.TryGetValue("assigned_to_staff_id", out v)
                    ? v
                    : (x.TryGetValue("assignedTo", out v) ? v : (x.TryGetValue("assigned_to", out v) ? v : null)));

            r["assignedToStaffName"] = x.TryGetValue("assignedToStaffName", out v)
                ? v
                : (x.TryGetValue("assigned_to_staff_name", out v)
                    ? v
                    : (x.TryGetValue("assignedToName", out v) ? v : (x.TryGetValue("assigned_to_name", out v) ? v : null)));

            if (r["assignedToStaffName"] == null || string.IsNullOrWhiteSpace(Convert.ToString(r["assignedToStaffName"])))
                r["assignedToStaffName"] = "Unassigned";

            dt.Rows.Add(r);
        }

        gvMissed.DataSource = dt;
        gvMissed.DataBind();
    }

    private async Task LoadAdmissionLossReasons(object filter)
    {
        var res = await ApiHelper.PostAsync("api/AccountabilityDashboard/getAdmissionLossReasons", filter, HttpContext.Current);
        if (res == null || res.response_code != "200")
            throw new Exception("Admission loss reasons: " + (res != null ? Convert.ToString(res.obj) : "API error"));

        var json = JsonConvert.SerializeObject(res.obj);
        var rows = JsonConvert.DeserializeObject<List<dynamic>>(json);
        gvLossReasons.DataSource = rows;
        gvLossReasons.DataBind();
    }

    private async Task LoadFeeDelays(object filter)
    {
        var res = await ApiHelper.PostAsync("api/AccountabilityDashboard/getFeeCollectionDelays", filter, HttpContext.Current);
        if (res == null || res.response_code != "200")
            throw new Exception("Fee collection delays: " + (res != null ? Convert.ToString(res.obj) : "API error"));

        var json = JsonConvert.SerializeObject(res.obj);
        var rows = JsonConvert.DeserializeObject<List<dynamic>>(json);
        gvFeeDelays.DataSource = rows;
        gvFeeDelays.DataBind();
    }
}

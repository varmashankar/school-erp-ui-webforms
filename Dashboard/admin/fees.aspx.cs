using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Dashboard_admin_fees : System.Web.UI.Page
{
    private class FeesGridRow
    {
        public int StudentID { get; set; }
        public string RollNo { get; set; }
        public string StudentName { get; set; }
        public string ClassName { get; set; }
        public string ClassSectionID { get; set; }
        public decimal TotalFees { get; set; }
        public decimal AmountPaid { get; set; }
        public decimal BalanceDue { get; set; }
        public string Status { get; set; }
        public string StatusClass { get; set; }
        public DateTime DueDate { get; set; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            RegisterAsyncTask(new PageAsyncTask(LoadReportAsync));
        }
    }

    private async Task<OutstandingFeesReportApi> FetchOutstandingReportAsync()
    {
        // Filters: use onlyOverdue only if status filter is Overdue.
        bool onlyOverdue = string.Equals(ddlFilterStatus.SelectedValue, "Overdue", StringComparison.OrdinalIgnoreCase);

        var payload = new OutstandingFeesFilterApi
        {
            classId = null, // current UI dropdown values are dummy class-section strings; keep null to avoid wrong filtering
            studentId = null,
            academicYearId = null,
            dueFrom = null,
            dueTo = null,
            onlyOverdue = onlyOverdue ? (bool?)true : null
        };

        var res = await ApiHelper.PostAsync("api/Fees/getOutstandingFeesReport", payload, HttpContext.Current);
        if (res == null || res.response_code != "200")
            return null;

        try
        {
            var json = JsonConvert.SerializeObject(res.obj);
            return JsonConvert.DeserializeObject<OutstandingFeesReportApi>(json);
        }
        catch
        {
            return null;
        }
    }

    private static string MapStatusClass(string status)
    {
        if (string.Equals(status, "paid", StringComparison.OrdinalIgnoreCase)) return "badge-paid";
        if (string.Equals(status, "partial", StringComparison.OrdinalIgnoreCase)) return "badge-partial";
        if (string.Equals(status, "pending", StringComparison.OrdinalIgnoreCase)) return "badge-pending";
        if (string.Equals(status, "overdue", StringComparison.OrdinalIgnoreCase)) return "badge-overdue";
        return "badge-pending";
    }

    private static string MapUiStatus(OutstandingFeeItemApi item)
    {
        if (item == null) return "Pending";
        if (item.days_overdue > 0) return "Overdue";
        if (item.paid_amount > 0 && item.outstanding_amount > 0) return "Partial";
        if (item.paid_amount <= 0 && item.outstanding_amount > 0) return "Pending";
        return "Paid";
    }

    private async Task LoadReportAsync()
    {
        var report = await FetchOutstandingReportAsync();
        if (report == null)
        {
            litTotalExpectedFees.Text = "—";
            litTotalCollectedFees.Text = "—";
            litOutstandingFees.Text = "—";
            litOverdueAccounts.Text = "—";
            gvFees.DataSource = new List<FeesGridRow>();
            gvFees.DataBind();
            return;
        }

        // Totals based on outstanding report
        litTotalExpectedFees.Text = report.total_due.ToString("C", CultureInfo.CurrentCulture);
        litTotalCollectedFees.Text = report.total_paid.ToString("C", CultureInfo.CurrentCulture);
        litOutstandingFees.Text = report.total_outstanding.ToString("C", CultureInfo.CurrentCulture);
        litOverdueAccounts.Text = (report.items ?? new List<OutstandingFeeItemApi>()).Count(x => x.days_overdue > 0).ToString();

        BindFeesGridView(report);
    }

    private void BindFeesGridView(OutstandingFeesReportApi report)
    {
        var items = report.items ?? new List<OutstandingFeeItemApi>();

        string filterStatus = ddlFilterStatus.SelectedValue;
        string searchTerm = (txtSearchStudent.Text ?? string.Empty).Trim().ToLowerInvariant();

        // Group by student to produce the same shape as the old grid.
        var rows = items
            .GroupBy(x => x.student_id)
            .Select(g =>
            {
                var first = g.OrderBy(x => x.due_date).First();
                var totalDue = g.Sum(x => x.due_amount);
                var totalPaid = g.Sum(x => x.paid_amount);
                var totalOut = g.Sum(x => x.outstanding_amount);

                var anyOverdue = g.Any(x => x.days_overdue > 0);
                string status = anyOverdue ? "Overdue" : (totalPaid > 0 ? "Partial" : "Pending");
                string cls = MapStatusClass(status);

                return new FeesGridRow
                {
                    StudentID = first.student_id,
                    RollNo = first.student_code,
                    StudentName = first.student_name,
                    ClassName = first.class_name,
                    ClassSectionID = first.class_name,
                    TotalFees = totalDue,
                    AmountPaid = totalPaid,
                    BalanceDue = totalOut,
                    Status = status,
                    StatusClass = cls,
                    DueDate = first.due_date
                };
            })
            .ToList();

        if (!string.IsNullOrEmpty(filterStatus))
        {
            // UI filter values are: Paid/Pending/Overdue/Partial
            rows = rows.Where(r => string.Equals(r.Status, filterStatus, StringComparison.OrdinalIgnoreCase)).ToList();
        }

        if (!string.IsNullOrEmpty(searchTerm))
        {
            rows = rows.Where(r =>
                (!string.IsNullOrEmpty(r.StudentName) && r.StudentName.ToLowerInvariant().Contains(searchTerm))
                || (!string.IsNullOrEmpty(r.RollNo) && r.RollNo.ToLowerInvariant().Contains(searchTerm))
            ).ToList();
        }

        gvFees.DataSource = rows;
        gvFees.DataBind();
    }

    protected void ddlFilterClass_SelectedIndexChanged(object sender, EventArgs e)
    {
        // Not wired because dropdown uses dummy class-section codes.
        RegisterAsyncTask(new PageAsyncTask(LoadReportAsync));
    }

    protected void ddlFilterStatus_SelectedIndexChanged(object sender, EventArgs e)
    {
        RegisterAsyncTask(new PageAsyncTask(LoadReportAsync));
    }

    protected void txtSearchStudent_TextChanged(object sender, EventArgs e)
    {
        RegisterAsyncTask(new PageAsyncTask(LoadReportAsync));
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        RegisterAsyncTask(new PageAsyncTask(LoadReportAsync));
    }

    protected void gvFees_RowDataBound(object sender, GridViewRowEventArgs e)
    {
    }
}
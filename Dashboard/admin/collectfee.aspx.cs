using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class Dashboard_admin_collectfee : System.Web.UI.Page
{
    public class Student
    {
        public int StudentID { get; set; }
        public string RollNo { get; set; }
        public string StudentName { get; set; }
        public string ClassSectionID { get; set; }
        public string ClassName { get; set; }
    }

    private static List<Student> _students = new List<Student>
    {
        // fallback only
        new Student { StudentID = 1, RollNo = "S001", StudentName = "Alice Smith", ClassSectionID = "G1A", ClassName = "Grade 1 - A" },
    };

    protected void Page_Load(object sender, EventArgs e)
    {
        ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;

        if (!IsPostBack)
        {
            txtPaymentDate.Text = DateTime.Today.ToString("yyyy-MM-dd");
            RegisterAsyncTask(new PageAsyncTask(async () =>
            {
                await PopulateStudentsDropdownAsync();

                if (Request.QueryString["studentId"] != null)
                {
                    int studentId;
                    if (int.TryParse(Request.QueryString["studentId"], out studentId))
                    {
                        var studentItem = ddlStudent.Items.FindByValue(studentId.ToString());
                        if (studentItem != null)
                        {
                            ddlStudent.SelectedValue = studentId.ToString();
                            await LoadStudentFeeDetailsAsync(studentId);
                        }
                    }
                }
            }));
        }
    }

    private async Task<List<GetStudentsApi>> FetchStudentsAsync()
    {
        var filter = new StudentsFilterApi
        {
            id = null,
            classId = null,
            deleted = false,
            status = true,
            pageNo = 1
        };

        var res = await ApiHelper.PostAsync("api/Students/getStudentList", filter, HttpContext.Current);
        if (res == null || res.response_code != "200")
            return null;

        try
        {
            var json = JsonConvert.SerializeObject(res.obj);
            return JsonConvert.DeserializeObject<List<GetStudentsApi>>(json);
        }
        catch
        {
            return null;
        }
    }

    private async Task PopulateStudentsDropdownAsync()
    {
        var apiStudents = await FetchStudentsAsync();
        if (apiStudents != null && apiStudents.Count > 0)
        {
            ddlStudent.DataSource = apiStudents
                .Select(s => new
                {
                    StudentID = s.id,
                    DisplayName = string.Format("{0} ({1} - {2})", (s.firstName + " " + s.lastName).Trim(), s.studentCode, s.className)
                })
                .OrderBy(s => s.DisplayName)
                .ToList();

            ddlStudent.DataTextField = "DisplayName";
            ddlStudent.DataValueField = "StudentID";
            ddlStudent.DataBind();
            ddlStudent.Items.Insert(0, new ListItem("-- Select Student --", ""));

            // cache minimal details for display
            ViewState["studentsCache"] = JsonConvert.SerializeObject(apiStudents);
            return;
        }

        // fallback
        ddlStudent.DataSource = _students
            .Select(s => new
            {
                s.StudentID,
                DisplayName = string.Format("{0} ({1} - {2})", s.StudentName, s.RollNo, s.ClassName)
            })
            .OrderBy(s => s.DisplayName);

        ddlStudent.DataTextField = "DisplayName";
        ddlStudent.DataValueField = "StudentID";
        ddlStudent.DataBind();
        ddlStudent.Items.Insert(0, new ListItem("-- Select Student --", ""));
    }

    protected void ddlStudent_SelectedIndexChanged(object sender, EventArgs e)
    {
        int studentId;
        if (int.TryParse(ddlStudent.SelectedValue, out studentId))
            RegisterAsyncTask(new PageAsyncTask(() => LoadStudentFeeDetailsAsync(studentId)));
        else
            ClearFeeDetails();
    }

    private async Task<List<FeePendingInstallmentApi>> GetPendingInstallmentsAsync(int studentId)
    {
        var payload = new FeeDueFilterApi { studentId = studentId };
        var res = await ApiHelper.PostAsync("api/Fees/getStudentPendingFees", payload, HttpContext.Current);

        if (res == null || res.response_code != "200")
            return null;

        try
        {
            var json = JsonConvert.SerializeObject(res.obj);
            return JsonConvert.DeserializeObject<List<FeePendingInstallmentApi>>(json);
        }
        catch
        {
            return null;
        }
    }

    private GetStudentsApi TryGetStudentFromCache(int studentId)
    {
        try
        {
            var raw = ViewState["studentsCache"] as string;
            if (string.IsNullOrWhiteSpace(raw)) return null;
            var list = JsonConvert.DeserializeObject<List<GetStudentsApi>>(raw);
            if (list == null) return null;
            return list.FirstOrDefault(x => x.id.HasValue && x.id.Value == studentId);
        }
        catch { return null; }
    }

    private static string FormatInstallmentText(FeePendingInstallmentApi i)
    {
        var due = i != null && i.due_date.HasValue ? i.due_date.Value.ToString("dd-MMM-yyyy") : "-";
        var bal = i != null && i.balance.HasValue ? i.balance.Value.ToString("0.00") : "0.00";
        var no = i != null && i.installment_no.HasValue ? i.installment_no.Value.ToString() : "-";
        return "Inst #" + no + " | Due: " + due + " | Balance: " + bal;
    }

    private void BindInstallments(List<FeePendingInstallmentApi> installments)
    {
        ddlInstallment.Items.Clear();
        ddlInstallment.Items.Add(new ListItem("-- Select Installment --", ""));

        if (installments == null)
            return;

        foreach (var i in installments
            .Where(x => x != null && x.installment_id.HasValue)
            .OrderBy(x => x.due_date ?? DateTime.MaxValue))
        {
            ddlInstallment.Items.Add(new ListItem(FormatInstallmentText(i), i.installment_id.Value.ToString(CultureInfo.InvariantCulture)));
        }

        // Auto-select the first payable installment.
        var firstPayable = installments
            .Where(x => x != null && x.installment_id.HasValue && (x.balance ?? 0m) > 0m)
            .OrderBy(x => x.due_date ?? DateTime.MaxValue)
            .FirstOrDefault();

        if (firstPayable != null)
            ddlInstallment.SelectedValue = firstPayable.installment_id.Value.ToString(CultureInfo.InvariantCulture);

        ApplySelectedInstallmentDefaults();
    }

    protected void ddlInstallment_SelectedIndexChanged(object sender, EventArgs e)
    {
        ApplySelectedInstallmentDefaults();
    }

    private void ApplySelectedInstallmentDefaults()
    {
        var raw = ViewState["pendingInstallments"] as string;
        if (string.IsNullOrWhiteSpace(raw))
        {
            litSelectedInstallmentBalance.Text = "-";
            return;
        }

        var installments = JsonConvert.DeserializeObject<List<FeePendingInstallmentApi>>(raw) ?? new List<FeePendingInstallmentApi>();

        int installmentId;
        if (!int.TryParse(ddlInstallment.SelectedValue, out installmentId))
        {
            litSelectedInstallmentBalance.Text = "-";
            return;
        }

        var selected = installments.FirstOrDefault(x => x != null && x.installment_id.HasValue && x.installment_id.Value == installmentId);
        var balance = selected != null ? (selected.balance ?? 0m) : 0m;

        litSelectedInstallmentBalance.Text = balance.ToString("C", CultureInfo.CurrentCulture);

        btnProcessPayment.Enabled = balance > 0m;
        txtPaymentAmount.Text = balance > 0m ? balance.ToString("F2", CultureInfo.InvariantCulture) : "0.00";
        rvPaymentAmount.MaximumValue = balance.ToString(CultureInfo.InvariantCulture);
    }

    private async Task LoadStudentFeeDetailsAsync(int studentId)
    {
        var cached = TryGetStudentFromCache(studentId);
        if (cached != null)
        {
            litStudentDetails.Text = string.Format("Code: {0}, Class: {1}", cached.studentCode, cached.className);
            litFeeStudentName.Text = (cached.firstName + " " + cached.lastName).Trim();
        }
        else
        {
            litStudentDetails.Text = "Student selected.";
            litFeeStudentName.Text = string.Empty;
        }

        var installments = await GetPendingInstallmentsAsync(studentId);
        if (installments == null)
        {
            ClearFeeDetails();
            ScriptManager.RegisterStartupScript(this, GetType(), "feeerr", "alert('Unable to load pending fees.');", true);
            return;
        }

        decimal totalDue = installments.Sum(x => x.due_amount ?? 0m);
        decimal totalPaid = installments.Sum(x => x.paid_amount ?? 0m);
        decimal totalBalance = installments.Sum(x => x.balance ?? 0m);

        litTotalFees.Text = totalDue.ToString("C", CultureInfo.CurrentCulture);
        litAmountPaid.Text = totalPaid.ToString("C", CultureInfo.CurrentCulture);
        litBalanceDue.Text = totalBalance.ToString("C", CultureInfo.CurrentCulture);

        var nextDue = installments.Where(x => x.due_date.HasValue).OrderBy(x => x.due_date.Value).FirstOrDefault();
        litDueDate.Text = nextDue != null && nextDue.due_date.HasValue ? nextDue.due_date.Value.ToShortDateString() : "-";

        string status;
        string cls;
        if (totalBalance <= 0) { status = "Paid"; cls = "badge-paid"; }
        else if (totalPaid > 0) { status = "Partial"; cls = "badge-partial"; }
        else { status = "Pending"; cls = "badge-pending"; }

        feeStatusBadge.InnerText = status;
        feeStatusBadge.Attributes["class"] = "badge rounded-pill " + cls;

        pnlFeeDetails.Visible = true;
        btnProcessPayment.Enabled = totalBalance > 0;
        txtPaymentAmount.Text = totalBalance > 0 ? totalBalance.ToString("F2") : "0.00";
        rvPaymentAmount.MaximumValue = totalBalance.ToString(CultureInfo.InvariantCulture);

        ViewState["pendingInstallments"] = JsonConvert.SerializeObject(installments);
        BindInstallments(installments);
    }

    private void ClearFeeDetails()
    {
        pnlFeeDetails.Visible = false;
        btnProcessPayment.Enabled = false;
        litStudentDetails.Text = "Select a student to view details.";
        litFeeStudentName.Text = string.Empty;
        litTotalFees.Text = litAmountPaid.Text = litBalanceDue.Text = string.Empty;
        litDueDate.Text = string.Empty;
        feeStatusBadge.InnerText = string.Empty;
        ViewState.Remove("pendingInstallments");
        try
        {
            ddlInstallment.Items.Clear();
            ddlInstallment.Items.Add(new ListItem("-- Select Installment --", ""));
            litSelectedInstallmentBalance.Text = "-";
        }
        catch { }
    }

    protected void btnProcessPayment_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(ddlStudent.SelectedValue)) return;

        int studentId = int.Parse(ddlStudent.SelectedValue);

        RegisterAsyncTask(new PageAsyncTask(async () =>
        {
            try
            {
                var raw = ViewState["pendingInstallments"] as string;
                if (string.IsNullOrWhiteSpace(raw))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "nop", "alert('No pending installment loaded.');", true);
                    return;
                }

                var installments = JsonConvert.DeserializeObject<List<FeePendingInstallmentApi>>(raw);
                if (installments == null) installments = new List<FeePendingInstallmentApi>();

                int installmentId;
                if (!int.TryParse(ddlInstallment.SelectedValue, out installmentId))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "selinst", "alert('Please select an installment.');", true);
                    return;
                }

                var target = installments.FirstOrDefault(x => x != null && x.installment_id.HasValue && x.installment_id.Value == installmentId);
                if (target == null || !target.installment_id.HasValue)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "badinst", "alert('Selected installment is not available. Refresh and try again.');", true);
                    return;
                }

                if ((target.balance ?? 0m) <= 0m)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "nobal", "alert('Selected installment has no pending balance.');", true);
                    return;
                }

                decimal paymentAmount;
                if (!decimal.TryParse(txtPaymentAmount.Text, NumberStyles.Any, CultureInfo.InvariantCulture, out paymentAmount) &&
                    !decimal.TryParse(txtPaymentAmount.Text, NumberStyles.Any, CultureInfo.CurrentCulture, out paymentAmount))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "badamt", "alert('Invalid payment amount.');", true);
                    return;
                }

                DateTime paymentDate;
                if (!DateTime.TryParse(txtPaymentDate.Text, out paymentDate))
                    paymentDate = DateTime.Today;

                var req = new FeePaymentRequestApi
                {
                    student_id = studentId,
                    installment_id = target.installment_id,
                    payment_date = paymentDate,
                    amount_paid = paymentAmount,
                    payment_mode = ddlPaymentMethod.SelectedValue,
                    transaction_no = string.IsNullOrWhiteSpace(txtRemarks.Text) ? null : txtRemarks.Text.Trim(),
                    academic_year_id = null,
                    created_by_id = null
                };

                var res = await ApiHelper.PostAsync("api/Fees/recordPartialPayment", req, HttpContext.Current);
                if (res == null || res.response_code != "200")
                {
                    string err = res != null && res.obj != null ? res.obj.ToString() : "Payment failed.";
                    err = err.Replace("'", "\\'");
                    ScriptManager.RegisterStartupScript(this, GetType(), "paybad", "alert('" + err + "');", true);
                    return;
                }

                await LoadStudentFeeDetailsAsync(studentId);

                ScriptManager.RegisterStartupScript(this, GetType(), "payok", "alert('Payment processed successfully.');", true);
            }
            catch (Exception ex)
            {
                string msg = ex.Message.Replace("'", "\\'");
                ScriptManager.RegisterStartupScript(this, GetType(), "payerr", "alert('" + msg + "');", true);
            }
        }));
    }
}

using System;
using System.Collections.Generic;

public class FeeDueFilterApi
{
    public int? studentId { get; set; }
}

public class FeePendingInstallmentApi
{
    public int? installment_id { get; set; }
    public int? fee_structure_id { get; set; }
    public int? installment_no { get; set; }
    public DateTime? due_date { get; set; }
    public decimal? due_amount { get; set; }
    public decimal? paid_amount { get; set; }
    public decimal? balance { get; set; }
    public string status { get; set; }
}

public class FeePaymentRequestApi
{
    public int? student_id { get; set; }
    public int? installment_id { get; set; }
    public DateTime? payment_date { get; set; }
    public decimal? amount_paid { get; set; }
    public string payment_mode { get; set; }
    public string transaction_no { get; set; }
    public int? academic_year_id { get; set; }
    public int? created_by_id { get; set; }
}

public class FeePaymentResultApi
{
    public int fee_payment_id { get; set; }
    public string receipt_number { get; set; }
    public DateTime? payment_date { get; set; }
    public decimal amount_paid { get; set; }
    public decimal? due_amount_before { get; set; }
    public decimal? paid_amount_before { get; set; }
    public decimal? due_amount_after { get; set; }
    public decimal? paid_amount_after { get; set; }
    public string due_status_after { get; set; }
}

public class OutstandingFeesFilterApi
{
    public int? classId { get; set; }
    public int? studentId { get; set; }
    public int? academicYearId { get; set; }
    public DateTime? dueFrom { get; set; }
    public DateTime? dueTo { get; set; }
    public bool? onlyOverdue { get; set; }
}

public class OutstandingFeeItemApi
{
    public int student_id { get; set; }
    public string student_code { get; set; }
    public string student_name { get; set; }

    public int class_id { get; set; }
    public string class_name { get; set; }

    public int installment_id { get; set; }
    public int installment_no { get; set; }
    public DateTime due_date { get; set; }

    public decimal due_amount { get; set; }
    public decimal paid_amount { get; set; }
    public decimal outstanding_amount { get; set; }

    public int days_overdue { get; set; }
}

public class OutstandingFeesReportApi
{
    public decimal total_due { get; set; }
    public decimal total_paid { get; set; }
    public decimal total_outstanding { get; set; }
    public int total_students { get; set; }
    public int total_installments { get; set; }
    public List<OutstandingFeeItemApi> items { get; set; }
}

public class FeeReminderQueueFilter
{
    public int? classId { get; set; }
    public int? academicYearId { get; set; }
    public DateTime? dueBefore { get; set; }
    public bool? onlyOverdue { get; set; }
    public int? maxRecipients { get; set; }
}

public class FeeReminderQueueItem
{
    public int id { get; set; }
    public int student_id { get; set; }
    public int installment_id { get; set; }
    public DateTime? due_date { get; set; }
    public decimal outstanding_amount { get; set; }
    public string phone { get; set; }
    public string message { get; set; }
    public string status { get; set; }
    public int try_count { get; set; }
    public DateTime? last_try_at { get; set; }
}

using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Dashboard_admin_fee_reminders : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDueBefore.Text = DateTime.Today.ToString("yyyy-MM-dd");
            txtMaxRecipients.Text = "200";
            txtMaxBatch.Text = "25";
            chkOnlyOverdue.Checked = true;

            RegisterAsyncTask(new PageAsyncTask(LoadQueueAsync));
        }
    }

    protected void btnQueue_Click(object sender, EventArgs e)
    {
        RegisterAsyncTask(new PageAsyncTask(async () =>
        {
            DateTime dueBefore;
            DateTime? dueBeforeOpt = null;
            if (DateTime.TryParse(txtDueBefore.Text, out dueBefore))
                dueBeforeOpt = dueBefore;

            int maxRecipients;
            int? maxRecipientsOpt = null;
            if (int.TryParse(txtMaxRecipients.Text, out maxRecipients))
                maxRecipientsOpt = maxRecipients;

            var payload = new FeeReminderQueueFilter
            {
                classId = null,
                academicYearId = null,
                dueBefore = dueBeforeOpt,
                onlyOverdue = chkOnlyOverdue.Checked,
                maxRecipients = maxRecipientsOpt
            };

            var res = await ApiHelper.PostAsync("api/Fees/queueFeeWhatsappReminders", payload, HttpContext.Current);
            if (res != null && res.response_code == "200")
            {
                lblResult.CssClass = "text-success";
                lblResult.Text = "Queued.";
            }
            else
            {
                lblResult.CssClass = "text-danger";
                lblResult.Text = res != null && res.obj != null ? res.obj.ToString() : "Failed to queue.";
            }

            await LoadQueueAsync();
        }));
    }

    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        RegisterAsyncTask(new PageAsyncTask(LoadQueueAsync));
    }

    protected void btnSendBatch_Click(object sender, EventArgs e)
    {
        RegisterAsyncTask(new PageAsyncTask(async () =>
        {
            int maxBatch;
            if (!int.TryParse(txtMaxBatch.Text, out maxBatch))
                maxBatch = 25;

            var res = await ApiHelper.PostAsync("api/Fees/sendFeeWhatsappRemindersBatch", new { maxBatch = (int?)maxBatch }, HttpContext.Current);
            if (res != null && res.response_code == "200")
            {
                lblResult.CssClass = "text-success";
                lblResult.Text = "Send attempted.";
            }
            else
            {
                lblResult.CssClass = "text-danger";
                lblResult.Text = res != null && res.obj != null ? res.obj.ToString() : "Failed to send batch.";
            }

            await LoadQueueAsync();
        }));
    }

    private async Task LoadQueueAsync()
    {
        int maxBatch;
        if (!int.TryParse(txtMaxBatch.Text, out maxBatch))
            maxBatch = 25;

        var res = await ApiHelper.PostAsync("api/Fees/getFeeWhatsappRemindersToSend", new { maxBatch = maxBatch }, HttpContext.Current);
        if (res != null && res.response_code == "200")
        {
            var json = JsonConvert.SerializeObject(res.obj);
            var list = JsonConvert.DeserializeObject<List<FeeReminderQueueItem>>(json) ?? new List<FeeReminderQueueItem>();

            gvQueue.DataSource = list;
            gvQueue.DataBind();

            if (string.IsNullOrWhiteSpace(lblResult.Text))
            {
                lblResult.CssClass = "text-muted";
                lblResult.Text = "Loaded " + list.Count.ToString(CultureInfo.InvariantCulture) + " queued reminders.";
            }
        }
        else
        {
            gvQueue.DataSource = new List<FeeReminderQueueItem>();
            gvQueue.DataBind();

            lblResult.CssClass = "text-danger";
            lblResult.Text = res != null && res.obj != null ? res.obj.ToString() : "Failed to load queue.";
        }
    }

    protected void gvQueue_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandArgument == null) return;

        int id;
        if (!int.TryParse(Convert.ToString(e.CommandArgument), out id))
            return;

        if (string.Equals(e.CommandName, "MarkSent", StringComparison.OrdinalIgnoreCase))
        {
            RegisterAsyncTask(new PageAsyncTask(async () =>
            {
                var res = await ApiHelper.PostAsync("api/Fees/markFeeWhatsappReminderSent", new { id = (int?)id, providerMessageId = (string)null }, HttpContext.Current);
                if (res != null && res.response_code == "200")
                {
                    lblResult.CssClass = "text-success";
                    lblResult.Text = "Marked sent.";
                }
                else
                {
                    lblResult.CssClass = "text-danger";
                    lblResult.Text = res != null && res.obj != null ? res.obj.ToString() : "Failed.";
                }

                await LoadQueueAsync();
            }));
        }
        else if (string.Equals(e.CommandName, "MarkFailed", StringComparison.OrdinalIgnoreCase))
        {
            RegisterAsyncTask(new PageAsyncTask(async () =>
            {
                var res = await ApiHelper.PostAsync("api/Fees/markFeeWhatsappReminderFailed", new { id = (int?)id, error = "Marked failed from UI" }, HttpContext.Current);
                if (res != null && res.response_code == "200")
                {
                    lblResult.CssClass = "text-success";
                    lblResult.Text = "Marked failed.";
                }
                else
                {
                    lblResult.CssClass = "text-danger";
                    lblResult.Text = res != null && res.obj != null ? res.obj.ToString() : "Failed.";
                }

                await LoadQueueAsync();
            }));
        }
    }
}

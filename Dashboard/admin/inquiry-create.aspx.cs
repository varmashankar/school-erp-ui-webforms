using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Dashboard_admin_inquiry_create : System.Web.UI.Page
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
            txtNextFollowUpAt.Text = DateTime.Now.AddDays(1).ToString("yyyy-MM-ddTHH:mm");
            RegisterAsyncTask(new PageAsyncTask(LoadDropdowns));
        }
    }

    private async System.Threading.Tasks.Task LoadDropdowns()
    {
        InquiryCaptureHelper.BindDropdownFromList(ddlClass, "-- Select Class --");
        InquiryCaptureHelper.BindDropdownFromList(ddlStream, "-- Select Stream --");

        try
        {
            var classRes = await ApiHelper.PostAsync("api/Classes/getClassList", new { }, HttpContext.Current);
            if (classRes != null && classRes.response_code == "200" && classRes.obj != null)
            {
                foreach (var x in InquiryCaptureHelper.DeserializeList(classRes.obj))
                {
                    object v;
                    object n;
                    var id = x.TryGetValue("id", out v) ? Convert.ToString(v) : null;
                    var name = x.TryGetValue("className", out n) ? Convert.ToString(n) : (x.TryGetValue("class_name", out n) ? Convert.ToString(n) : null);
                    if (!string.IsNullOrWhiteSpace(id) && !string.IsNullOrWhiteSpace(name))
                        ddlClass.Items.Add(new ListItem(name, id));
                }
            }

            var streamRes = await ApiHelper.PostAsync("api/Streams/getStreamList", new { }, HttpContext.Current);
            if (streamRes != null && streamRes.response_code == "200" && streamRes.obj != null)
            {
                foreach (var x in InquiryCaptureHelper.DeserializeList(streamRes.obj))
                {
                    object v;
                    object n;
                    var id = x.TryGetValue("id", out v) ? Convert.ToString(v) : null;
                    var name = x.TryGetValue("streamName", out n) ? Convert.ToString(n) : (x.TryGetValue("stream_name", out n) ? Convert.ToString(n) : null);
                    if (!string.IsNullOrWhiteSpace(id) && !string.IsNullOrWhiteSpace(name))
                        ddlStream.Items.Add(new ListItem(name, id));
                }
            }
        }
        catch (Exception ex)
        {
            lblInfo.Text = "Error loading dropdowns: " + ex.Message;
        }
    }

    private bool ValidateRequired(out string message)
    {
        var firstName = InquiryCaptureHelper.Require(txtFirstName.Text);
        var lastName = InquiryCaptureHelper.Require(txtLastName.Text);
        var phone = InquiryCaptureHelper.RequirePhone(txtPhone.Text);
        var email = InquiryCaptureHelper.Require(txtEmail.Text);
        var source = InquiryCaptureHelper.Require(txtSource.Text);

        if (string.IsNullOrWhiteSpace(firstName)) { message = "First name is required."; return false; }
        if (string.IsNullOrWhiteSpace(lastName)) { message = "Last name is required."; return false; }
        if (string.IsNullOrWhiteSpace(phone)) { message = "Phone is required."; return false; }
        if (string.IsNullOrWhiteSpace(email)) { message = "Email is required."; return false; }
        if (string.IsNullOrWhiteSpace(source)) { message = "Source is required."; return false; }
        if (string.IsNullOrWhiteSpace(ddlClass.SelectedValue)) { message = "Class is required."; return false; }
        if (string.IsNullOrWhiteSpace(ddlStream.SelectedValue)) { message = "Stream is required."; return false; }

        message = null;
        return true;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        RegisterAsyncTask(new PageAsyncTask(async () =>
        {
            string message;
            if (!ValidateRequired(out message))
            {
                message = message.Replace("'", "\\'");
                ScriptManager.RegisterStartupScript(this, GetType(), "bad", "Swal.fire('ERROR','" + message + "','error');", true);
                return;
            }

            var payload = new
            {
                id = (long?)null,
                inquiryNo = (string)null,
                firstName = InquiryCaptureHelper.Require(txtFirstName.Text),
                lastName = InquiryCaptureHelper.Require(txtLastName.Text),
                phone = InquiryCaptureHelper.RequirePhone(txtPhone.Text),
                email = InquiryCaptureHelper.Require(txtEmail.Text),
                classId = InquiryCaptureHelper.ParseLong(ddlClass.SelectedValue),
                streamId = InquiryCaptureHelper.ParseLong(ddlStream.SelectedValue),
                source = InquiryCaptureHelper.Require(txtSource.Text),
                notes = InquiryCaptureHelper.Require(txtNotes.Text),
                status = "NEW",
                nextFollowUpAt = InquiryCaptureHelper.ParseDateTimeLocal(txtNextFollowUpAt.Text),
                convertedStudentId = (long?)null,
                createdById = (long?)null,
                roleId = (long?)null
            };

            var res = await ApiHelper.PostAsync("api/Inquiries/saveInquiry", payload, HttpContext.Current);
            if (res != null && res.response_code == "200")
            {
                var msg = (res.obj == null ? "Inquiry saved." : res.obj.ToString()).Replace("'", "\\'");
                ScriptManager.RegisterStartupScript(this, GetType(), "ok", "Swal.fire('SUCCESS','" + msg + "','success');", true);

                ClearForm(keepDefaults: true);
                return;
            }

            var err = (res != null && res.obj != null) ? res.obj.ToString() : "Failed to save inquiry.";
            err = err.Replace("'", "\\'");
            ScriptManager.RegisterStartupScript(this, GetType(), "err", "Swal.fire('ERROR','" + err + "','error');", true);
        }));
    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        ClearForm(keepDefaults: true);
    }

    private void ClearForm(bool keepDefaults)
    {
        txtFirstName.Text = string.Empty;
        txtLastName.Text = string.Empty;
        txtPhone.Text = string.Empty;
        txtEmail.Text = string.Empty;
        txtSource.Text = string.Empty;
        txtNotes.Text = string.Empty;

        if (ddlClass.Items.Count > 0) ddlClass.SelectedIndex = 0;
        if (ddlStream.Items.Count > 0) ddlStream.SelectedIndex = 0;

        if (keepDefaults)
            txtNextFollowUpAt.Text = DateTime.Now.AddDays(1).ToString("yyyy-MM-ddTHH:mm");
        else
            txtNextFollowUpAt.Text = string.Empty;

        lblInfo.Text = string.Empty;
    }
}

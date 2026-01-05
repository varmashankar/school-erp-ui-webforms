using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Threading.Tasks;

public partial class Dashboard_admin_admissionform : System.Web.UI.Page
{
    private int? EditingStudentId
    {
        get
        {
            object o = ViewState["EditingStudentId"];
            if (o == null) return null;
            return (int)o;
        }
        set { ViewState["EditingStudentId"] = value; }
    }

    protected async void Page_Load(object sender, EventArgs e)
    {
        if (Session["authToken"] == null)
        {
            Response.Redirect("~/login.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
            return;
        }

        if (!IsPostBack)
        {
            await LoadClassList();

            // Edit mode: encrypted numeric id in querystring
            string encId = Request.QueryString["id"];
            if (!string.IsNullOrWhiteSpace(encId))
            {
                await InitEditMode(encId);
                return;
            }

            // Create mode
            await LoadAdmissionIdFromApi();
            await LoadStudentIdFromApi();
        }
    }

    private async Task InitEditMode(string encId)
    {
        string decrypted = CryptoHelper.Decrypt(encId);
        int id;
        if (!int.TryParse(decrypted, out id))
        {
            ShowMessage("Invalid student id.", "warning");
            return;
        }

        EditingStudentId = id;

        // Titles are optional (avoid compile issues if markup changes)
        if (litPageTitle != null) litPageTitle.Text = "Edit Student";
        if (litFormTitle != null) litFormTitle.Text = "Update Student";
        if (btnSaveStep1 != null) btnSaveStep1.Text = "Update Student";

        await LoadStudentForEdit(id);
    }

    private async Task LoadStudentForEdit(int id)
    {
        try
        {
            ApiResponse res = await ApiHelper.PostAsync("api/Students/getStudentDetails", new { id = id }, HttpContext.Current);

            if (res == null)
            {
                ShowMessage("No response from server.", "danger");
                return;
            }

            if (res.response_code != "200" || res.obj == null)
            {
                ShowMessage(res.obj == null ? "Unable to load student." : res.obj.ToString(), "warning");
                return;
            }

            // API may return object or array; normalize
            var json = JsonConvert.SerializeObject(res.obj);
            JToken tok = JToken.Parse(json);
            JObject student = tok.Type == JTokenType.Array ? (JObject)tok.First : (JObject)tok;

            if (student == null)
            {
                ShowMessage("Student not found.", "warning");
                return;
            }

            // Preserve codes (backend requires studentCode only for create)
            hfStudentId.Value = student["studentCode"] == null ? "" : student["studentCode"].ToString();

            // admissionNo may come as admissionNo or admission_no depending on API/SP mapping
            string admissionNo = "";
            if (student["admissionNo"] != null) admissionNo = student["admissionNo"].ToString();
            else if (student["admission_no"] != null) admissionNo = student["admission_no"].ToString();
            hfAdmissionId.Value = admissionNo ?? "";

            txtFirstName.Text = student["firstName"] == null ? "" : student["firstName"].ToString();
            txtMiddleName.Text = student["middleName"] == null ? "" : student["middleName"].ToString();
            txtLastName.Text = student["lastName"] == null ? "" : student["lastName"].ToString();

            txtDob.Text = student["dob"] == null ? "" : student["dob"].ToString();
            ddlGender.SelectedValue = student["gender"] == null ? "" : student["gender"].ToString();
            ddlBloodGroup.SelectedValue = student["bloodGroup"] == null ? "" : student["bloodGroup"].ToString();

            txtNationality.Text = student["nationality"] == null ? "" : student["nationality"].ToString();
            txtReligion.Text = student["religion"] == null ? "" : student["religion"].ToString();
            txtAadhar.Text = student["nationIdNumber"] == null ? "" : student["nationIdNumber"].ToString();

            txtEmail.Text = student["email"] == null ? "" : student["email"].ToString();
            txtPhone.Text = student["phone"] == null ? "" : student["phone"].ToString();
            txtAdmissionDate.Text = student["admissionDate"] == null ? "" : student["admissionDate"].ToString();

            string classId = student["classId"] == null ? "" : student["classId"].ToString();
            if (!string.IsNullOrWhiteSpace(classId) && ddlClass.Items.FindByValue(classId) != null)
                ddlClass.SelectedValue = classId;

            txtSiblingInfo.Text = student["siblingInfo"] == null ? "" : student["siblingInfo"].ToString();
            txtAddress.Text = student["address"] == null ? "" : student["address"].ToString();
            txtMedicalInfo.Text = student["medicalInfo"] == null ? "" : student["medicalInfo"].ToString();
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading student: " + ex.Message, "danger");
        }
    }

    private async Task LoadClassList()
    {
        ddlClass.Items.Clear();
        ddlClass.Items.Add(new ListItem("-- Select Class --", ""));

        try
        {
            ApiResponse res = await ApiHelper.PostAsync("api/Classes/getClassList", new { }, HttpContext.Current);

            if(res != null && res.response_code == "200" && res.obj != null)
            {
                var classList = Newtonsoft.Json.JsonConvert.DeserializeObject < List < Dictionary<string, object>>>(res.obj.ToString());

                foreach (var item in classList)
                {
                    // Safe read of id
                    string id = item.ContainsKey("id") && item["id"] != null
                                ? item["id"].ToString()
                                : "";

                    // Safe read of class name
                    string className = item.ContainsKey("className") && item["className"] != null
                                       ? item["className"].ToString()
                                       : "";

                    // Safe read of section (optional)
                    string section = item.ContainsKey("section") && item["section"] != null
                                     ? item["section"].ToString()
                                     : "";

                    string displayText = section != ""
                                            ? className + " " + section
                                            : className;

                    ddlClass.Items.Add(new ListItem(displayText, id));
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error generating Admission ID: " + ex.Message, "danger");
        }
    }

    // ---------------------------------------------
    // GET NEW ADMISSION ID FROM BACKEND
    // ---------------------------------------------
    private async Task LoadAdmissionIdFromApi()
    {
        try
        {
            ApiResponse res = await ApiHelper.PostAsync("api/Students/generateAdmissionId", new { }, HttpContext.Current);

            if (res != null && res.response_code == "200")
            {
                hfAdmissionId.Value = res.obj == null ? "" : res.obj.ToString();
            }
            else
            {
                ShowMessage("Unable to generate Admission ID", "warning");
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error generating Admission ID: " + ex.Message, "danger");
        }
    }

    // ---------------------------------------------
    // GET NEW STUDENT ID (STU-YYYY-0001)
    // ---------------------------------------------
    private async Task LoadStudentIdFromApi()
    {
        try
        {
            ApiResponse res = await ApiHelper.PostAsync("api/Students/generateStudentId", new { }, HttpContext.Current);

            if (res != null && res.response_code == "200")
            {
                hfStudentId.Value = res.obj == null ? "" : res.obj.ToString();
            }
            else
            {
                ShowMessage("Unable to generate Student ID", "warning");
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error generating Student ID: " + ex.Message, "danger");
        }
    }

    // ---------------------------------------------
    // SAVE STUDENT STEP-1
    // ---------------------------------------------
    protected async void btnSaveStep1_Click(object sender, EventArgs e)
    {
        try
        {
            string token = Session["authToken"] == null ? null : Session["authToken"].ToString();

            if (string.IsNullOrEmpty(token))
            {
                ShowMessage("Authentication token missing. Please login again.", "danger");
                return;
            }

            // Manual validation
            if (txtFirstName.Text.Trim() == "")
            {
                ShowMessage("First Name is required.", "warning");
                return;
            }

            if (txtLastName.Text.Trim() == "")
            {
                ShowMessage("Last Name is required.", "warning");
                return;
            }

            if (ddlClass.SelectedValue.Trim() == "")
            {
                ShowMessage("Please select a class.", "warning");
                return;
            }

            bool isEdit = EditingStudentId.HasValue;

            // IMPORTANT: On edit, do not send empty admissionNo (it can violate unique index in student_admissions)
            string admissionNoToSend = hfAdmissionId.Value == null ? "" : hfAdmissionId.Value.Trim();
            if (isEdit && string.IsNullOrWhiteSpace(admissionNoToSend))
            {
                ApiResponse existing = await ApiHelper.PostAsync("api/Students/getStudentDetails", new { id = EditingStudentId.Value }, HttpContext.Current);
                if (existing != null && existing.response_code == "200" && existing.obj != null)
                {
                    try
                    {
                        var j = JsonConvert.SerializeObject(existing.obj);
                        JToken t = JToken.Parse(j);
                        JObject s = t.Type == JTokenType.Array ? (JObject)t.First : (JObject)t;
                        if (s != null)
                        {
                            if (s["admissionNo"] != null) admissionNoToSend = Convert.ToString(s["admissionNo"]);
                            else if (s["admission_no"] != null) admissionNoToSend = Convert.ToString(s["admission_no"]);
                        }
                    }
                    catch { }
                }
            }

            // Build student object EXACTLY as backend expects
            var student = new
            {
                id = isEdit ? (int?)EditingStudentId.Value : null,

                studentCode = hfStudentId.Value.Trim(),
                admissionNo = admissionNoToSend,

                firstName = txtFirstName.Text.Trim(),
                middleName = txtMiddleName.Text.Trim(),
                lastName = txtLastName.Text.Trim(),
                dob = txtDob.Text,
                gender = ddlGender.SelectedValue,
                bloodGroup = ddlBloodGroup.SelectedValue,
                nationality = txtNationality.Text.Trim(),
                religion = txtReligion.Text.Trim(),
                nationIdNumber = txtAadhar.Text.Trim(),
                email = txtEmail.Text.Trim(),
                phone = txtPhone.Text.Trim(),
                admissionDate = txtAdmissionDate.Text,

                classId = ddlClass.SelectedValue,

                siblingInfo = txtSiblingInfo.Text.Trim(),
                address = txtAddress.Text.Trim(),
                medicalInfo = txtMedicalInfo.Text.Trim(),

                deleted = false,
                status = true
            };

            ApiResponse apiRes = await ApiHelper.PostAsync("api/Students/saveStudents", student, HttpContext.Current);

            if (apiRes == null)
            {
                ShowMessage("No response from server.", "danger");
                return;
            }

            if (apiRes.response_code == "200")
            {
                if (isEdit)
                {
                    string script = @"
                    Swal.fire({
                        title: 'Success',
                        text: 'The student record has been updated successfully.',
                        icon: 'success'
                    }).then(() => { window.location = 'students.aspx'; });";

                    ScriptManager.RegisterStartupScript(this, GetType(), "studentUpdateSuccess", script, true);
                    return;
                }

                // Prefer DB numeric id returned by API for details page
                string encStudentDbId = null;
                try
                {
                    var json = JsonConvert.SerializeObject(apiRes.obj);
                    dynamic obj = JsonConvert.DeserializeObject(json);
                    if (obj != null && obj.id != null)
                        encStudentDbId = CryptoHelper.Encrypt(Convert.ToString(obj.id));
                }
                catch { }

                string createScript;
                if (!string.IsNullOrWhiteSpace(encStudentDbId))
                {
                    createScript = @"
                Swal.fire({
                    title: 'Success',
                    text: 'The student record has been saved successfully.',
                    icon: 'success',
                    showCancelButton: true,
                    confirmButtonText: 'Add Student Details',
                    cancelButtonText: 'Add Another Student'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location = 'addstudentdetails.aspx?id=" + encStudentDbId + @"';
                    } else {
                        window.location = 'admissionform.aspx';
                    }
                });
            ";
                }
                else
                {
                    // Fallback to old behavior if API didn't return id
                    string sid = CryptoHelper.Encrypt(hfStudentId.Value.Trim());

                    createScript = @"
                Swal.fire({
                    title: 'Success',
                    text: 'The student record has been saved successfully.',
                    icon: 'success',
                    showCancelButton: true,
                    confirmButtonText: 'Add Student Details',
                    cancelButtonText: 'Add Another Student'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location = 'addstudentdetails.aspx?sid=" + sid + @"';
                    } else {
                        window.location = 'admissionform.aspx';
                    }
                });
            ";
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "studentSuccess", createScript, true);
            }
            else
            {
                string message = apiRes.obj == null ? "Unknown error" : apiRes.obj.ToString();

                // If API returns {message:"..."}, prefer that
                try
                {
                    var json = JsonConvert.SerializeObject(apiRes.obj);
                    dynamic obj = JsonConvert.DeserializeObject(json);
                    if (obj != null && obj.message != null)
                        message = Convert.ToString(obj.message);
                }
                catch { }

                ShowMessage("Failed: " + message, "danger");
            }

        }
        catch (Exception ex)
        {
            ShowMessage("Error: " + ex.Message, "danger");
        }
    }

    // ---------------------------------------------
    // ALERT POPUP
    // ---------------------------------------------
    private void ShowMessage(string message, string type)
    {
        if (message == null) message = "";

        // FULL SANITIZATION FOR JS STRING
        message = message.Replace("\\", "\\\\")
                         .Replace("'", "\\'")
                         .Replace("\"", "\\\"")
                         .Replace("\r", "")
                         .Replace("\n", " ");

        string script = "Swal.fire('" + type.ToUpper() + "', '" + message + "', '" + type + "');";

        ClientScript.RegisterStartupScript(this.GetType(), "alert", script, true);
    }


    // ---------------------------------------------
    // CLEAR FORM
    // ---------------------------------------------
    private void ClearForm()
    {
        txtFirstName.Text = "";
        txtMiddleName.Text = "";
        txtLastName.Text = "";
        txtDob.Text = "";
        ddlGender.SelectedIndex = 0;
        ddlBloodGroup.SelectedIndex = 0;
        txtNationality.Text = "";
        txtReligion.Text = "";
        txtAadhar.Text = "";
        txtEmail.Text = "";
        txtPhone.Text = "";
        txtAdmissionDate.Text = "";
        ddlClass.SelectedIndex = 0;
        ddlTransport.SelectedIndex = 0;
        txtSiblingInfo.Text = "";
        txtAddress.Text = "";
        txtMedicalInfo.Text = "";
    }
}

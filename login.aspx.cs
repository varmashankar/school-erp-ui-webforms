using Newtonsoft.Json;
using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

public partial class login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadSchoolInfo();
        }
    }

    private void LoadSchoolInfo()
    {
        try
        {
            var csSetting = System.Configuration.ConfigurationManager.ConnectionStrings["schoolerp"];
            if (csSetting == null) return;
            string cs = csSetting.ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string sql = "SELECT TOP 1 school_name, logo_path FROM dbo.schools WHERE deleted=0 AND status=1 ORDER BY id DESC";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            string name = dr["school_name"] != DBNull.Value ? Convert.ToString(dr["school_name"]) : string.Empty;
                            string logo = dr["logo_path"] != DBNull.Value ? Convert.ToString(dr["logo_path"]) : string.Empty;

                            // Set school name
                            litSchoolName.Text = Server.HtmlEncode(name);
                            litSchoolTag.Text = "Excellence in Education";

                            // Resolve logo URL
                            string resolvedLogoUrl = "assets/images/education.gif"; // fallback
                            if (!string.IsNullOrEmpty(logo))
                            {
                                string appRelative = logo;
                                if (!logo.StartsWith("~") && logo.StartsWith("/"))
                                {
                                    appRelative = "~" + logo;
                                }
                                try
                                {
                                    resolvedLogoUrl = ResolveUrl(appRelative);
                                }
                                catch
                                {
                                    // keep fallback
                                }
                            }

                            // Set logo for both desktop and mobile
                            imgLogo.ImageUrl = resolvedLogoUrl;
                            imgLogo.AlternateText = name;
                            imgLogoMobile.ImageUrl = resolvedLogoUrl;
                            imgLogoMobile.AlternateText = name;
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error loading school info: " + ex.Message);
            // Set defaults on error
            imgLogo.ImageUrl = "assets/images/education.gif";
            imgLogoMobile.ImageUrl = "assets/images/education.gif";
        }
    }

    protected async void btnLogin_Click(object sender, EventArgs e)
    {
        string username = txtUsername.Text.Trim();
        string password = txtPassword.Text.Trim();

        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
        {
            ShowAlert("Username and password are required.", "error");
            return;
        }

        // Match API model casing (API expects: username/password)
        var loginObj = new
        {
            username = username,
            password = password
        };

        try
        {
            ApiResponse apiResponse = await ApiHelper.PostAsync("api/Admin/login", loginObj, HttpContext.Current);

            if (apiResponse == null)
            {
                ShowAlert("No response from server.", "error");
                return;
            }

            string code = apiResponse.response_code == null ? "" : apiResponse.response_code.Trim();

            // SUCCESS
            if (code == "200" && Session["authToken"] != null)
            {
                string js =
                "Swal.fire({" +
                "  title: 'Success'," +
                "  text: 'Login Successful'," +
                "  icon: 'success'," +
                "  timer: 1800," +
                "  timerProgressBar: true," +
                "  showConfirmButton: false" +
                "}).then(() => {" +
                "  window.location='dashboard/dashboard-admin.aspx';" +
                "});";

                ScriptManager.RegisterStartupScript(this, GetType(), "loginSuccess", js, true);
                return;
            }

            string msg = "Login failed";
            if (apiResponse.obj != null)
                msg = apiResponse.obj.ToString();

            ShowAlert(msg, "error");
        }
        catch (Exception ex)
        {
            ShowAlert("Error: " + ex.Message, "error");
        }
    }

    private void ShowAlert(string message, string type)
    {
        message = message.Replace("'", "");

        string script = "Swal.fire({" +
                        "title: '" + (type == "success" ? "Success" : "Error") + "'," +
                        "text: '" + message + "'," +
                        "icon: '" + type + "'" +
                        "});";

        ScriptManager.RegisterStartupScript(this, GetType(), "swalAlert", script, true);
    }
}

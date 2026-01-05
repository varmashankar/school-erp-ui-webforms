using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class _Default : System.Web.UI.Page
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
                string sql = "SELECT TOP 1 school_name, code, address, phone, email, logo_path, current_academic_year_id FROM dbo.schools WHERE deleted=0 AND status=1 ORDER BY id DESC";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            string name = dr["school_name"] != DBNull.Value ? Convert.ToString(dr["school_name"]) : string.Empty;
                            string address = dr["address"] != DBNull.Value ? Convert.ToString(dr["address"]) : string.Empty;
                            string phone = dr["phone"] != DBNull.Value ? Convert.ToString(dr["phone"]) : string.Empty;
                            string email = dr["email"] != DBNull.Value ? Convert.ToString(dr["email"]) : string.Empty;
                            string logo = dr["logo_path"] != DBNull.Value ? Convert.ToString(dr["logo_path"]) : string.Empty;

                            // Populate header controls
                            if (litSchoolName != null)
                                litSchoolName.Text = Server.HtmlEncode(name);
                            if (litSchoolTag != null)
                                litSchoolTag.Text = Server.HtmlEncode("Excellence in Education");

                            // Populate footer controls
                            if (litFooterSchoolName != null)
                                litFooterSchoolName.Text = Server.HtmlEncode(name);
                            if (litFooterSchoolTag != null)
                                litFooterSchoolTag.Text = Server.HtmlEncode("Academy");

                            string resolvedLogoUrl = "https://via.placeholder.com/64x64?text=S";
                            if (!string.IsNullOrEmpty(logo))
                            {
                                // Normalize stored path to an app-relative path if needed and resolve it
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
                                    // keep placeholder
                                }
                            }

                            // Set header logo
                            if (imgLogo != null)
                            {
                                imgLogo.ImageUrl = resolvedLogoUrl;
                                imgLogo.AlternateText = name;
                            }

                            if (hfPhone != null)
                                hfPhone.Value = phone;
                            if (hfEmail != null)
                                hfEmail.Value = email;

                            // Update mailto link client-side (anchor isn't a server control)
                            var emailForHref = (email ?? string.Empty).Replace("\\", "\\\\").Replace("\"", "\\\"");
                            string script = "(function(){var a=document.getElementById('emailLink'); if(a){ a.href='mailto:' + \"" + emailForHref + "\"; }})();";
                            ClientScript.RegisterStartupScript(this.GetType(), "populateMailto", script, true);
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            // fail silently for now
            System.Diagnostics.Debug.WriteLine("Error loading school info: " + ex.Message);
        }
    }
}
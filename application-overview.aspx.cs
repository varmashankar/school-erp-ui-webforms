using System;
using System.Web.UI;

public partial class ApplicationOverview : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        var token = Request.QueryString["token"];
        if (!string.IsNullOrWhiteSpace(token))
        {
            Session["admission_resume_token"] = token;
        }
    }
}

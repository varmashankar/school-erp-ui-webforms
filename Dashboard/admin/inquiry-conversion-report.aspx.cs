using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Dashboard_admin_inquiry_conversion_report : System.Web.UI.Page
{
    private const string ReportTableViewStateKey = "_inquiryConversionReportDt";

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
            BindEmpty("Run the report to see conversion metrics.");
            RegisterAsyncTask(new PageAsyncTask(LoadFilters));
        }
    }

    private void BindEmpty(string message)
    {
        ViewState[ReportTableViewStateKey] = null;

        gvReport.DataSource = new DataTable();
        gvReport.DataBind();
        lblInfo.Text = message ?? "";
        lblRows.Text = "0";
        lblTotalInquiries.Text = "0";
        lblConverted.Text = "0";
        lblConversionRate.Text = "0%";
    }

    private static DateTime? ParseDate(string value)
    {
        if (string.IsNullOrWhiteSpace(value)) return null;

        DateTime dt;
        if (DateTime.TryParseExact(value.Trim(), "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
            return dt;

        return null;
    }

    private static long? ParseLong(string value)
    {
        if (string.IsNullOrWhiteSpace(value)) return null;
        long x;
        if (long.TryParse(value.Trim(), out x)) return x;
        return null;
    }

    private static long? ParseSelectedId(DropDownList ddl)
    {
        if (ddl == null) return null;
        if (string.IsNullOrWhiteSpace(ddl.SelectedValue)) return null;
        return ParseLong(ddl.SelectedValue);
    }

    private static Dictionary<long, string> BuildIdNameMap(DropDownList ddl)
    {
        var map = new Dictionary<long, string>();
        if (ddl == null) return map;

        foreach (ListItem item in ddl.Items)
        {
            long id;
            if (long.TryParse(item.Value, out id) && !map.ContainsKey(id))
                map[id] = item.Text;
        }

        return map;
    }

    private async System.Threading.Tasks.Task LoadFilters()
    {
        try
        {
            ddlClass.Items.Clear();
            ddlClass.Items.Add(new ListItem("All Classes", ""));

            var classRes = await ApiHelper.PostAsync("api/Classes/getClassList", new { }, HttpContext.Current);
            if (classRes != null && classRes.response_code == "200" && classRes.obj != null)
            {
                var json = JsonConvert.SerializeObject(classRes.obj);
                var list = JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(json) ?? new List<Dictionary<string, object>>();

                foreach (var x in list)
                {
                    object idObj;
                    object nameObj;

                    var id = x.TryGetValue("id", out idObj) ? Convert.ToString(idObj) : null;
                    var name = x.TryGetValue("className", out nameObj) ? Convert.ToString(nameObj)
                             : (x.TryGetValue("class_name", out nameObj) ? Convert.ToString(nameObj) : null);

                    if (!string.IsNullOrWhiteSpace(id) && !string.IsNullOrWhiteSpace(name))
                        ddlClass.Items.Add(new ListItem(name, id));
                }
            }

            ddlStream.Items.Clear();
            ddlStream.Items.Add(new ListItem("All Streams", ""));

            var streamRes = await ApiHelper.PostAsync("api/Streams/getStreamList", new { }, HttpContext.Current);
            if (streamRes != null && streamRes.response_code == "200" && streamRes.obj != null)
            {
                var json = JsonConvert.SerializeObject(streamRes.obj);
                var list = JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(json) ?? new List<Dictionary<string, object>>();

                foreach (var x in list)
                {
                    object idObj;
                    object nameObj;

                    var id = x.TryGetValue("id", out idObj) ? Convert.ToString(idObj) : null;
                    var name = x.TryGetValue("streamName", out nameObj) ? Convert.ToString(nameObj)
                             : (x.TryGetValue("stream_name", out nameObj) ? Convert.ToString(nameObj) : null);

                    if (!string.IsNullOrWhiteSpace(id) && !string.IsNullOrWhiteSpace(name))
                        ddlStream.Items.Add(new ListItem(name, id));
                }
            }
        }
        catch
        {
            if (ddlClass.Items.Count == 0) ddlClass.Items.Add(new ListItem("All Classes", ""));
            if (ddlStream.Items.Count == 0) ddlStream.Items.Add(new ListItem("All Streams", ""));
        }
    }

    private async System.Threading.Tasks.Task RunReport()
    {
        try
        {
            var payload = new
            {
                fromDate = ParseDate(txtFrom.Text),
                toDate = ParseDate(txtTo.Text),
                classId = ParseSelectedId(ddlClass),
                streamId = ParseSelectedId(ddlStream),
                source = string.IsNullOrWhiteSpace(txtSource.Text) ? null : txtSource.Text.Trim()
            };

            var res = await ApiHelper.PostAsync("api/Inquiries/getConversionReport", payload, HttpContext.Current);
            if (res == null)
            {
                BindEmpty("No response from server.");
                return;
            }

            if (res.response_code != "200")
            {
                BindEmpty(res.obj == null ? "Failed to load report." : res.obj.ToString());
                return;
            }

            var classMap = BuildIdNameMap(ddlClass);
            var streamMap = BuildIdNameMap(ddlStream);

            var json = JsonConvert.SerializeObject(res.obj);
            var rawList = JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(json) ?? new List<Dictionary<string, object>>();

            var dt = new DataTable();
            dt.Columns.Add("source");
            dt.Columns.Add("classId");
            dt.Columns.Add("className");
            dt.Columns.Add("streamId");
            dt.Columns.Add("streamName");
            dt.Columns.Add("totalInquiries");
            dt.Columns.Add("convertedInquiries");
            dt.Columns.Add("conversionRate");

            long total = 0;
            long converted = 0;

            foreach (var x in rawList)
            {
                object v;
                var r = dt.NewRow();

                r["source"] = x.TryGetValue("source", out v) ? v : null;

                object classIdObj = x.TryGetValue("classId", out v) ? v : (x.TryGetValue("class_id", out v) ? v : null);
                object streamIdObj = x.TryGetValue("streamId", out v) ? v : (x.TryGetValue("stream_id", out v) ? v : null);

                r["classId"] = classIdObj;
                r["streamId"] = streamIdObj;

                long id;
                r["className"] = long.TryParse(Convert.ToString(classIdObj), out id) && classMap.ContainsKey(id) ? classMap[id] : "All";
                r["streamName"] = long.TryParse(Convert.ToString(streamIdObj), out id) && streamMap.ContainsKey(id) ? streamMap[id] : "All";

                r["totalInquiries"] = x.TryGetValue("totalInquiries", out v) ? v : null;
                r["convertedInquiries"] = x.TryGetValue("convertedInquiries", out v) ? v : null;
                r["conversionRate"] = x.TryGetValue("conversionRate", out v) ? v : null;

                dt.Rows.Add(r);

                long tmp;
                if (long.TryParse(Convert.ToString(r["totalInquiries"]), out tmp)) total += tmp;
                if (long.TryParse(Convert.ToString(r["convertedInquiries"]), out tmp)) converted += tmp;
            }

            gvReport.DataSource = dt;
            gvReport.DataBind();

            ViewState[ReportTableViewStateKey] = dt;

            lblRows.Text = dt.Rows.Count.ToString();
            lblTotalInquiries.Text = total.ToString();
            lblConverted.Text = converted.ToString();

            decimal rate = 0;
            if (total > 0)
                rate = (decimal)converted / (decimal)total;

            lblConversionRate.Text = (rate * 100m).ToString("0.##") + "%";

            lblInfo.Text = dt.Rows.Count == 0
                ? "No rows found for the selected filters."
                : string.Empty;
        }
        catch (Exception ex)
        {
            BindEmpty("Error: " + ex.Message);
        }
    }

    private static string CsvEscape(object value)
    {
        var s = value == null ? string.Empty : Convert.ToString(value);
        if (s.IndexOf('"') >= 0) s = s.Replace("\"", "\"\"");
        if (s.IndexOf(',') >= 0 || s.IndexOf('\n') >= 0 || s.IndexOf('\r') >= 0 || s.IndexOf('"') >= 0)
            s = "\"" + s + "\"";
        return s;
    }

    protected void btnRun_Click(object sender, EventArgs e)
    {
        RegisterAsyncTask(new PageAsyncTask(RunReport));
    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        txtFrom.Text = string.Empty;
        txtTo.Text = string.Empty;
        txtSource.Text = string.Empty;
        ddlClass.SelectedIndex = 0;
        ddlStream.SelectedIndex = 0;
        BindEmpty("Run the report to see conversion metrics.");
    }

    protected void btnExport_Click(object sender, EventArgs e)
    {
        var dt = ViewState[ReportTableViewStateKey] as DataTable;
        if (dt == null || dt.Rows.Count == 0)
        {
            lblInfo.Text = "Nothing to export. Run the report first.";
            return;
        }

        var sb = new StringBuilder();
        sb.AppendLine("Source,Class,Stream,Total,Converted,Rate");

        foreach (DataRow r in dt.Rows)
        {
            sb.Append(CsvEscape(r["source"]))
              .Append(',').Append(CsvEscape(r["className"]))
              .Append(',').Append(CsvEscape(r["streamName"]))
              .Append(',').Append(CsvEscape(r["totalInquiries"]))
              .Append(',').Append(CsvEscape(r["convertedInquiries"]))
              .Append(',').Append(CsvEscape(r["conversionRate"]))
              .AppendLine();
        }

        var bytes = Encoding.UTF8.GetBytes(sb.ToString());

        Response.Clear();
        Response.Buffer = true;
        Response.ContentType = "text/csv";
        Response.AddHeader("Content-Disposition", "attachment; filename=inquiry-conversion-report.csv");
        Response.ContentEncoding = Encoding.UTF8;
        Response.BinaryWrite(bytes);
        Response.Flush();
        Response.End();
    }
}

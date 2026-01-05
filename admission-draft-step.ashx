<%@ WebHandler Language="C#" Class="AdmissionDraftStepHandler" %>

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.IO;
using System.Web;

public class AdmissionDraftStepHandler : IHttpHandler
{
    public bool IsReusable { get { return true; } }

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        try
        {
            var action = (context.Request["action"] ?? string.Empty).Trim().ToLowerInvariant();

            string body;
            using (var r = new StreamReader(context.Request.InputStream))
                body = r.ReadToEnd();

            object payload = null;
            try { payload = JsonConvert.DeserializeObject<object>(body); }
            catch { payload = new { }; }

            ApiResponse apiRes = null;

            if (action == "savestudent") apiRes = AdmissionDraftClient.SaveStudentStepAsync(payload).GetAwaiter().GetResult();
            else if (action == "saveparent") apiRes = AdmissionDraftClient.SaveParentStepAsync(payload).GetAwaiter().GetResult();
            else if (action == "saveacademic") apiRes = AdmissionDraftClient.SaveAcademicStepAsync(payload).GetAwaiter().GetResult();
            else if (action == "uploaddocument") apiRes = AdmissionDraftClient.UploadDocumentAsync(payload).GetAwaiter().GetResult();
            else
            {
                Write(context, new { ok = false, message = "Unknown action" });
                return;
            }

            if (apiRes == null || apiRes.response_code != "200")
            {
                Write(context, new
                {
                    ok = false,
                    message = TryReadMessage(apiRes),
                    response_code = apiRes != null ? apiRes.response_code : null
                });
                return;
            }

            Write(context, new { ok = true, obj = apiRes.obj });
        }
        catch (Exception ex)
        {
            context.Response.StatusCode = 200;
            Write(context, new { ok = false, message = "Server error: " + ex.Message });
        }
    }

    private static string TryReadMessage(ApiResponse apiRes)
    {
        if (apiRes == null)
            return "Request failed";

        if (apiRes.obj == null)
            return "Request failed";

        try
        {
            var s = apiRes.obj as string;
            if (!string.IsNullOrWhiteSpace(s))
                return s;

            var json = JsonConvert.SerializeObject(apiRes.obj);
            var jo = JsonConvert.DeserializeObject<JObject>(json);
            if (jo != null)
            {
                JToken msg;
                if (jo.TryGetValue("message", StringComparison.OrdinalIgnoreCase, out msg))
                {
                    var v = msg == null || msg.Type == JTokenType.Null ? null : msg.ToString();
                    if (!string.IsNullOrWhiteSpace(v))
                        return v;
                }
            }

            return apiRes.obj.ToString();
        }
        catch
        {
            return "Request failed";
        }
    }

    private static void Write(HttpContext ctx, object obj)
    {
        var json = JsonConvert.SerializeObject(obj);
        ctx.Response.Write(json);
    }
}

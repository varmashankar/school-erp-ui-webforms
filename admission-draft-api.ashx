<%@ WebHandler Language="C#" Class="AdmissionDraftApiHandler" %>

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.IO;
using System.Web;

public class AdmissionDraftApiHandler : IHttpHandler
{
    public bool IsReusable { get { return true; } }

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        try
        {
            var action = (context.Request["action"] ?? string.Empty).Trim().ToLowerInvariant();

            if (action == "create")
            {
                string body;
                using (var r = new StreamReader(context.Request.InputStream))
                    body = r.ReadToEnd();

                object payload = null;
                try { payload = JsonConvert.DeserializeObject<object>(body); }
                catch { payload = new { }; }

                var apiRes = AdmissionDraftClient.CreateDraftAsync(payload).GetAwaiter().GetResult();
                if (apiRes == null || apiRes.response_code != "200")
                {
                    Write(context, new { ok = false, message = apiRes != null && apiRes.obj != null ? apiRes.obj.ToString() : "Create draft failed" });
                    return;
                }

                var token = TryReadString(apiRes.obj, "resume_token");
                var admissionNo = TryReadString(apiRes.obj, "admission_no");

                // Do not rely on Session here (public flow + many deployments disable session for handlers)
                Write(context, new { ok = true, resume_token = token, admission_no = admissionNo });
                return;
            }

            if (action == "payload")
            {
                var token = context.Request["token"];
                if (string.IsNullOrWhiteSpace(token))
                {
                    Write(context, new { ok = false, message = "Token required" });
                    return;
                }

                var apiRes = AdmissionDraftClient.GetDraftPayloadAsync(token).GetAwaiter().GetResult();
                if (apiRes == null || apiRes.response_code != "200")
                {
                    Write(context, new { ok = false, message = apiRes != null && apiRes.obj != null ? apiRes.obj.ToString() : "Load failed" });
                    return;
                }

                Write(context, new { ok = true, payload = apiRes.obj });
                return;
            }

            if (action == "sendotp")
            {
                string body;
                using (var r = new StreamReader(context.Request.InputStream))
                    body = r.ReadToEnd();

                object payload = null;
                try { payload = JsonConvert.DeserializeObject<object>(body); }
                catch { payload = new { }; }

                var apiRes = AdmissionDraftClient.SendResumeOtpAsync(payload).GetAwaiter().GetResult();
                if (apiRes == null || apiRes.response_code != "200")
                {
                    Write(context, new { ok = false, message = apiRes != null && apiRes.obj != null ? apiRes.obj.ToString() : "OTP send failed" });
                    return;
                }

                Write(context, new { ok = true, obj = apiRes.obj });
                return;
            }

            if (action == "verifyotp")
            {
                string body;
                using (var r = new StreamReader(context.Request.InputStream))
                    body = r.ReadToEnd();

                object payload = null;
                try { payload = JsonConvert.DeserializeObject<object>(body); }
                catch { payload = new { }; }

                var apiRes = AdmissionDraftClient.VerifyResumeOtpAsync(payload).GetAwaiter().GetResult();
                if (apiRes == null || apiRes.response_code != "200")
                {
                    Write(context, new { ok = false, message = apiRes != null && apiRes.obj != null ? apiRes.obj.ToString() : "OTP verify failed" });
                    return;
                }

                var token = TryReadString(apiRes.obj, "resume_token");
                Write(context, new { ok = true, resume_token = token });
                return;
            }

            Write(context, new { ok = false, message = "Unknown action" });
        }
        catch (Exception ex)
        {
            context.Response.StatusCode = 200;
            Write(context, new
            {
                ok = false,
                message = "Server error: " + ex.Message,
                detail = ex.ToString()
            });
        }
    }

    private static string TryReadString(object apiObj, string key)
    {
        if (apiObj == null) return null;

        try
        {
            // If API already returned an object graph, serialize & parse safely
            var json = apiObj as string;
            if (string.IsNullOrWhiteSpace(json))
                json = JsonConvert.SerializeObject(apiObj);

            var jo = JsonConvert.DeserializeObject<JObject>(json);
            if (jo == null) return null;

            JToken tok;
            if (!jo.TryGetValue(key, StringComparison.OrdinalIgnoreCase, out tok))
                return null;

            return tok == null || tok.Type == JTokenType.Null ? null : tok.ToString();
        }
        catch
        {
            return null;
        }
    }

    private static void Write(HttpContext ctx, object obj)
    {
        var json = JsonConvert.SerializeObject(obj);
        ctx.Response.Write(json);
    }
}

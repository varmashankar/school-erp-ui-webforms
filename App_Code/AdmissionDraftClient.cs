using Newtonsoft.Json;
using System;
using System.Threading.Tasks;

public static class AdmissionDraftClient
{
    public static Task<ApiResponse> CreateDraftAsync(object payload)
    {
        return ApiHelper.PostAsync("api/AdmissionsDraft/createDraft", payload);
    }

    public static Task<ApiResponse> SaveStudentStepAsync(object payload)
    {
        return ApiHelper.PostAsync("api/AdmissionsDraft/saveStudentStep", payload);
    }

    public static Task<ApiResponse> SaveParentStepAsync(object payload)
    {
        return ApiHelper.PostAsync("api/AdmissionsDraft/saveParentStep", payload);
    }

    public static Task<ApiResponse> SaveAcademicStepAsync(object payload)
    {
        return ApiHelper.PostAsync("api/AdmissionsDraft/saveAcademicStep", payload);
    }

    public static Task<ApiResponse> UploadDocumentAsync(object payload)
    {
        return ApiHelper.PostAsync("api/AdmissionsDraft/uploadDocument", payload);
    }

    public static Task<ApiResponse> SendResumeOtpAsync(object payload)
    {
        return ApiHelper.PostAsync("api/AdmissionsDraft/sendResumeOtp", payload);
    }

    public static Task<ApiResponse> VerifyResumeOtpAsync(object payload)
    {
        return ApiHelper.PostAsync("api/AdmissionsDraft/verifyResumeOtp", payload);
    }

    public static Task<ApiResponse> GetDraftPayloadAsync(string token)
    {
        var url = "api/AdmissionsDraft/getDraftPayload?token=" + Uri.EscapeDataString(token ?? string.Empty);
        return ApiHelper.GetAsync(url);
    }

    public static T DeserializeObj<T>(object apiObj)
    {
        if (apiObj == null) return default(T);

        try
        {
            if (apiObj is T)
                return (T)apiObj;

            var s = apiObj as string;
            if (string.IsNullOrWhiteSpace(s))
                s = JsonConvert.SerializeObject(apiObj);
            return JsonConvert.DeserializeObject<T>(s);
        }
        catch
        {
            return default(T);
        }
    }
}

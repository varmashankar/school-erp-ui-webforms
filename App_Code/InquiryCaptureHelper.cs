using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Globalization;

public static class InquiryCaptureHelper
{
    public static DateTime? ParseDateTimeLocal(string value)
    {
        if (string.IsNullOrWhiteSpace(value)) return null;

        DateTime dt;
        if (DateTime.TryParseExact(value.Trim(), "yyyy-MM-dd'T'HH:mm", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
            return dt;

        if (DateTime.TryParse(value, out dt))
            return dt;

        return null;
    }

    public static long? ParseLong(string value)
    {
        if (string.IsNullOrWhiteSpace(value)) return null;
        long x;
        if (long.TryParse(value.Trim(), out x)) return x;
        return null;
    }

    public static string Require(string value)
    {
        return string.IsNullOrWhiteSpace(value) ? null : value.Trim();
    }

    public static string RequirePhone(string value)
    {
        value = Require(value);
        if (string.IsNullOrWhiteSpace(value)) return null;

        var digits = new System.Text.StringBuilder();
        foreach (var ch in value)
        {
            if (char.IsDigit(ch)) digits.Append(ch);
        }

        var d = digits.ToString();
        if (d.Length < 7) return null;
        return d;
    }

    public static void BindDropdownFromList(System.Web.UI.WebControls.DropDownList ddl, string allText)
    {
        if (ddl == null) return;
        ddl.Items.Clear();
        ddl.Items.Add(new System.Web.UI.WebControls.ListItem(allText, ""));
    }

    public static List<Dictionary<string, object>> DeserializeList(object obj)
    {
        var json = JsonConvert.SerializeObject(obj);
        return JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(json) ?? new List<Dictionary<string, object>>();
    }
}

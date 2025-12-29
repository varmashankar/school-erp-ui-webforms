using System;

public class StudentsFilterApi
{
    public int? id { get; set; }
    public int? classId { get; set; }
    public bool? deleted { get; set; }
    public bool? status { get; set; }
    public int? pageNo { get; set; }
}

public class GetStudentsApi
{
    public int? id { get; set; }
    public string studentCode { get; set; }
    public string firstName { get; set; }
    public string lastName { get; set; }
    public string phone { get; set; }
    public string className { get; set; }
}

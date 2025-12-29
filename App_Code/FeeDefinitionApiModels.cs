using System;

public class FeeHeadFilterApi
{
    public int? id { get; set; }
    public bool? status { get; set; }
    public bool? deleted { get; set; }
    public int? pageNo { get; set; }
}

public class FeeHeadApi
{
    public int id { get; set; }
    public string name { get; set; }
    public string code { get; set; }
    public string frequency { get; set; }
    public decimal default_amount { get; set; }
    public bool? status { get; set; }
    public bool? deleted { get; set; }
}

public class SaveFeeHeadRequestApi
{
    public int? id { get; set; }
    public string name { get; set; }
    public string code { get; set; }
    public string frequency { get; set; }
    public decimal? default_amount { get; set; }
    public bool? status { get; set; }
    public int? created_by_id { get; set; }
}

public class DeleteFeeHeadRequestApi
{
    public int? id { get; set; }
    public int? deleted_by_id { get; set; }
}

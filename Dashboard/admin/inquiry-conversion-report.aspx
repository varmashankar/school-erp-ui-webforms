<%@ Page Language="C#" Async="true" AutoEventWireup="true" CodeFile="inquiry-conversion-report.aspx.cs" Inherits="Dashboard_admin_inquiry_conversion_report" MasterPageFile="~/Master/admin.master" %>

<asp:Content ID="Content0" ContentPlaceHolderID="head" runat="Server">
    <style>
        .page-subtitle {
            font-size: .85rem;
            color: #6b7280;
        }

        .filter-card {
            background: #ffffff;
            border: 1px solid rgba(0,0,0,.06);
            border-radius: .75rem;
            padding: 1rem;
        }

        .filter-card .form-label {
            margin-bottom: .25rem;
            font-size: .8rem;
            color: #6c757d;
        }

        .filter-row {
            display: flex;
            gap: .75rem;
            align-items: flex-end;
            width: 100%;
            flex-wrap: wrap;
        }

        .filter-item {
            flex: 1 1 160px;
            min-width: 160px;
        }

        .filter-item.source {
            flex: 2 1 240px;
            min-width: 220px;
        }

        .action-row {
            display: flex;
            gap: .5rem;
            align-items: center;
            justify-content: flex-end;
            flex-wrap: wrap;
            margin-top: .75rem;
        }

        .help-row {
            display: flex;
            justify-content: flex-end;
            margin-top: .4rem;
        }

        .muted-help {
            color: #6b7280;
            font-size: .85rem;
        }

        input[type="date"].form-control {
            min-height: 40px;
        }

        #gvReport {
            font-size: .86rem;
        }

        #gvReport thead th {
            white-space: nowrap;
            font-size: .8rem;
            background: #f9fafb;
        }

        #gvReport td {
            vertical-align: middle;
            padding: .45rem .55rem;
            word-break: break-word;
        }

        .table-wrap {
            border: 1px solid rgba(0,0,0,.06);
            border-radius: .75rem;
            overflow: hidden;
            background: #ffffff;
        }

        @media (max-width: 991px) {
            .action-row {
                justify-content: flex-start;
            }
            .help-row {
                justify-content: flex-start;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="pageTitle" runat="server">
    <div class="d-flex flex-column">
        <div class="d-flex align-items-center justify-content-between">
            <h5 class="m-0">Inquiry Conversion Report</h5>
            <a class="btn bg-white btn-sm" href="inquiries.aspx">
                <i class="bi bi-arrow-left me-1"></i>Back
            </a>
        </div>
        <div class="page-subtitle">Track lead to admission conversion</div>
    </div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <div class="row g-3">
            <div class="col-12">
                <div class="card shadow-sm border-0">
                    <div class="card-body">
                        <div class="filter-card">

                            <div class="filter-row">
                                <div class="filter-item">
                                    <label class="form-label" for="txtFrom">From</label>
                                    <asp:TextBox ID="txtFrom" runat="server" CssClass="form-control" TextMode="Date" />
                                </div>
                                <div class="filter-item">
                                    <label class="form-label" for="txtTo">To</label>
                                    <asp:TextBox ID="txtTo" runat="server" CssClass="form-control" TextMode="Date" />
                                </div>
                                <div class="filter-item source">
                                    <label class="form-label" for="txtSource">Source</label>
                                    <asp:TextBox ID="txtSource" runat="server" CssClass="form-control" placeholder="WALKIN / WEBSITE" />
                                </div>
                                <div class="filter-item">
                                    <label class="form-label" for="ddlClass">Class</label>
                                    <asp:DropDownList ID="ddlClass" runat="server" CssClass="form-select" />
                                </div>
                                <div class="filter-item">
                                    <label class="form-label" for="ddlStream">Stream</label>
                                    <asp:DropDownList ID="ddlStream" runat="server" CssClass="form-select" />
                                </div>
                            </div>

                            <div class="action-row">
                                <asp:LinkButton ID="btnRun" runat="server" CssClass="btn btn-primary btn-sm" OnClick="btnRun_Click">
                                    <i class="bi bi-graph-up-arrow me-1"></i>Run Report
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnClear" runat="server" CssClass="btn btn-outline-secondary btn-sm" OnClick="btnClear_Click">
                                    <i class="bi bi-x-circle me-1"></i>Clear
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnExport" runat="server" CssClass="btn btn-outline-success btn-sm" OnClick="btnExport_Click">
                                    <i class="bi bi-download me-1"></i>Export CSV
                                </asp:LinkButton>
                            </div>

                            <div class="help-row">
                                <div class="muted-help">Tip: Leave filters empty to view overall summary.</div>
                            </div>
                        </div>

                        <div class="row g-2 mt-3">
                            <div class="col-12 col-md-3">
                                <div class="kpi">
                                    <div class="value"><asp:Label ID="lblTotalInquiries" runat="server" Text="0" /></div>
                                    <div class="label">Total Inquiries</div>
                                    <div class="hint">Leads captured</div>
                                </div>
                            </div>
                            <div class="col-12 col-md-3">
                                <div class="kpi">
                                    <div class="value"><asp:Label ID="lblConverted" runat="server" Text="0" /></div>
                                    <div class="label">Converted</div>
                                    <div class="hint">Admissions created</div>
                                </div>
                            </div>
                            <div class="col-12 col-md-3">
                                <div class="kpi">
                                    <div class="value"><asp:Label ID="lblConversionRate" runat="server" Text="0%" /></div>
                                    <div class="label">Conversion</div>
                                    <div class="hint">Converted / Total</div>
                                </div>
                            </div>
                            <div class="col-12 col-md-3">
                                <div class="kpi">
                                    <div class="value"><asp:Label ID="lblRows" runat="server" Text="0" /></div>
                                    <div class="label">Rows</div>
                                    <div class="hint">Groups returned</div>
                                </div>
                            </div>
                        </div>

                        <div class="mt-3 table-wrap">
                            <div class="table-responsive">
                                <asp:GridView ID="gvReport" runat="server"
                                    ClientIDMode="Static"
                                    AutoGenerateColumns="False"
                                    CssClass="table table-hover align-middle mb-0"
                                    ShowHeaderWhenEmpty="True">
                                    <Columns>
                                        <asp:BoundField DataField="source" HeaderText="Source" />
                                        <asp:BoundField DataField="className" HeaderText="Class" />
                                        <asp:BoundField DataField="streamName" HeaderText="Stream" />
                                        <asp:BoundField DataField="totalInquiries" HeaderText="Total" />
                                        <asp:BoundField DataField="convertedInquiries" HeaderText="Converted" />
                                        <asp:BoundField DataField="conversionRate" HeaderText="Rate" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>

                        <asp:Label ID="lblInfo" runat="server" CssClass="text-muted small d-block mt-2" />

                    </div>
                </div>
            </div>
        </div>

    </div>
</asp:Content>

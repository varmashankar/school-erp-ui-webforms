<%@ Page Language="C#" Async="true" AutoEventWireup="true" CodeFile="inquiries.aspx.cs" Inherits="Dashboard_admin_inquiries" MasterPageFile="~/Master/admin.master" %>

<asp:Content ID="Content0" ContentPlaceHolderID="head" runat="Server">
    <style>
        .page-toolbar {
            gap: .5rem;
        }

        .filter-card {
            background: #f8f9fa;
            border: 1px solid rgba(0,0,0,.06);
            border-radius: .5rem;
            padding: .75rem;
        }

        .filter-card .form-label {
            margin-bottom: .25rem;
            font-size: .8rem;
            color: #6c757d;
        }

        /* Compact table to fit viewport */
        #gvInquiries {
            font-size: .83rem;
        }

        #gvInquiries thead th {
            white-space: nowrap;
            font-size: .8rem;
        }

        #gvInquiries td {
            vertical-align: middle;
            padding: .35rem .5rem;
        }

        /* Allow wrapping of long values (email, inquiry no) to avoid horizontal scroll */
        #gvInquiries td,
        #gvInquiries th {
            word-break: break-word;
        }

        /* Keep the Actions column compact */
        #gvInquiries td:last-child,
        #gvInquiries th:last-child {
            width: 180px;
        }

        #gvInquiries .filters th {
            padding: .25rem .35rem;
            background: #fff;
        }

        #gvInquiries .filters .form-control {
            min-width: 90px;
            font-size: .75rem;
            padding: .2rem .35rem;
        }

        .inq-actions {
            display: flex;
            align-items: center;
            gap: .35rem;
            flex-wrap: wrap;
        }

        .inq-actions .form-select {
            width: 120px !important;
            font-size: .78rem;
            padding-top: .2rem;
            padding-bottom: .2rem;
        }

        .btn-icon {
            padding: .2rem .4rem;
            line-height: 1.1;
        }

        .btn-icon i {
            font-size: .95rem;
        }

        /* Let DataTables layout wrap instead of forcing a wide line */
        div.dataTables_wrapper div.dataTables_length,
        div.dataTables_wrapper div.dataTables_filter {
            font-size: .85rem;
        }

        div.dataTables_wrapper .dataTables_filter input {
            font-size: .85rem;
            padding: .2rem .4rem;
        }
    </style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="pageTitle" runat="server">
    <div class="d-flex align-items-center justify-content-between">
        <h5 class="m-0">Inquiries</h5>
        <span class="text-muted small">Manage leads and follow-ups</span>
    </div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <div class="row g-3">
            <div class="col-12">
                <div class="card shadow-sm border-0">
                    <div class="card-body">
                        <div class="d-flex align-items-center justify-content-between mb-3 page-toolbar">
                            <div>
                                <h6 class="m-0 fw-semibold">Inquiry List</h6>
                                <div class="text-muted small">Search and update inquiry status</div>
                            </div>
                            <asp:LinkButton ID="btnRefresh" runat="server" CssClass="btn btn-outline-primary btn-sm" OnClick="btnRefresh_Click">
                                <i class="bi bi-arrow-clockwise me-1"></i>Refresh
                            </asp:LinkButton>
                        </div>

                        <div class="filter-card mb-3">
                            <div class="row g-2">
                                <div class="col-md-3">
                                    <label class="form-label" for="txtSearchInquiryNo">Inquiry No</label>
                                    <asp:TextBox ID="txtSearchInquiryNo" runat="server" CssClass="form-control" placeholder="INQ-2025-0001" />
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label" for="ddlStatus">Status</label>
                                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select" />
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label" for="txtFromDate">From</label>
                                    <asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control" TextMode="Date" />
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label" for="txtToDate">To</label>
                                    <asp:TextBox ID="txtToDate" runat="server" CssClass="form-control" TextMode="Date" />
                                </div>
                                <div class="col-12 d-flex gap-2">
                                    <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary btn-sm" Text="Search" OnClick="btnSearch_Click" />
                                    <asp:Button ID="btnClear" runat="server" CssClass="btn btn-light btn-sm" Text="Clear" OnClick="btnClear_Click" />
                                </div>
                            </div>
                        </div>

                        <div class="dt-table-wrap">
                            <asp:GridView ID="gvInquiries" runat="server"
                                ClientIDMode="Static"
                                AutoGenerateColumns="False"
                                CssClass="table table-hover align-middle table-bordered js-datatable"
                                OnRowCommand="gvInquiries_RowCommand"
                                OnRowCreated="gvInquiries_RowCreated"
                                ShowHeaderWhenEmpty="True">
                                <Columns>
                                    <asp:BoundField DataField="id" HeaderText="#" />
                                    <asp:BoundField DataField="inquiryNo" HeaderText="Inquiry No" />
                                    <asp:BoundField DataField="firstName" HeaderText="First Name" />
                                    <asp:BoundField DataField="lastName" HeaderText="Last Name" />
                                    <asp:BoundField DataField="phone" HeaderText="Phone" />
                                    <asp:BoundField DataField="email" HeaderText="Email" />
                                    <asp:BoundField DataField="status" HeaderText="Status" />
                                    <asp:BoundField DataField="nextFollowUpAt" HeaderText="Next Follow Up" />
                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <asp:HiddenField ID="hfInquiryId" runat="server" Value='<%# Eval("id") %>' />
                                            <div class="inq-actions">
                                                <asp:DropDownList ID="ddlRowStatus" runat="server" CssClass="form-select form-select-sm" />

                                                <asp:LinkButton ID="btnUpdateStatus" runat="server"
                                                    CssClass="btn btn-sm btn-outline-success btn-icon"
                                                    CommandName="ChangeStatus"
                                                    CommandArgument='<%# Eval("id") %>'
                                                    ToolTip="Update status">
                                                    <i class="bi bi-check2-circle"></i>
                                                </asp:LinkButton>

                                                <a class="btn btn-sm btn-outline-secondary btn-icon"
                                                    title="Follow-ups"
                                                    href='<%# "inquiry-followups.aspx?inquiryId=" + Eval("id") %>'>
                                                    <i class="bi bi-clock-history"></i>
                                                </a>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>

                        <asp:Label ID="lblInfo" runat="server" CssClass="text-muted small" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

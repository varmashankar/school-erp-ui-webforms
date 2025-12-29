<%@ Page Language="C#" Async="true" AutoEventWireup="true" CodeFile="inquiry-followups.aspx.cs" Inherits="Dashboard_admin_inquiry_followups" MasterPageFile="~/Master/admin.master" %>

<asp:Content ID="Content0" ContentPlaceHolderID="head" runat="Server">
    <style>
        .page-toolbar { gap: .5rem; }

        .panel-title {
            display: flex;
            align-items: center;
            gap: .5rem;
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

        .badge-soft {
            background: #eef2ff;
            color: #3730a3;
            border: 1px solid rgba(99,102,241,.25);
            padding: .35rem .6rem;
            border-radius: 999px;
            font-size: .8rem;
            display: inline-flex;
            align-items: center;
            gap: .35rem;
        }

        .preset-row {
            display: flex;
            gap: .4rem;
            flex-wrap: wrap;
            margin-top: .35rem;
        }

        #gvDue { font-size: .85rem; }
        #gvDue thead th { white-space: nowrap; font-size: .8rem; background: #f9fafb; }
        #gvDue td { vertical-align: middle; padding: .45rem .55rem; word-break: break-word; }

        .form-control, .form-select { font-size: .9rem; }
    </style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="pageTitle" runat="server">
    <div class="d-flex align-items-center justify-content-between">
        <div class="d-flex flex-column">
            <h5 class="m-0">Inquiry Follow-ups</h5>
            <span class="text-muted small">Schedule and track follow-up reminders</span>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <asp:HiddenField ID="hfInquiryId" runat="server" />

        <div class="mb-3">
            <asp:Label ID="lblSelectedInquiry" runat="server" CssClass="badge-soft" />
        </div>

        <div class="row g-3">
            <div class="col-12 col-lg-5">
                <div class="card shadow-sm border-0">
                    <div class="card-body">
                        <div class="panel-title mb-3">
                            <i class="bi bi-plus-circle"></i>
                            <h6 class="m-0 fw-semibold">Add Follow-up</h6>
                        </div>

                        <div class="filter-card">
                            <div class="mb-2">
                                <label class="form-label" for="ddlInquiry">Inquiry</label>
                                <asp:DropDownList ID="ddlInquiry" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlInquiry_SelectedIndexChanged" />
                                <div class="text-muted small mt-1">Select an inquiry to add a follow-up (also filters the due list).</div>
                            </div>

                            <div class="mb-2">
                                <label class="form-label" for="txtFollowUpAt">Follow Up At</label>
                                <asp:TextBox ID="txtFollowUpAt" runat="server" CssClass="form-control" TextMode="DateTimeLocal" />
                                <div class="preset-row">
                                    <asp:LinkButton ID="btnPreset30" runat="server" CssClass="btn btn-outline-secondary btn-sm" OnClick="btnPreset30_Click" CausesValidation="false">+30m</asp:LinkButton>
                                    <asp:LinkButton ID="btnPreset2h" runat="server" CssClass="btn btn-outline-secondary btn-sm" OnClick="btnPreset2h_Click" CausesValidation="false">+2h</asp:LinkButton>
                                    <asp:LinkButton ID="btnPresetTomorrow" runat="server" CssClass="btn btn-outline-secondary btn-sm" OnClick="btnPresetTomorrow_Click" CausesValidation="false">Tomorrow 10:00</asp:LinkButton>
                                </div>
                            </div>

                            <div class="mb-2">
                                <label class="form-label" for="ddlChannel">Channel</label>
                                <asp:DropDownList ID="ddlChannel" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="CALL" Value="CALL" />
                                    <asp:ListItem Text="WHATSAPP" Value="WHATSAPP" />
                                    <asp:ListItem Text="EMAIL" Value="EMAIL" />
                                    <asp:ListItem Text="VISIT" Value="VISIT" />
                                </asp:DropDownList>
                            </div>

                            <div class="mb-3">
                                <label class="form-label" for="txtRemarks">Remarks</label>
                                <asp:TextBox ID="txtRemarks" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                            </div>

                            <div class="d-flex gap-2 flex-wrap">
                                <asp:LinkButton ID="btnSaveFollowUp" runat="server" CssClass="btn btn-primary btn-sm" OnClick="btnSaveFollowUp_Click">
                                    <i class="bi bi-save2 me-1"></i>Save
                                </asp:LinkButton>
                                <a class="btn bg-white btn-sm" href="inquiries.aspx">
                                    <i class="bi bi-arrow-left me-1"></i>Back
                                </a>
                            </div>

                            <asp:Label ID="lblInfo" runat="server" CssClass="text-muted small d-block mt-2" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-12 col-lg-7">
                <div class="card shadow-sm border-0">
                    <div class="card-body">
                        <div class="d-flex align-items-center justify-content-between mb-3 page-toolbar">
                            <div class="panel-title">
                                <i class="bi bi-clock-history"></i>
                                <h6 class="m-0 fw-semibold">Due Follow-ups</h6>
                            </div>
                            <asp:LinkButton ID="btnRefresh" runat="server" CssClass="btn btn-outline-primary btn-sm" OnClick="btnRefresh_Click">
                                <i class="bi bi-arrow-clockwise me-1"></i>Refresh
                            </asp:LinkButton>
                        </div>

                        <asp:GridView ID="gvDue" runat="server"
                            ClientIDMode="Static"
                            AutoGenerateColumns="False"
                            CssClass="table table-hover align-middle table-bordered"
                            OnRowCommand="gvDue_RowCommand"
                            ShowHeaderWhenEmpty="True">
                            <Columns>
                                <asp:BoundField DataField="id" HeaderText="#" />
                                <asp:BoundField DataField="inquiryId" HeaderText="Inquiry" />
                                <asp:BoundField DataField="followUpAt" HeaderText="Follow Up At" />
                                <asp:BoundField DataField="channel" HeaderText="Channel" />
                                <asp:BoundField DataField="remarks" HeaderText="Remarks" />
                                <asp:BoundField DataField="isReminded" HeaderText="Reminded" />
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnMark" runat="server"
                                            CssClass="btn btn-sm btn-outline-success"
                                            CommandName="MarkReminded"
                                            CommandArgument='<%# Eval("id") %>'
                                            ToolTip="Mark as reminded">
                                            <i class="bi bi-bell-check"></i>
                                            <span class="ms-1">Mark</span>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>

                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

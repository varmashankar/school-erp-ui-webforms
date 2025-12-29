<%@ Page Title="" Language="C#" Async="true" MasterPageFile="~/Master/admin.master" AutoEventWireup="true" CodeFile="fee-reminders.aspx.cs" Inherits="Dashboard_admin_fee_reminders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .mono { font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="pageTitle" Runat="Server">
    <div class="d-flex align-items-center">
        <a href="fees.aspx" class="btn btn-light btn-sm me-3"><i class="bi bi-arrow-left"></i></a>
        <h1 class="h4 mb-0 text-dark">Fee WhatsApp Reminders</h1>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-header bg-white p-3 d-flex justify-content-between align-items-center">
            <h5 class="mb-0 fw-bold">Queue & Send</h5>
            <div>
                <asp:Button ID="btnQueue" runat="server" Text="Queue Overdue" CssClass="btn btn-primary btn-sm me-2" OnClick="btnQueue_Click" />
                <asp:Button ID="btnSendBatch" runat="server" Text="Send Batch Now" CssClass="btn btn-success btn-sm me-2" OnClick="btnSendBatch_Click" />
                <asp:Button ID="btnRefresh" runat="server" Text="Refresh" CssClass="btn btn-outline-secondary btn-sm" OnClick="btnRefresh_Click" />
            </div>
        </div>
        <div class="card-body">
            <div class="row g-3 mb-3">
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Due before</label>
                    <asp:TextBox ID="txtDueBefore" runat="server" CssClass="form-control" TextMode="Date" />
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Max recipients</label>
                    <asp:TextBox ID="txtMaxRecipients" runat="server" CssClass="form-control" TextMode="Number" />
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Fetch batch size</label>
                    <asp:TextBox ID="txtMaxBatch" runat="server" CssClass="form-control" TextMode="Number" />
                </div>
                <div class="col-md-3 d-flex align-items-end">
                    <div class="form-check">
                        <asp:CheckBox ID="chkOnlyOverdue" runat="server" CssClass="form-check-input" Checked="true" />
                        <label class="form-check-label">Only overdue</label>
                    </div>
                </div>
            </div>

            <asp:Label ID="lblResult" runat="server" CssClass="text-muted" />

            <div class="table-responsive mt-3">
                <asp:GridView ID="gvQueue" runat="server" AutoGenerateColumns="False" CssClass="table table-hover align-middle" DataKeyNames="id"
                    OnRowCommand="gvQueue_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="id" HeaderText="#" />
                        <asp:BoundField DataField="student_id" HeaderText="Student" />
                        <asp:BoundField DataField="installment_id" HeaderText="Installment" />
                        <asp:BoundField DataField="due_date" HeaderText="Due" DataFormatString="{0:d}" />
                        <asp:BoundField DataField="outstanding_amount" HeaderText="Outstanding" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="phone" HeaderText="Phone" />
                        <asp:TemplateField HeaderText="Message">
                            <ItemTemplate>
                                <div class="mono" style="max-width:520px; white-space:normal;"><%# Eval("message") %></div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="try_count" HeaderText="Tries" />
                        <asp:BoundField DataField="last_try_at" HeaderText="Last Try" DataFormatString="{0:g}" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnMarkSent" runat="server" CssClass="btn btn-sm btn-success me-2" CommandName="MarkSent" CommandArgument='<%# Eval("id") %>'>
                                    Sent
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnMarkFailed" runat="server" CssClass="btn btn-sm btn-outline-danger" CommandName="MarkFailed" CommandArgument='<%# Eval("id") %>'>
                                    Failed
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="alert alert-info mb-0">No queued reminders.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>

<%@ Page Title="" Language="C#" Async="true" MasterPageFile="~/Master/admin.master" AutoEventWireup="true" CodeFile="accountability-dashboard.aspx.cs" Inherits="Dashboard_admin_accountability_dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="pageTitle" Runat="Server">
    <div class="d-flex align-items-center">
        <h1 class="h4 mb-0 text-dark">Accountability Dashboard</h1>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:UpdatePanel ID="upMain" runat="server">
        <ContentTemplate>
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white p-3">
                    <div class="d-flex flex-wrap align-items-end gap-3">
                        <div>
                            <label class="form-label fw-semibold">From</label>
                            <asp:TextBox ID="txtFrom" runat="server" CssClass="form-control" TextMode="Date" />
                        </div>
                        <div>
                            <label class="form-label fw-semibold">To</label>
                            <asp:TextBox ID="txtTo" runat="server" CssClass="form-control" TextMode="Date" />
                        </div>
                        <div>
                            <label class="form-label fw-semibold">Max Days Overdue</label>
                            <asp:TextBox ID="txtMaxDaysOverdue" runat="server" CssClass="form-control" TextMode="Number" placeholder="e.g. 30" />
                        </div>
                        <div>
                            <label class="form-label fw-semibold">Academic Year</label>
                            <asp:DropDownList ID="ddlAcademicYear" runat="server" CssClass="form-select" />
                        </div>
                        <div class="ms-auto">
                            <asp:Button ID="btnRefresh" runat="server" Text="Refresh" CssClass="btn btn-primary" OnClick="btnRefresh_Click" />
                        </div>
                    </div>
                </div>

                <div class="card-body p-4">
                    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger">
                        <asp:Literal ID="litError" runat="server" />
                    </asp:Panel>

                    <div class="row g-4">
                        <div class="col-12">
                            <h5 class="fw-bold mb-3">Staff-wise Follow-ups</h5>
                            <div class="table-responsive">
                                <asp:GridView ID="gvStaff" runat="server" CssClass="table table-striped table-hover" AutoGenerateColumns="false">
                                    <Columns>
                                        <asp:BoundField DataField="staffId" HeaderText="#" />
                                        <asp:BoundField DataField="staffName" HeaderText="Staff" />
                                        <asp:BoundField DataField="dueFollowUps" HeaderText="Total" />
                                        <asp:BoundField DataField="overdueFollowUps" HeaderText="Overdue" />
                                        <asp:BoundField DataField="lastFollowUpAt" HeaderText="Last Follow-up" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>

                        <div class="col-12">
                            <h5 class="fw-bold mb-3">Missed Inquiries</h5>
                            <div class="table-responsive">
                                <asp:GridView ID="gvMissed" runat="server" CssClass="table table-striped table-hover" AutoGenerateColumns="false">
                                    <Columns>
                                        <asp:BoundField DataField="inquiryId" HeaderText="#" />
                                        <asp:BoundField DataField="studentName" HeaderText="Student" />
                                        <asp:BoundField DataField="phone" HeaderText="Phone" />
                                        <asp:BoundField DataField="status" HeaderText="Status" />
                                        <asp:BoundField DataField="nextFollowUpAt" HeaderText="Next Follow-up" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                                        <asp:BoundField DataField="daysOverdue" HeaderText="Days Overdue" />
                                        <asp:BoundField DataField="assignedToStaffName" HeaderText="Assigned" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <h5 class="fw-bold mb-3">Admission Loss Reasons</h5>
                            <div class="table-responsive">
                                <asp:GridView ID="gvLossReasons" runat="server" CssClass="table table-striped table-hover" AutoGenerateColumns="false">
                                    <Columns>
                                        <asp:BoundField DataField="reason" HeaderText="Reason" />
                                        <asp:BoundField DataField="count" HeaderText="Count" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <h5 class="fw-bold mb-3">Fee Collection Delays</h5>
                            <div class="table-responsive">
                                <asp:GridView ID="gvFeeDelays" runat="server" CssClass="table table-striped table-hover" AutoGenerateColumns="false">
                                    <Columns>
                                        <asp:BoundField DataField="studentId" HeaderText="#" />
                                        <asp:BoundField DataField="studentName" HeaderText="Student" />
                                        <asp:BoundField DataField="className" HeaderText="Class" />
                                        <asp:BoundField DataField="totalDue" HeaderText="Total Due" DataFormatString="{0:N2}" />
                                        <asp:BoundField DataField="dueDate" HeaderText="Due Date" DataFormatString="{0:yyyy-MM-dd}" />
                                        <asp:BoundField DataField="daysOverdue" HeaderText="Days Overdue" />
                                        <asp:BoundField DataField="lastReminderStatus" HeaderText="Reminder Status" />
                                        <asp:BoundField DataField="lastReminderAt" HeaderText="Last Reminder" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

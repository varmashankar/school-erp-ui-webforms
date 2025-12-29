<%@ Page Title="" Language="C#" Async="true" MasterPageFile="~/Master/admin.master" AutoEventWireup="true" CodeFile="fees.aspx.cs" Inherits="Dashboard_admin_fees" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        /* main page only: avoid styling top menu/title area */

        .stat-card {
            border: 1px solid #e9ecef;
            transition: box-shadow 0.2s ease, transform 0.2s ease;
            border-radius: 1rem;
        }

        .stat-card:hover {
            box-shadow: 0 0.75rem 1.5rem rgba(0,0,0,.08);
            transform: translateY(-3px);
        }

        .icon-bg {
            width: 56px;
            height: 56px;
            border-radius: 0.85rem;
            display: flex;
            align-items: center;
            justify-content: center;
            flex: 0 0 auto;
        }

        .quick-actions {
            display: flex;
            flex-wrap: wrap;
            gap: .5rem;
            justify-content: flex-end;
        }

        .card-header-title {
            display: flex;
            align-items: center;
            gap: .75rem;
        }

        .card-header-title h5 {
            margin: 0;
        }

        .filters-card {
            background: #fff;
            border: 1px solid rgba(0,0,0,.06);
            border-radius: 1rem;
        }

        .filters-card .form-label {
            margin-bottom: .35rem;
        }

        .table-wrap {
            border: 1px solid rgba(0,0,0,.06);
            border-radius: 1rem;
            overflow: hidden;
        }

        .table-wrap .table {
            margin-bottom: 0;
        }

        .table-sticky thead th {
            position: sticky;
            top: 0;
            z-index: 2;
            background: #fff;
            box-shadow: 0 1px 0 rgba(0,0,0,.06);
            white-space: nowrap;
        }

        .table .text-truncate {
            max-width: 240px;
        }

        /* Fee Status Badges */
        .badge-status { font-weight: 600; letter-spacing: .2px; }
        .badge-paid { background-color: #d1e7dd; color: #0f5132; }
        .badge-pending { background-color: #fff3cd; color: #664d03; }
        .badge-overdue { background-color: #f8d7da; color: #842029; }
        .badge-partial { background-color: #cfe2ff; color: #0a58ca; }

        /* Better focus rings */
        .form-control:focus, .form-select:focus {
            box-shadow: 0 0 0 .2rem rgba(13,110,253,.15);
            border-color: rgba(13,110,253,.55);
        }

        @media (max-width: 576px) {
            .quick-actions { justify-content: flex-start; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="pageTitle" Runat="Server">
    <h3 class="text-xl font-bold text-gray-800">Fees Management</h3>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <!-- Fees Stats Overview -->
    <div class="row g-4 mb-4">

        <!-- Expected -->
        <div class="col-md-6 col-xl-3">
            <div class="card stat-card h-100">
                <div class="card-body d-flex align-items-center">
                    <div class="icon-bg bg-primary bg-opacity-10 me-3">
                        <i class="bi bi-calculator text-primary fs-3"></i>
                    </div>
                    <div class="flex-grow-1">
                        <small class="text-uppercase text-muted fw-semibold">Expected</small>
                        <div class="fs-2 fw-bold text-dark lh-1">
                            <asp:Literal ID="litTotalExpectedFees" runat="server" Text="—" />
                        </div>
                        <small class="text-muted">Total billed amount</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Collected -->
        <div class="col-md-6 col-xl-3">
            <div class="card stat-card h-100">
                <div class="card-body d-flex align-items-center">
                    <div class="icon-bg bg-success bg-opacity-10 me-3">
                        <i class="bi bi-wallet2 text-success fs-3"></i>
                    </div>
                    <div class="flex-grow-1">
                        <small class="text-uppercase text-muted fw-semibold">Collected</small>
                        <div class="fs-2 fw-bold text-dark lh-1">
                            <asp:Literal ID="litTotalCollectedFees" runat="server" Text="—" />
                        </div>
                        <small class="text-muted">Received so far</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Outstanding -->
        <div class="col-md-6 col-xl-3">
            <div class="card stat-card h-100">
                <div class="card-body d-flex align-items-center">
                    <div class="icon-bg bg-warning bg-opacity-10 me-3">
                        <i class="bi bi-hourglass-split text-warning fs-3"></i>
                    </div>
                    <div class="flex-grow-1">
                        <small class="text-uppercase text-muted fw-semibold">Outstanding</small>
                        <div class="fs-2 fw-bold text-dark lh-1">
                            <asp:Literal ID="litOutstandingFees" runat="server" Text="—" />
                        </div>
                        <small class="text-muted">Yet to be paid</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Overdue -->
        <div class="col-md-6 col-xl-3">
            <div class="card stat-card h-100">
                <div class="card-body d-flex align-items-center">
                    <div class="icon-bg bg-danger bg-opacity-10 me-3">
                        <i class="bi bi-exclamation-circle text-danger fs-3"></i>
                    </div>
                    <div class="flex-grow-1">
                        <small class="text-uppercase text-muted fw-semibold">Overdue</small>
                        <div class="fs-2 fw-bold text-dark lh-1">
                            <asp:Literal ID="litOverdueAccounts" runat="server" Text="—" />
                        </div>
                        <small class="text-muted">Accounts past due</small>
                    </div>
                </div>
            </div>
        </div>

    </div>


    <!-- Fee Management Table -->
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-header bg-white p-3">
            <div class="d-flex justify-content-between align-items-start gap-3 flex-wrap">
                <div class="card-header-title">
                    <div class="icon-bg bg-primary bg-opacity-10" style="width:44px;height:44px;">
                        <i class="bi bi-receipt text-primary"></i>
                    </div>
                    <div>
                        <h5 class="fw-bold">Student Fees Overview</h5>
                        <div class="text-muted small">Filter and search students to manage collections faster.</div>
                    </div>
                </div>
                <div class="quick-actions">
                    <asp:HyperLink ID="lnkDefineFees" runat="server" CssClass="btn btn-outline-secondary btn-sm" NavigateUrl="~/dashboard/admin/feedefinition.aspx">
                        <i class="bi bi-cash me-2"></i>Define Fees
                    </asp:HyperLink>
                    <asp:HyperLink ID="lnkCollectFee" runat="server" CssClass="btn btn-primary btn-sm" NavigateUrl="~/dashboard/admin/collectfee.aspx">
                        <i class="bi bi-plus-lg me-2"></i>Collect Fee
                    </asp:HyperLink>
                    <asp:HyperLink ID="lnkFeeReminders" runat="server" CssClass="btn btn-outline-primary btn-sm" NavigateUrl="~/dashboard/admin/fee-reminders.aspx">
                        <i class="bi bi-whatsapp me-2"></i>Reminders
                    </asp:HyperLink>
                </div>
            </div>
        </div>

        <div class="card-body">

            <div class="filters-card p-3 mb-3">
                <div class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <asp:Label ID="lblFilterClass" runat="server" Text="Class" CssClass="form-label fw-semibold"></asp:Label>
                        <asp:DropDownList ID="ddlFilterClass" runat="server" CssClass="form-select" AutoPostBack="True" OnSelectedIndexChanged="ddlFilterClass_SelectedIndexChanged">
                            <asp:ListItem Text="All Classes" Value="" />
                            <asp:ListItem Text="Grade 1 - A" Value="G1A" />
                            <asp:ListItem Text="Grade 1 - B" Value="G1B" />
                            <asp:ListItem Text="Grade 5 - A" Value="G5A" />
                            <asp:ListItem Text="Grade 8 - A" Value="G8A" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-3">
                        <asp:Label ID="lblFilterStatus" runat="server" Text="Status" CssClass="form-label fw-semibold"></asp:Label>
                        <asp:DropDownList ID="ddlFilterStatus" runat="server" CssClass="form-select" AutoPostBack="True" OnSelectedIndexChanged="ddlFilterStatus_SelectedIndexChanged">
                            <asp:ListItem Text="All Statuses" Value="" />
                            <asp:ListItem Text="Paid" Value="Paid" />
                            <asp:ListItem Text="Pending" Value="Pending" />
                            <asp:ListItem Text="Overdue" Value="Overdue" />
                            <asp:ListItem Text="Partial" Value="Partial" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-4">
                        <asp:Label ID="lblSearch" runat="server" Text="Search" CssClass="form-label fw-semibold" AssociatedControlID="txtSearchStudent"></asp:Label>
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                            <asp:TextBox ID="txtSearchStudent" runat="server" CssClass="form-control" placeholder="Type student name or ID" AutoPostBack="True" OnTextChanged="txtSearchStudent_TextChanged"></asp:TextBox>
                            <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="Search" CausesValidation="false" OnClick="btnSearch_Click" />
                        </div>
                    </div>

                    <div class="col-md-2 d-grid">
                        <asp:HyperLink ID="lnkResetFilters" runat="server" CssClass="btn btn-outline-secondary" NavigateUrl="~/dashboard/admin/fees.aspx">
                            <i class="bi bi-x-circle me-2"></i>Reset
                        </asp:HyperLink>
                    </div>
                </div>
            </div>

            <div class="table-wrap">
                <div class="table-responsive">
                    <asp:GridView ID="gvFees" runat="server" AutoGenerateColumns="False" CssClass="table table-hover align-middle table-sticky"
                        DataKeyNames="StudentID" OnRowDataBound="gvFees_RowDataBound">
                        <Columns>
                            <asp:BoundField DataField="RollNo" HeaderText="Roll" />
                            <asp:TemplateField HeaderText="Student">
                                <ItemTemplate>
                                    <div class="fw-semibold text-truncate"><%# Eval("StudentName") %></div>
                                    <div class="text-muted small">ID: <%# Eval("StudentID") %></div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="ClassName" HeaderText="Class" />
                            <asp:BoundField DataField="TotalFees" HeaderText="Total" DataFormatString="{0:C}" />
                            <asp:BoundField DataField="AmountPaid" HeaderText="Paid" DataFormatString="{0:C}" />
                            <asp:BoundField DataField="BalanceDue" HeaderText="Balance" DataFormatString="{0:C}" />
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class='badge badge-status rounded-pill <%# Eval("StatusClass") %>'><%# Eval("Status") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="DueDate" HeaderText="Due" DataFormatString="{0:dd-MMM-yyyy}" />
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <div class="d-flex flex-wrap gap-2">
                                        <asp:HyperLink ID="lnkCollect" runat="server" CssClass="btn btn-sm btn-success"
                                            NavigateUrl='<%# Eval("StudentID", "~/dashboard/admin/collectfee.aspx?studentId={0}") %>'>
                                            <i class="bi bi-wallet"></i>
                                            <span class="ms-1">Collect</span>
                                        </asp:HyperLink>
                                        <asp:LinkButton ID="lnkViewDetails" runat="server" CssClass="btn btn-sm btn-outline-info" CommandName="ViewDetails" CommandArgument='<%# Eval("StudentID") %>'>
                                            <i class="bi bi-info-circle"></i>
                                            <span class="ms-1">Details</span>
                                        </asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="alert alert-info m-3" role="alert">
                                No fee records found matching the selected criteria.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>

        </div>
    </div>

</asp:Content>
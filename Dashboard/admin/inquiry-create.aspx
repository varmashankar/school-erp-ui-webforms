<%@ Page Language="C#" Async="true" AutoEventWireup="true" CodeFile="inquiry-create.aspx.cs" Inherits="Dashboard_admin_inquiry_create" MasterPageFile="~/Master/admin.master" %>

<asp:Content ID="Content0" ContentPlaceHolderID="head" runat="Server">
    <style>
        .form-card {
            background: #ffffff;
            border: 1px solid rgba(0,0,0,.06);
            border-radius: .75rem;
            padding: 1rem;
        }

        .form-card .form-label {
            margin-bottom: .25rem;
            font-size: .8rem;
            color: #6c757d;
        }

        .hint {
            font-size: .8rem;
            color: #6b7280;
        }

        input[type="date"].form-control,
        input[type="datetime-local"].form-control {
            min-height: 40px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="pageTitle" runat="server">
    <div class="d-flex align-items-center justify-content-between">
        <div class="d-flex flex-column">
            <h5 class="m-0">Create Inquiry</h5>
            <span class="text-muted small">Capture lead details for the admission funnel</span>
        </div>
        <a class="btn bg-white btn-sm" href="inquiries.aspx">
            <i class="bi bi-arrow-left me-1"></i>Back
        </a>
    </div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <div class="row g-3">
            <div class="col-12 col-lg-8">
                <div class="card shadow-sm border-0">
                    <div class="card-body">
                        <div class="form-card">
                            <div class="row g-3">
                                <div class="col-12 col-md-6">
                                    <label class="form-label" for="txtFirstName">First Name <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="First name" />
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label" for="txtLastName">Last Name <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Last name" />
                                </div>

                                <div class="col-12 col-md-6">
                                    <label class="form-label" for="txtPhone">Phone <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="9999999999" />
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label" for="txtEmail">Email <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="name@example.com" TextMode="Email" />
                                </div>

                                <div class="col-12 col-md-6">
                                    <label class="form-label" for="ddlClass">Class <span class="text-danger">*</span></label>
                                    <asp:DropDownList ID="ddlClass" runat="server" CssClass="form-select" />
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label" for="ddlStream">Stream <span class="text-danger">*</span></label>
                                    <asp:DropDownList ID="ddlStream" runat="server" CssClass="form-select" />
                                </div>

                                <div class="col-12">
                                    <label class="form-label" for="txtSource">Source <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtSource" runat="server" CssClass="form-control" placeholder="WALKIN / WEBSITE" />
                                    <div class="hint mt-1">Example: WEBSITE, WALKIN, REFERRAL</div>
                                </div>

                                <div class="col-12">
                                    <hr />
                                    <div class="d-flex align-items-center gap-2 mb-2">
                                        <i class="bi bi-lock text-muted"></i>
                                        <div class="fw-semibold">Admin-only fields</div>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <label class="form-label" for="txtNotes">Notes</label>
                                    <asp:TextBox ID="txtNotes" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Internal notes" />
                                </div>

                                <div class="col-12 col-md-6">
                                    <label class="form-label" for="txtNextFollowUpAt">Next Follow-up</label>
                                    <asp:TextBox ID="txtNextFollowUpAt" runat="server" CssClass="form-control" TextMode="DateTimeLocal" />
                                    <div class="hint mt-1">Optional. Used to schedule the next reminder.</div>
                                </div>

                                <div class="col-12 d-flex gap-2 flex-wrap">
                                    <asp:LinkButton ID="btnSave" runat="server" CssClass="btn btn-primary" OnClick="btnSave_Click">
                                        <i class="bi bi-save2 me-1"></i>Save Inquiry
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnClear" runat="server" CssClass="btn btn-outline-secondary" OnClick="btnClear_Click" CausesValidation="false">
                                        <i class="bi bi-x-circle me-1"></i>Clear
                                    </asp:LinkButton>
                                </div>

                                <div class="col-12">
                                    <asp:Label ID="lblInfo" runat="server" CssClass="text-muted small" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-12 col-lg-4">
                <div class="card shadow-sm border-0">
                    <div class="card-body">
                        <div class="fw-semibold mb-2">Tips</div>
                        <ul class="text-muted small mb-0">
                            <li>All starred fields are mandatory.</li>
                            <li>Use Notes for internal remarks.</li>
                            <li>After saving, you can add follow-ups from the inquiries list.</li>
                        </ul>
                    </div>
                </div>
            </div>

        </div>
    </div>
</asp:Content>

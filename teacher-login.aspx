<%@ Page Language="C#" Async="true" AutoEventWireup="true" CodeFile="teacher-login.aspx.cs" Inherits="teacher_login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <title>Teacher Portal | School ERP</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="description" content="Teacher login page for School ERP. Sign in to access your dashboard." />
    <link rel="icon" type="image/png" href="/favicon.ico" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css"/>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600;700&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            overflow-x: hidden;
            min-height: 100vh;
        }

        .font-playfair {
            font-family: 'Playfair Display', serif;
        }

        .main-container {
            position: relative;
            width: 100%;
            min-height: 100vh;
            display: flex;
        }

        /* Left side - Image/Branding */
        .brand-side {
            display: none;
            width: 50%;
            background: linear-gradient(135deg, #1e3a5f 0%, #2d5a87 100%);
            position: relative;
            overflow: hidden;
        }

        @media (min-width: 1024px) {
            .brand-side {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 48px;
            }
        }

        .brand-content {
            position: relative;
            z-index: 10;
            text-align: center;
            color: white;
            max-width: 400px;
        }

        .brand-logo {
            width: 100%;
            height: auto;
            border-radius: 28px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 22px;
        }

        .brand-logo-img {
            width: 50rem;
            height: auto;
            object-fit: contain;
        }

        .brand-title {
            font-family: 'Playfair Display', serif;
            font-size: 42px;
            font-weight: 700;
            margin-bottom: 12px;
            line-height: 1.2;
        }

        .brand-subtitle {
            font-size: 16px;
            opacity: 0.9;
            color: #e8c547;
            font-weight: 500;
            letter-spacing: 1px;
        }

        /* Decorative elements */
        .decoration-circle {
            position: absolute;
            border-radius: 50%;
            opacity: 0.1;
        }

        .circle-1 {
            width: 500px;
            height: 500px;
            background: linear-gradient(135deg, #c9a227 0%, #e8c547 100%);
            top: -200px;
            right: -200px;
        }

        .circle-2 {
            width: 300px;
            height: 300px;
            background: white;
            bottom: -100px;
            left: -100px;
        }

        /* Right side - Login Form */
        .login-side {
            width: 100%;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 32px 24px;
            background: linear-gradient(180deg, #f8fafc 0%, #e2e8f0 100%);
        }

        @media (min-width: 1024px) {
            .login-side {
                width: 50%;
                background: white;
            }
        }

        .login-card {
            width: 100%;
            max-width: 420px;
            background: white;
            border-radius: 24px;
            padding: 40px 32px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
        }

        @media (min-width: 1024px) {
            .login-card {
                box-shadow: none;
                padding: 0;
                background: transparent;
            }
        }

        .mobile-logo {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 32px;
        }

        @media (min-width: 1024px) {
            .mobile-logo {
                display: none;
            }
        }

        .mobile-logo-wrapper {
            width: 64px;
            height: 64px;
            background: linear-gradient(135deg, #1e3a5f 0%, #2d5a87 100%);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 20px rgba(30, 58, 95, 0.3);
        }

            .mobile-logo-wrapper img {
                width: 40px;
                height: 40px;
            }

        .login-header {
            margin-bottom: 32px;
        }

        .teacher-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: linear-gradient(135deg, #c9a227 0%, #e8c547 100%);
            color: white;
            font-size: 11px;
            font-weight: 600;
            padding: 6px 14px;
            border-radius: 20px;
            margin-bottom: 16px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .login-title {
            font-family: 'Playfair Display', serif;
            color: #1e3a5f;
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .login-subtitle {
            color: #64748b;
            font-size: 15px;
        }

        .input-group {
            margin-bottom: 20px;
        }

            .input-group label {
                display: block;
                color: #374151;
                font-size: 13px;
                font-weight: 600;
                margin-bottom: 8px;
            }

        .input-wrapper {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #9ca3af;
            font-size: 16px;
            transition: color 0.3s ease;
        }

        .form-input {
            width: 100%;
            padding: 14px 16px 14px 48px;
            background: #f8fafc;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            color: #1e293b;
            font-size: 14px;
            transition: all 0.3s ease;
        }

            .form-input::placeholder {
                color: #94a3b8;
            }

            .form-input:focus {
                outline: none;
                background: white;
                border-color: #c9a227;
                box-shadow: 0 0 0 4px rgba(201, 162, 39, 0.1);
            }

                .form-input:focus + .input-icon {
                    color: #c9a227;
                }

        .toggle-password {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #9ca3af;
            cursor: pointer;
            padding: 4px;
            transition: color 0.3s ease;
        }

            .toggle-password:hover {
                color: #1e3a5f;
            }

        .remember-forgot {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #64748b;
            font-size: 13px;
            cursor: pointer;
        }

            .remember-me input[type="checkbox"] {
                appearance: none;
                width: 18px;
                height: 18px;
                background: #f1f5f9;
                border: 2px solid #e2e8f0;
                border-radius: 4px;
                cursor: pointer;
                transition: all 0.2s ease;
            }

                .remember-me input[type="checkbox"]:checked {
                    background: linear-gradient(135deg, #1e3a5f 0%, #2d5a87 100%);
                    border-color: #1e3a5f;
                }

                    .remember-me input[type="checkbox"]:checked::after {
                        content: '\2713';
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: white;
                        font-size: 12px;
                        font-weight: bold;
                    }

        .forgot-link {
            color: #c9a227;
            font-size: 13px;
            font-weight: 500;
            text-decoration: none;
            transition: color 0.3s ease;
        }

            .forgot-link:hover {
                color: #1e3a5f;
                text-decoration: underline;
            }

        .btn-login {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #1e3a5f 0%, #2d5a87 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(30, 58, 95, 0.3);
            position: relative;
            overflow: hidden;
        }

            .btn-login:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(30, 58, 95, 0.4);
            }

            .btn-login:active {
                transform: translateY(0);
            }

            .btn-login.loading {
                pointer-events: none;
                opacity: 0.8;
            }

                .btn-login.loading::after {
                    content: '';
                    position: absolute;
                    top: 50%;
                    left: 50%;
                    width: 20px;
                    height: 20px;
                    margin: -10px 0 0 -10px;
                    border: 3px solid transparent;
                    border-top-color: white;
                    border-radius: 50%;
                    animation: spin 0.8s linear infinite;
                }

        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }

        .divider {
            display: flex;
            align-items: center;
            margin: 24px 0;
            color: #94a3b8;
            font-size: 12px;
        }

            .divider::before,
            .divider::after {
                content: '';
                flex: 1;
                height: 1px;
                background: #e2e8f0;
            }

            .divider span {
                padding: 0 16px;
            }

        .back-link {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            color: #64748b;
            font-size: 13px;
            text-decoration: none;
            transition: color 0.3s ease;
        }

            .back-link:hover {
                color: #1e3a5f;
            }

        .footer-text {
            text-align: center;
            margin-top: 32px;
            padding-top: 24px;
            border-top: 1px solid #e2e8f0;
            color: #94a3b8;
            font-size: 12px;
        }

        @media (max-width: 480px) {
            .login-card {
                padding: 32px 24px;
            }

            .login-title {
                font-size: 26px;
            }

            .remember-forgot {
                flex-direction: column;
                gap: 12px;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <!-- Left Brand Side (Desktop) -->
        <div class="brand-side">
            <div class="decoration-circle circle-1"></div>
            <div class="decoration-circle circle-2"></div>
            
            <div class="brand-content">
                <div class="brand-logo">
                    <asp:Image ID="imgLogo" runat="server" AlternateText="School Logo" />
                </div>
                <h1 class="brand-title"><asp:Literal ID="litSchoolName" runat="server" Text="School ERP" /></h1>
                <p class="brand-subtitle"><asp:Literal ID="litSchoolTag" runat="server" Text="Excellence in Education" /></p>
            </div>
        </div>

        <!-- Right Login Side -->
        <div class="login-side">
            <form id="form1" runat="server" class="login-card">
                <!-- Mobile Logo -->
                <div class="mobile-logo">
                    <div class="mobile-logo-wrapper">
                        <asp:Image ID="imgLogoMobile" runat="server" AlternateText="School Logo" />
                    </div>
                </div>

                <div class="login-header">
                    <span class="teacher-badge">
                        <i class="fas fa-chalkboard-teacher"></i>
                        Teacher Access
                    </span>
                    <h1 class="login-title">Welcome Back</h1>
                    <p class="login-subtitle">Sign in to your teacher portal</p>
                </div>

                <div class="input-group">
                    <label for="<%= txtUsername.ClientID %>">Email or Mobile Number</label>
                    <div class="input-wrapper">
                        <asp:TextBox ID="txtUsername" runat="server" placeholder="Enter your email or mobile" CssClass="form-input" autocomplete="username" required="required" />
                        <i class="fas fa-user input-icon"></i>
                    </div>
                </div>

                <div class="input-group">
                    <label for="<%= txtPassword.ClientID %>">Password</label>
                    <div class="input-wrapper">
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter your password" CssClass="form-input" autocomplete="current-password" required="required" />
                        <i class="fas fa-lock input-icon"></i>
                        <button type="button" class="toggle-password" onclick="togglePassword()" aria-label="Show password">
                            <i class="fas fa-eye" id="toggleIcon"></i>
                        </button>
                    </div>
                </div>

                <div class="remember-forgot">
                    <label class="remember-me">
                        <asp:CheckBox ID="chkRemember" runat="server" />
                        <span>Remember me</span>
                    </label>
                    <a href="forgotpassword.aspx" class="forgot-link">Forgot Password?</a>
                </div>

                <asp:Button ID="btnLogin" runat="server" CssClass="btn-login" OnClick="btnLogin_Click" OnClientClick="setLoading(); return true;" Text="Sign In" />

                <div class="divider">
                    <span>or</span>
                </div>

                <a href="Default.aspx" class="back-link">
                    <i class="fas fa-arrow-left"></i>
                    Back to Website
                </a>

                <div class="footer-text">
                    &copy; <%= DateTime.Now.Year %> LOGICAL WAVE. All rights reserved.
                </div>
            </form>
        </div>
    </div>

    <script>
        function togglePassword() {
            var pwdField = document.getElementById('<%= txtPassword.ClientID %>');
            var icon = document.getElementById('toggleIcon');
            if (pwdField.type === 'password') {
                pwdField.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                pwdField.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }

        function setLoading() {
            var btn = document.getElementById('<%= btnLogin.ClientID %>');
            btn.classList.add('loading');
            btn.value = '';
        }

        window.addEventListener('load', function() {
            var btn = document.getElementById('<%= btnLogin.ClientID %>');
            btn.classList.remove('loading');
            btn.value = 'Sign In';
        });
    </script>
</body>
</html>
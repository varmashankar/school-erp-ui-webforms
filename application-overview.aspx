<%@ Page Language="C#" AutoEventWireup="true" CodeFile="application-overview.aspx.cs" Inherits="ApplicationOverview" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Application Overview | Westbrook Academy</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600;700&display=swap');
        
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #f8fafc; min-height: 100vh; }
        .font-playfair { font-family: 'Playfair Display', serif; }
        
        .gradient-primary { background: linear-gradient(135deg, #1e3a5f 0%, #2d5a87 100%); }
        .gradient-accent { background: linear-gradient(135deg, #c9a227 0%, #e8c547 100%); }
        
        /* Progress Steps Container */
        .steps-container {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            position: relative;
            padding: 0 10px;
        }
        
        /* Progress Line Background */
        .steps-container::before {
            content: '';
            position: absolute;
            top: 20px;
            left: 60px;
            right: 60px;
            height: 3px;
            background: #e2e8f0;
            z-index: 0;
        }
        
        .step-indicator {
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            z-index: 1;
            flex: 1;
            max-width: 120px;
        }
        
        .step-circle {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            color: #64748b;
            position: relative;
            z-index: 2;
            border: 3px solid #fff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }
        
        .step-indicator.active .step-circle {
            background: linear-gradient(135deg, #c9a227 0%, #e8c547 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(201, 162, 39, 0.4);
        }
        
        .step-indicator.completed .step-circle {
            background: #22c55e;
            color: white;
            box-shadow: 0 4px 15px rgba(34, 197, 94, 0.4);
        }
        
        .step-label {
            margin-top: 10px;
            font-size: 12px;
            color: #64748b;
            text-align: center;
            font-weight: 500;
            line-height: 1.3;
        }
        
        .step-indicator.active .step-label {
            color: #b8860b;
            font-weight: 600;
        }
        
        .step-indicator.completed .step-label {
            color: #16a34a;
            font-weight: 600;
        }
        
        /* Progress fill line */
        .progress-line {
            position: absolute;
            top: 20px;
            left: 60px;
            height: 3px;
            background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
            z-index: 0;
            transition: width 0.5s ease;
        }
        
        .document-card {
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        
        .document-card:hover {
            border-color: #c9a227;
            transform: translateY(-2px);
        }
        
        .document-card.required {
            border-left: 4px solid #ef4444;
        }
        
        .document-card.optional {
            border-left: 4px solid #94a3b8;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #1e3a5f 0%, #2d5a87 100%);
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px -5px rgba(30, 58, 95, 0.4);
        }
        
        .btn-secondary {
            background: white;
            border: 2px solid #e2e8f0;
            transition: all 0.3s ease;
        }
        
        .btn-secondary:hover {
            border-color: #c9a227;
            background: #fffbeb;
        }
        
        .info-card {
            background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
            border: 1px solid #93c5fd;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header -->
        <header class="bg-white shadow-sm sticky top-0 z-50">
            <div class="max-w-5xl mx-auto px-4 py-4">
                <div class="flex items-center justify-between">
                    <a href="Default.aspx" class="flex items-center space-x-3">
                        <div class="w-10 h-10 gradient-primary rounded-lg flex items-center justify-center">
                            <i class="fas fa-graduation-cap text-white text-sm"></i>
                        </div>
                        <span class="font-playfair font-bold text-slate-800">Westbrook Academy</span>
                    </a>
                    <div class="text-right">
                        <span class="text-sm text-slate-500">Application for</span>
                        <p class="font-semibold text-slate-800" id="gradeDisplay">Grade 1 | 2025-2026</p>
                    </div>
                </div>
            </div>
        </header>

        <main class="max-w-5xl mx-auto px-4 py-8">
            <!-- Page Header -->
            <div class="text-center mb-10">
                <div class="inline-flex items-center justify-center w-20 h-20 gradient-accent rounded-full mb-6">
                    <i class="fas fa-clipboard-list text-white text-3xl"></i>
                </div>
                <h1 class="font-playfair text-3xl md:text-4xl font-bold text-slate-800 mb-3">
                    Before You Begin
                </h1>
                <p class="text-slate-600 text-lg max-w-2xl mx-auto">
                    Here's what to expect during the application process. We've made it simple and straightforward.
                </p>
            </div>

            <!-- Time Estimate Card -->
            <div class="info-card rounded-2xl p-6 mb-8 flex flex-col md:flex-row items-center justify-between">
                <div class="flex items-center space-x-4 mb-4 md:mb-0">
                    <div class="w-14 h-14 bg-blue-500 rounded-xl flex items-center justify-center">
                        <i class="fas fa-clock text-white text-xl"></i>
                    </div>
                    <div>
                        <h3 class="font-bold text-blue-900 text-lg">Estimated Time</h3>
                        <p class="text-blue-700">This application takes about <strong>10-12 minutes</strong> to complete</p>
                    </div>
                </div>
                <div class="flex items-center space-x-2 text-blue-700">
                    <i class="fas fa-save"></i>
                    <span class="text-sm font-medium">Your progress is auto-saved</span>
                </div>
            </div>

            <!-- Progress Steps -->
            <div class="bg-white rounded-2xl shadow-lg p-6 md:p-8 mb-8">
                <h2 class="font-playfair text-xl font-bold text-slate-800 mb-6">Application Steps</h2>
                
                <div class="steps-container">
                    <!-- Progress fill line (dynamically set width via JS if needed) -->
                    <div class="progress-line" style="width: 0%;"></div>
                    
                    <div class="step-indicator active">
                        <div class="step-circle">1</div>
                        <span class="step-label">Student<br/>Details</span>
                    </div>
                    <div class="step-indicator">
                        <div class="step-circle">2</div>
                        <span class="step-label">Parent<br/>Information</span>
                    </div>
                    <div class="step-indicator">
                        <div class="step-circle">3</div>
                        <span class="step-label">Academic<br/>History</span>
                    </div>
                    <div class="step-indicator">
                        <div class="step-circle">4</div>
                        <span class="step-label">Document<br/>Upload</span>
                    </div>
                    <div class="step-indicator">
                        <div class="step-circle">5</div>
                        <span class="step-label">Review &<br/>Submit</span>
                    </div>
                </div>
            </div>

            <!-- Two Column Layout -->
            <div class="grid md:grid-cols-2 gap-8 mb-8">
                <!-- Documents Required -->
                <div class="bg-white rounded-2xl shadow-lg p-6">
                    <h2 class="font-playfair text-xl font-bold text-slate-800 mb-4 flex items-center">
                        <i class="fas fa-file-alt text-amber-500 mr-3"></i>
                        Documents You'll Need
                    </h2>
                    <p class="text-slate-500 text-sm mb-4">Have these ready for upload (photo/scan)</p>
                    
                    <div class="space-y-3">
                        <div class="document-card required bg-slate-50 rounded-xl p-4">
                            <div class="flex items-start space-x-3">
                                <div class="w-8 h-8 bg-red-100 rounded-lg flex items-center justify-center flex-shrink-0">
                                    <i class="fas fa-id-card text-red-500 text-sm"></i>
                                </div>
                                <div>
                                    <h4 class="font-semibold text-slate-800 text-sm">Birth Certificate</h4>
                                    <p class="text-xs text-slate-500">Government issued document</p>
                                </div>
                                <span class="ml-auto text-xs font-medium text-red-600 bg-red-50 px-2 py-1 rounded">Required</span>
                            </div>
                        </div>
                        
                        <div class="document-card required bg-slate-50 rounded-xl p-4">
                            <div class="flex items-start space-x-3">
                                <div class="w-8 h-8 bg-red-100 rounded-lg flex items-center justify-center flex-shrink-0">
                                    <i class="fas fa-camera text-red-500 text-sm"></i>
                                </div>
                                <div>
                                    <h4 class="font-semibold text-slate-800 text-sm">Passport Photo</h4>
                                    <p class="text-xs text-slate-500">Recent color photograph</p>
                                </div>
                                <span class="ml-auto text-xs font-medium text-red-600 bg-red-50 px-2 py-1 rounded">Required</span>
                            </div>
                        </div>
                        
                        <div class="document-card optional bg-slate-50 rounded-xl p-4">
                            <div class="flex items-start space-x-3">
                                <div class="w-8 h-8 bg-slate-200 rounded-lg flex items-center justify-center flex-shrink-0">
                                    <i class="fas fa-file-invoice text-slate-500 text-sm"></i>
                                </div>
                                <div>
                                    <h4 class="font-semibold text-slate-800 text-sm">Previous Report Card</h4>
                                    <p class="text-xs text-slate-500">Last academic year</p>
                                </div>
                                <span class="ml-auto text-xs font-medium text-slate-500 bg-slate-100 px-2 py-1 rounded">If applicable</span>
                            </div>
                        </div>
                        
                        <div class="document-card optional bg-slate-50 rounded-xl p-4">
                            <div class="flex items-start space-x-3">
                                <div class="w-8 h-8 bg-slate-200 rounded-lg flex items-center justify-center flex-shrink-0">
                                    <i class="fas fa-certificate text-slate-500 text-sm"></i>
                                </div>
                                <div>
                                    <h4 class="font-semibold text-slate-800 text-sm">Transfer Certificate</h4>
                                    <p class="text-xs text-slate-500">From previous school</p>
                                </div>
                                <span class="ml-auto text-xs font-medium text-slate-500 bg-slate-100 px-2 py-1 rounded">Optional</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mt-4 p-3 bg-amber-50 rounded-lg border border-amber-200">
                        <p class="text-xs text-amber-700">
                            <i class="fas fa-lightbulb mr-1"></i>
                            Don't worry if you don't have all documents now. You can upload optional ones later.
                        </p>
                    </div>
                </div>
                
                <!-- What to Expect -->
                <div class="bg-white rounded-2xl shadow-lg p-6">
                    <h2 class="font-playfair text-xl font-bold text-slate-800 mb-4 flex items-center">
                        <i class="fas fa-info-circle text-blue-500 mr-3"></i>
                        What Happens Next
                    </h2>
                    
                    <div class="space-y-4">
                        <div class="flex items-start space-x-4">
                            <div class="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0">
                                <span class="text-green-600 font-bold text-sm">1</span>
                            </div>
                            <div>
                                <h4 class="font-semibold text-slate-800">Submit Application</h4>
                                <p class="text-sm text-slate-500">Complete all required fields and upload documents</p>
                            </div>
                        </div>
                        
                        <div class="flex items-start space-x-4">
                            <div class="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0">
                                <span class="text-green-600 font-bold text-sm">2</span>
                            </div>
                            <div>
                                <h4 class="font-semibold text-slate-800">Application Review</h4>
                                <p class="text-sm text-slate-500">Our admissions team reviews your application within 48 hours</p>
                            </div>
                        </div>
                        
                        <div class="flex items-start space-x-4">
                            <div class="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0">
                                <span class="text-green-600 font-bold text-sm">3</span>
                            </div>
                            <div>
                                <h4 class="font-semibold text-slate-800">Interaction Call</h4>
                                <p class="text-sm text-slate-500">We'll schedule a brief call to discuss your child's needs</p>
                            </div>
                        </div>
                        
                        <div class="flex items-start space-x-4">
                            <div class="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0">
                                <span class="text-green-600 font-bold text-sm">4</span>
                            </div>
                            <div>
                                <h4 class="font-semibold text-slate-800">Decision & Enrollment</h4>
                                <p class="text-sm text-slate-500">Receive admission decision and complete enrollment</p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Fee Notice -->
                    <div class="mt-6 p-4 bg-green-50 rounded-xl border border-green-200">
                        <div class="flex items-center space-x-3">
                            <div class="w-10 h-10 bg-green-500 rounded-full flex items-center justify-center flex-shrink-0">
                                <i class="fas fa-check text-white"></i>
                            </div>
                            <div>
                                <h4 class="font-bold text-green-800">No Application Fee</h4>
                                <p class="text-sm text-green-700">Submitting this application is completely free</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="bg-white rounded-2xl shadow-lg p-6 md:p-8">
                <div class="flex flex-col md:flex-row items-center justify-between gap-4">
                    <div class="flex items-center space-x-3 text-slate-600">
                        <i class="fas fa-shield-alt text-green-500"></i>
                        <span class="text-sm">Your information is encrypted and secure</span>
                    </div>
                    
                    <div class="flex flex-col sm:flex-row gap-3 w-full md:w-auto">
                        <button type="button" onclick="saveForLater()" 
                                class="btn-secondary px-6 py-3 rounded-xl font-medium text-slate-700 flex items-center justify-center">
                            <i class="fas fa-bookmark mr-2"></i>
                            Save & Continue Later
                        </button>
                        <button type="button" onclick="startApplication()" 
                                class="btn-primary px-8 py-3 rounded-xl font-semibold text-white flex items-center justify-center">
                            Start Application
                            <i class="fas fa-arrow-right ml-2"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Help Section -->
            <div class="text-center mt-8">
                <p class="text-slate-500">
                    Have questions? 
                    <a href="tel:+911234567890" class="text-blue-600 font-medium hover:underline">Call +91 12345 67890</a>
                    or 
                    <a href="mailto:admissions@westbrook.edu" class="text-blue-600 font-medium hover:underline">email us</a>
                </p>
            </div>
        </main>

        <!-- Footer -->
        <footer class="bg-white border-t border-slate-200 py-6 mt-12">
            <div class="max-w-5xl mx-auto px-4 text-center">
                <p class="text-sm text-slate-500">
                    © 2024 Westbrook Academy | 
                    <a href="#" class="text-blue-600 hover:underline">Privacy Policy</a>
                </p>
            </div>
        </footer>

        <script>
            // Check if user came from eligibility check
            document.addEventListener('DOMContentLoaded', async function() {
                const urlParams = new URLSearchParams(window.location.search);
                const tokenFromUrl = urlParams.get('token');

                const token = tokenFromUrl || sessionStorage.getItem('resume_token');
                if (tokenFromUrl) sessionStorage.setItem('resume_token', tokenFromUrl);

                const eligible = sessionStorage.getItem('admission_eligible');
                if (!eligible || eligible !== 'true') {
                    window.location.href = 'apply-now.aspx';
                    return;
                }

                const grade = sessionStorage.getItem('admission_grade');
                const year = sessionStorage.getItem('admission_year');

                const gradeNames = {
                    'nursery': 'Nursery', 'lkg': 'LKG', 'ukg': 'UKG',
                    '1': 'Grade 1', '2': 'Grade 2', '3': 'Grade 3',
                    '4': 'Grade 4', '5': 'Grade 5', '6': 'Grade 6',
                    '7': 'Grade 7', '8': 'GRADE 8', '9': 'Grade 9',
                    '10': 'Grade 10', '11': 'Grade 11', '12': 'Grade 12'
                };

                document.getElementById('gradeDisplay').textContent = (gradeNames[grade] || grade) + ' | ' + year;

                // Hydrate admission number if possible
                if (token) {
                    try {
                        const res = await fetch('<%= ResolveUrl("~") %>' + 'admission-draft-api.ashx?action=payload&token=' + encodeURIComponent(token));
                        const data = await res.json();
                        if (data && data.ok && data.payload && data.payload.draft && data.payload.draft.admission_no) {
                            sessionStorage.setItem('application_id', data.payload.draft.admission_no);
                        }
                    } catch { }
                }
            });

            function startApplication() {
                const token = sessionStorage.getItem('resume_token');
                if (!token) {
                    alert('No draft found. Please start again.');
                    window.location.href = 'apply-now.aspx';
                    return;
                }
                window.location.href = 'application-student.aspx?token=' + encodeURIComponent(token);
            }

            async function saveForLater() {
                const token = sessionStorage.getItem('resume_token');
                const admissionNo = sessionStorage.getItem('application_id');
                if (!token) {
                    alert('No draft found.');
                    return;
                }

                const link = window.location.origin + window.location.pathname.replace('application-overview.aspx', 'application-overview.aspx') + '?token=' + encodeURIComponent(token);
                const otp = confirm('Copy resume link? Click OK to copy link. Click Cancel to request OTP using Admission No.');

                if (otp) {
                    try {
                        await navigator.clipboard.writeText(link);
                        alert('Resume link copied. Admission No: ' + (admissionNo || ''));
                    } catch {
                        alert('Resume link: ' + link + '\nAdmission No: ' + (admissionNo || ''));
                    }
                    return;
                }

                if (!admissionNo) {
                    alert('Admission No not available yet. Continue to Parent step and save once.');
                    return;
                }

                try {
                    const res = await fetch('<%= ResolveUrl("~") %>' + 'admission-draft-api.ashx?action=sendOtp', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ admission_no: admissionNo })
                    });
                    const data = await res.json();
                    if (!data || data.ok !== true) {
                        alert(data && data.message ? data.message : 'OTP request failed');
                        return;
                    }

                    const channel = prompt('OTP sent. Enter channel to verify (SMS or EMAIL):', 'SMS');
                    const destination = prompt('Enter destination (mobile/email used):');
                    const code = prompt('Enter OTP:');
                    if (!channel || !destination || !code) return;

                    const vr = await fetch('<%= ResolveUrl("~") %>' + 'admission-draft-api.ashx?action=verifyOtp', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ admission_no: admissionNo, channel: channel, destination: destination, otp: code })
                    });
                    const vdata = await vr.json();
                    if (vdata && vdata.ok === true && vdata.resume_token) {
                        sessionStorage.setItem('resume_token', vdata.resume_token);
                        alert('Verified. Resume link refreshed.');
                    } else {
                        alert(vdata && vdata.message ? vdata.message : 'OTP verify failed');
                    }
                }
                catch {
                    alert('Unable to reach server.');
                }
            }
        </script>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeFile="application-review.aspx.cs" Inherits="ApplicationReview" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Review & Submit - Step 5 of 5 | Westbrook Academy</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600;700&display=swap');
        
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #f8fafc; min-height: 100vh; }
        .font-playfair { font-family: 'Playfair Display', serif; }
        
        .gradient-primary { background: linear-gradient(135deg, #1e3a5f 0%, #2d5a87 100%); }
        .gradient-accent { background: linear-gradient(135deg, #c9a227 0%, #e8c547 100%); }
        
        .progress-bar { background: #e2e8f0; height: 4px; border-radius: 2px; overflow: hidden; }
        .progress-fill { height: 100%; background: linear-gradient(135deg, #c9a227 0%, #e8c547 100%); transition: width 0.5s ease; }
        
        .step-dot {
            width: 32px; height: 32px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 12px; font-weight: 600; transition: all 0.3s ease;
        }
        .step-dot.active { background: linear-gradient(135deg, #c9a227 0%, #e8c547 100%); color: white; }
        .step-dot.completed { background: #22c55e; color: white; }
        .step-dot.pending { background: #e2e8f0; color: #64748b; }
        
        .btn-primary { background: linear-gradient(135deg, #1e3a5f 0%, #2d5a87 100%); transition: all 0.3s ease; }
        .btn-primary:hover:not(:disabled) { transform: translateY(-2px); box-shadow: 0 10px 25px -5px rgba(30, 58, 95, 0.4); }
        .btn-primary:disabled { opacity: 0.5; cursor: not-allowed; }
        
        .btn-secondary { background: white; border: 2px solid #e2e8f0; transition: all 0.3s ease; }
        .btn-secondary:hover { border-color: #94a3b8; }
        
        .btn-submit { 
            background: linear-gradient(135deg, #c9a227 0%, #e8c547 100%); 
            transition: all 0.3s ease; 
        }
        .btn-submit:hover:not(:disabled) { 
            transform: translateY(-2px); 
            box-shadow: 0 10px 25px -5px rgba(201, 162, 39, 0.4); 
        }
        .btn-submit:disabled { opacity: 0.5; cursor: not-allowed; }
        
        .review-section {
            border: 1px solid #e2e8f0;
            border-radius: 1rem;
            overflow: hidden;
        }
        
        .review-section-header {
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .review-item {
            border-bottom: 1px solid #f1f5f9;
        }
        
        .review-item:last-child {
            border-bottom: none;
        }
        
        .edit-link {
            color: #3b82f6;
            transition: all 0.2s ease;
        }
        
        .edit-link:hover {
            color: #1d4ed8;
            text-decoration: underline;
        }
        
        .declaration-card {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            border: 2px solid #fcd34d;
        }
        
        .declaration-card.accepted {
            background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%);
            border-color: #86efac;
        }
        
        .checkbox-custom {
            width: 24px;
            height: 24px;
            border: 2px solid #cbd5e1;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .checkbox-custom.checked {
            background: #22c55e;
            border-color: #22c55e;
        }
        
        .document-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.25rem 0.75rem;
            background: #f0fdf4;
            border: 1px solid #86efac;
            border-radius: 9999px;
            font-size: 0.75rem;
            color: #166534;
        }
        
        .document-badge.missing {
            background: #fef2f2;
            border-color: #fca5a5;
            color: #991b1b;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header with Progress -->
        <header class="bg-white shadow-sm sticky top-0 z-50">
            <div class="max-w-4xl mx-auto px-4 py-4">
                <div class="flex items-center justify-between mb-4">
                    <div class="flex items-center space-x-3">
                        <a href="application-documents.aspx" class="text-slate-400 hover:text-slate-600">
                            <i class="fas fa-arrow-left"></i>
                        </a>
                        <div>
                            <h1 class="font-semibold text-slate-800">Review & Submit</h1>
                            <p class="text-xs text-slate-500">Step 5 of 5 - Final Step</p>
                        </div>
                    </div>
                </div>
                
                <!-- Progress Steps - All Completed -->
                <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-2">
                        <div class="step-dot completed"><i class="fas fa-check text-xs"></i></div>
                        <span class="text-xs text-green-600 font-medium hidden sm:inline">Student</span>
                    </div>
                    <div class="flex-1 mx-2">
                        <div class="progress-bar"><div class="progress-fill" style="width: 100%"></div></div>
                    </div>
                    <div class="flex items-center space-x-2">
                        <div class="step-dot completed"><i class="fas fa-check text-xs"></i></div>
                        <span class="text-xs text-green-600 font-medium hidden sm:inline">Parent</span>
                    </div>
                    <div class="flex-1 mx-2">
                        <div class="progress-bar"><div class="progress-fill" style="width: 100%"></div></div>
                    </div>
                    <div class="flex items-center space-x-2">
                        <div class="step-dot completed"><i class="fas fa-check text-xs"></i></div>
                        <span class="text-xs text-green-600 font-medium hidden sm:inline">Academic</span>
                    </div>
                    <div class="flex-1 mx-2">
                        <div class="progress-bar"><div class="progress-fill" style="width: 100%"></div></div>
                    </div>
                    <div class="flex items-center space-x-2">
                        <div class="step-dot completed"><i class="fas fa-check text-xs"></i></div>
                        <span class="text-xs text-green-600 font-medium hidden sm:inline">Documents</span>
                    </div>
                    <div class="flex-1 mx-2">
                        <div class="progress-bar"><div class="progress-fill" style="width: 100%"></div></div>
                    </div>
                    <div class="flex items-center space-x-2">
                        <div class="step-dot active">5</div>
                        <span class="text-xs text-amber-600 font-medium hidden sm:inline">Review</span>
                    </div>
                </div>
            </div>
        </header>

        <main class="max-w-2xl mx-auto px-4 py-8">
            <!-- Application Summary Header -->
            <div class="bg-white rounded-2xl shadow-lg p-6 mb-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-slate-500">Application ID</p>
                        <p class="font-mono font-bold text-lg text-slate-800" id="applicationId">WA-XXXXXX</p>
                    </div>
                    <div class="text-right">
                        <p class="text-sm text-slate-500">Applying for</p>
                        <p class="font-semibold text-slate-800" id="gradeYear">Grade 1 | 2025-26</p>
                    </div>
                </div>
            </div>

            <!-- Review Sections -->
            <div class="space-y-6">
                
                <!-- Student Details Section -->
                <div class="review-section bg-white">
                    <div class="review-section-header px-6 py-4 flex items-center justify-between">
                        <div class="flex items-center space-x-3">
                            <div class="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                                <i class="fas fa-user-graduate text-blue-600"></i>
                            </div>
                            <h3 class="font-semibold text-slate-800">Student Details</h3>
                        </div>
                        <a href="application-student.aspx" class="edit-link text-sm font-medium">
                            <i class="fas fa-pencil-alt mr-1"></i>Edit
                        </a>
                    </div>
                    <div class="p-6">
                        <div class="grid sm:grid-cols-2 gap-4">
                            <div class="review-item pb-3">
                                <p class="text-xs text-slate-400 uppercase tracking-wider">Full Name</p>
                                <p class="font-medium text-slate-800" id="studentName">--</p>
                            </div>
                            <div class="review-item pb-3">
                                <p class="text-xs text-slate-400 uppercase tracking-wider">Gender</p>
                                <p class="font-medium text-slate-800" id="studentGender">--</p>
                            </div>
                            <div class="review-item pb-3">
                                <p class="text-xs text-slate-400 uppercase tracking-wider">Date of Birth</p>
                                <p class="font-medium text-slate-800" id="studentDob">--</p>
                            </div>
                            <div class="review-item pb-3">
                                <p class="text-xs text-slate-400 uppercase tracking-wider">Nationality</p>
                                <p class="font-medium text-slate-800" id="studentNationality">--</p>
                            </div>
                            <div class="review-item pb-3">
                                <p class="text-xs text-slate-400 uppercase tracking-wider">Blood Group</p>
                                <p class="font-medium text-slate-800" id="studentBloodGroup">--</p>
                            </div>
                            <div class="review-item pb-3">
                                <p class="text-xs text-slate-400 uppercase tracking-wider">Medical Conditions</p>
                                <p class="font-medium text-slate-800" id="studentMedical">--</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Parent Details Section -->
                <div class="review-section bg-white">
                    <div class="review-section-header px-6 py-4 flex items-center justify-between">
                        <div class="flex items-center space-x-3">
                            <div class="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center">
                                <i class="fas fa-user-friends text-purple-600"></i>
                            </div>
                            <h3 class="font-semibold text-slate-800">Parent/Guardian Details</h3>
                        </div>
                        <a href="application-parent.aspx" class="edit-link text-sm font-medium">
                            <i class="fas fa-pencil-alt mr-1"></i>Edit
                        </a>
                    </div>
                    <div class="p-6">
                        <div class="grid sm:grid-cols-2 gap-4">
                            <div class="review-item pb-3">
                                <p class="text-xs text-slate-400 uppercase tracking-wider">Name</p>
                                <p class="font-medium text-slate-800" id="parentName">--</p>
                            </div>
                            <div class="review-item pb-3">
                                <p class="text-xs text-slate-400 uppercase tracking-wider">Relationship</p>
                                <p class="font-medium text-slate-800" id="parentRelation">--</p>
                            </div>
                            <div class="review-item pb-3">
                                <p class="text-xs text-slate-400 uppercase tracking-wider">Mobile</p>
                                <p class="font-medium text-slate-800" id="parentMobile">--</p>
                            </div>
                            <div class="review-item pb-3">
                                <p class="text-xs text-slate-400 uppercase tracking-wider">Email</p>
                                <p class="font-medium text-slate-800" id="parentEmail">--</p>
                            </div>
                            <div class="review-item pb-3 sm:col-span-2">
                                <p class="text-xs text-slate-400 uppercase tracking-wider">Address</p>
                                <p class="font-medium text-slate-800" id="parentAddress">--</p>
                            </div>
                            <div class="review-item pb-3">
                                <p class="text-xs text-slate-400 uppercase tracking-wider">Preferred Contact</p>
                                <p class="font-medium text-slate-800" id="contactMethod">--</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Academic History Section -->
                <div class="review-section bg-white">
                    <div class="review-section-header px-6 py-4 flex items-center justify-between">
                        <div class="flex items-center space-x-3">
                            <div class="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center">
                                <i class="fas fa-book text-green-600"></i>
                            </div>
                            <h3 class="font-semibold text-slate-800">Academic History</h3>
                        </div>
                        <a href="application-academic.aspx" class="edit-link text-sm font-medium">
                            <i class="fas fa-pencil-alt mr-1"></i>Edit
                        </a>
                    </div>
                    <div class="p-6" id="academicContent">
                        <!-- Content populated by JS -->
                    </div>
                </div>

                <!-- Documents Section -->
                <div class="review-section bg-white">
                    <div class="review-section-header px-6 py-4 flex items-center justify-between">
                        <div class="flex items-center space-x-3">
                            <div class="w-10 h-10 bg-amber-100 rounded-lg flex items-center justify-center">
                                <i class="fas fa-file-alt text-amber-600"></i>
                            </div>
                            <h3 class="font-semibold text-slate-800">Uploaded Documents</h3>
                        </div>
                        <a href="application-documents.aspx" class="edit-link text-sm font-medium">
                            <i class="fas fa-pencil-alt mr-1"></i>Edit
                        </a>
                    </div>
                    <div class="p-6">
                        <div class="flex flex-wrap gap-2" id="documentsContent">
                            <!-- Content populated by JS -->
                        </div>
                    </div>
                </div>

                <!-- Declaration Section -->
                <div class="declaration-card rounded-2xl p-6" id="declarationCard">
                    <div class="flex items-start space-x-4">
                        <div class="checkbox-custom" id="declarationCheckbox" onclick="toggleDeclaration()">
                            <i class="fas fa-check text-white text-sm hidden" id="checkIcon"></i>
                        </div>
                        <div class="flex-1">
                            <h4 class="font-semibold text-slate-800 mb-2">Declaration</h4>
                            <p class="text-sm text-slate-700 leading-relaxed">
                                I hereby declare that all the information provided in this application is true 
                                and accurate to the best of my knowledge. I understand that providing false 
                                information may result in the rejection of this application or cancellation 
                                of admission. I agree to the 
                                <a href="#" class="text-blue-600 underline">Terms and Conditions</a> and 
                                <a href="#" class="text-blue-600 underline">Privacy Policy</a> of Westbrook Academy.
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Submit Section -->
                <div class="bg-white rounded-2xl shadow-lg p-6">
                    <div class="text-center mb-6">
                        <div class="w-16 h-16 gradient-accent rounded-full flex items-center justify-center mx-auto mb-4">
                            <i class="fas fa-paper-plane text-white text-2xl"></i>
                        </div>
                        <h3 class="font-playfair text-xl font-bold text-slate-800 mb-2">Ready to Submit?</h3>
                        <p class="text-slate-500 text-sm">
                            Please review all details above before submitting. Once submitted, you'll receive 
                            a confirmation email with your application tracking link.
                        </p>
                    </div>
                    
                    <div class="flex flex-col sm:flex-row gap-3">
                        <button type="button" onclick="goBack()" 
                                class="btn-secondary flex-1 py-3 rounded-xl font-medium text-slate-600 flex items-center justify-center order-2 sm:order-1">
                            <i class="fas fa-arrow-left mr-2"></i>
                            Back to Documents
                        </button>
                        <button type="button" onclick="submitApplication()" id="btnSubmit"
                                class="btn-submit flex-1 py-4 rounded-xl font-bold text-white flex items-center justify-center order-1 sm:order-2 text-lg"
                                disabled="disabled">
                            <i class="fas fa-check-circle mr-2"></i>
                            Submit Application
                        </button>
                    </div>
                    
                    <p class="text-xs text-center text-slate-400 mt-4">
                        <i class="fas fa-lock mr-1"></i>
                        Your information is encrypted and secure
                    </p>
                </div>
            </div>
        </main>

        <script>
            let declarationAccepted = false;

            document.addEventListener('DOMContentLoaded', function() {
                loadAllData();
            });

            async function loadAllData() {
                const urlParams = new URLSearchParams(window.location.search);
                const tokenFromUrl = urlParams.get('token');
                if (tokenFromUrl) sessionStorage.setItem('resume_token', tokenFromUrl);

                const token = sessionStorage.getItem('resume_token');
                if (!token) {
                    window.location.href = 'apply-now.aspx';
                    return;
                }

                try {
                    const res = await fetch('<%= ResolveUrl("~") %>' + 'admission-draft-api.ashx?action=payload&token=' + encodeURIComponent(token));
                    const data = await res.json();
                    if (!data || !data.ok || !data.payload) {
                        alert('Unable to load application data.');
                        return;
                    }

                    const payload = (typeof data.payload === 'string') ? JSON.parse(data.payload) : data.payload;

                    const draft = payload.draft || {};
                    const student = payload.student || {};
                    const parents = payload.parents || [];
                    const academic = payload.previous_schools || [];
                    const documents = payload.documents || [];

                    document.getElementById('applicationId').textContent = draft.admission_no || sessionStorage.getItem('application_id') || '---';

                    const grade = sessionStorage.getItem('admission_grade');
                    const year = sessionStorage.getItem('admission_year');
                    const dob = sessionStorage.getItem('admission_dob') || student.dob;

                    const gradeNames = {
                        'nursery': 'Nursery', 'lkg': 'LKG', 'ukg': 'UKG',
                        '1': 'Grade 1', '2': 'Grade 2', '3': 'Grade 3',
                        '4': 'Grade 4', '5': 'Grade 5', '6': 'Grade 6',
                        '7': 'Grade 7', '8': 'Grade 8', '9': 'Grade 9',
                        '10': 'Grade 10', '11': 'Grade 11', '12': 'Grade 12'
                    };

                    document.getElementById('gradeYear').textContent = (gradeNames[grade] || grade) + ' | ' + year;

                    const fullName = [student.firstName, student.middleName, student.lastName].filter(Boolean).join(' ');
                    document.getElementById('studentName').textContent = fullName || 'Not provided';
                    document.getElementById('studentGender').textContent = (student.gender || 'Not provided');
                    document.getElementById('studentDob').textContent = formatDate(dob) || 'Not provided';
                    document.getElementById('studentNationality').textContent = student.nationality || 'Not provided';
                    document.getElementById('studentBloodGroup').textContent = student.bloodGroup || 'Not specified';
                    document.getElementById('studentMedical').textContent = student.medicalInfo || 'None specified';

                    const p = parents.length > 0 ? parents[0] : null;
                    document.getElementById('parentName').textContent = p ? (p.fullName || 'Not provided') : 'Not provided';
                    document.getElementById('parentRelation').textContent = p ? (p.parentType || p.relationship || 'Not provided') : 'Not provided';
                    document.getElementById('parentMobile').textContent = p && p.mobile ? '+91 ' + p.mobile : (student.phone ? '+91 ' + student.phone : 'Not provided');
                    document.getElementById('parentEmail').textContent = student.email || 'Not provided';
                    document.getElementById('parentAddress').textContent = student.address || 'Not provided';
                    document.getElementById('contactMethod').textContent = 'WhatsApp';

                    const academicContent = document.getElementById('academicContent');
                    if (academic.length > 0) {
                        const a = academic[0];
                        academicContent.innerHTML = `
                            <div class="grid sm:grid-cols-2 gap-4">
                                <div class="review-item pb-3">
                                    <p class="text-xs text-slate-400 uppercase tracking-wider">Previous School</p>
                                    <p class="font-medium text-slate-800">${a.schoolName || 'Not provided'}</p>
                                </div>
                                <div class="review-item pb-3">
                                    <p class="text-xs text-slate-400 uppercase tracking-wider">Last Grade Completed</p>
                                    <p class="font-medium text-slate-800">${a.previousClass || 'Not provided'}</p>
                                </div>
                            </div>
                        `;
                    } else {
                        academicContent.innerHTML = `
                            <div class="flex items-center space-x-3 text-green-700 bg-green-50 rounded-lg p-4">
                                <i class="fas fa-star text-green-500"></i>
                                <span class="font-medium">No previous schooling recorded</span>
                            </div>
                        `;
                    }

                    const docsContent = document.getElementById('documentsContent');
                    if (documents.length === 0) {
                        docsContent.innerHTML = '<p class="text-slate-500">No documents uploaded</p>';
                    } else {
                        const badges = documents.map(d => {
                            const label = d.documentType || 'Document';
                            return `<span class="document-badge"><i class="fas fa-check-circle mr-1"></i>${label}</span>`;
                        }).join('');
                        docsContent.innerHTML = badges;
                    }
                }
                catch {
                    alert('Unable to reach server.');
                }
            }

            function formatDate(dateStr) {
                if (!dateStr) return null;
                const date = new Date(dateStr);
                return date.toLocaleDateString('en-IN', {
                    day: 'numeric',
                    month: 'long',
                    year: 'numeric'
                });
            }

            function toggleDeclaration() {
                declarationAccepted = !declarationAccepted;

                const checkbox = document.getElementById('declarationCheckbox');
                const checkIcon = document.getElementById('checkIcon');
                const card = document.getElementById('declarationCard');
                const submitBtn = document.getElementById('btnSubmit');

                if (declarationAccepted) {
                    checkbox.classList.add('checked');
                    checkIcon.classList.remove('hidden');
                    card.classList.add('accepted');
                    submitBtn.disabled = false;
                } else {
                    checkbox.classList.remove('checked');
                    checkIcon.classList.add('hidden');
                    card.classList.remove('accepted');
                    submitBtn.disabled = true;
                }
            }

            function goBack() {
                const token = sessionStorage.getItem('resume_token');
                window.location.href = 'application-documents.aspx?token=' + encodeURIComponent(token);
            }

            function submitApplication() {
                if (!declarationAccepted) {
                    alert('Please accept the declaration to submit your application.');
                    return;
                }

                const submitBtn = document.getElementById('btnSubmit');
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Submitting...';

                setTimeout(() => {
                    sessionStorage.setItem('submission_time', new Date().toISOString());
                    window.location.href = 'application-confirmation.aspx';
                }, 1000);
            }
        </script>
    </form>
</body>
</html>

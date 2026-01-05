<%@ Page Language="C#" AutoEventWireup="true" CodeFile="application-student.aspx.cs" Inherits="ApplicationStudent" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Student Details - Step 1 of 5 | Westbrook Academy</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="assets/js/application-validation.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600;700&display=swap');
        
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #f8fafc; min-height: 100vh; }
        .font-playfair { font-family: 'Playfair Display', serif; }
        
        .gradient-primary { background: linear-gradient(135deg, #1e3a5f 0%, #2d5a87 100%); }
        .gradient-accent { background: linear-gradient(135deg, #c9a227 0%, #e8c547 100%); }
        
        /* Progress Bar Styles */
        .progress-bar {
            background: #e2e8f0;
            height: 4px;
            border-radius: 2px;
            overflow: hidden;
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(135deg, #c9a227 0%, #e8c547 100%);
            transition: width 0.5s ease;
        }
        
        .step-dot {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .step-dot.active {
            background: linear-gradient(135deg, #c9a227 0%, #e8c547 100%);
            color: white;
        }
        
        .step-dot.completed {
            background: #22c55e;
            color: white;
        }
        
        .step-dot.pending {
            background: #e2e8f0;
            color: #64748b;
        }
        
        /* Form Styles */
        .form-input {
            transition: all 0.3s ease;
            border: 2px solid #e2e8f0;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #c9a227;
            box-shadow: 0 0 0 4px rgba(201, 162, 39, 0.15);
        }
        
        .form-input.error {
            border-color: #ef4444;
        }
        
        .form-input.locked {
            background: #f1f5f9;
            cursor: not-allowed;
        }
        
        .form-label {
            font-size: 0.875rem;
            font-weight: 600;
            color: #334155;
            margin-bottom: 0.5rem;
            display: block;
        }
        
        .form-label .required {
            color: #ef4444;
            margin-left: 2px;
        }
        
        .error-message {
            color: #ef4444;
            font-size: 0.75rem;
            margin-top: 0.25rem;
            display: none;
        }
        
        .error-message.show {
            display: block;
        }
        
        /* Autosave Indicator */
        .autosave-indicator {
            transition: all 0.3s ease;
        }
        
        .autosave-indicator.saving {
            color: #f59e0b;
        }
        
        .autosave-indicator.saved {
            color: #22c55e;
        }
        
        /* Button Styles */
        .btn-primary {
            background: linear-gradient(135deg, #1e3a5f 0%, #2d5a87 100%);
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px -5px rgba(30, 58, 95, 0.4);
        }
        
        .btn-primary:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        .btn-secondary {
            background: white;
            border: 2px solid #e2e8f0;
            transition: all 0.3s ease;
        }
        
        .btn-secondary:hover {
            border-color: #94a3b8;
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
                        <a href="application-overview.aspx" class="text-slate-400 hover:text-slate-600">
                            <i class="fas fa-arrow-left"></i>
                        </a>
                        <div>
                            <h1 class="font-semibold text-slate-800">Student Details</h1>
                            <p class="text-xs text-slate-500">Step 1 of 5</p>
                        </div>
                    </div>
                    <div class="autosave-indicator text-sm flex items-center" id="autosaveStatus">
                        <i class="fas fa-cloud mr-2"></i>
                        <span>Draft saved</span>
                    </div>
                </div>
                
                <!-- Progress Steps -->
                <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-2">
                        <div class="step-dot active">1</div>
                        <span class="text-xs text-amber-600 font-medium hidden sm:inline">Student</span>
                    </div>
                    <div class="flex-1 mx-2">
                        <div class="progress-bar"><div class="progress-fill" style="width: 0%"></div></div>
                    </div>
                    <div class="flex items-center space-x-2">
                        <div class="step-dot pending">2</div>
                        <span class="text-xs text-slate-400 hidden sm:inline">Parent</span>
                    </div>
                    <div class="flex-1 mx-2">
                        <div class="progress-bar"><div class="progress-fill" style="width: 0%"></div></div>
                    </div>
                    <div class="flex items-center space-x-2">
                        <div class="step-dot pending">3</div>
                        <span class="text-xs text-slate-400 hidden sm:inline">Academic</span>
                    </div>
                    <div class="flex-1 mx-2">
                        <div class="progress-bar"><div class="progress-fill" style="width: 0%"></div></div>
                    </div>
                    <div class="flex items-center space-x-2">
                        <div class="step-dot pending">4</div>
                        <span class="text-xs text-slate-400 hidden sm:inline">Documents</span>
                    </div>
                    <div class="flex-1 mx-2">
                        <div class="progress-bar"><div class="progress-fill" style="width: 0%"></div></div>
                    </div>
                    <div class="flex items-center space-x-2">
                        <div class="step-dot pending">5</div>
                        <span class="text-xs text-slate-400 hidden sm:inline">Review</span>
                    </div>
                </div>
            </div>
        </header>

        <main class="max-w-2xl mx-auto px-4 py-8">
            <!-- Application Info Bar -->
            <div class="bg-blue-50 border border-blue-200 rounded-xl p-4 mb-8 flex items-center justify-between">
                <div class="flex items-center space-x-3">
                    <div class="w-10 h-10 bg-blue-500 rounded-lg flex items-center justify-center">
                        <i class="fas fa-file-alt text-white"></i>
                    </div>
                    <div>
                        <p class="text-xs text-blue-600">Application ID</p>
                        <p class="font-mono font-bold text-blue-800" id="applicationIdDisplay">WA-XXXXXX</p>
                    </div>
                </div>
                <div class="text-right">
                    <p class="text-xs text-blue-600">Applying for</p>
                    <p class="font-semibold text-blue-800" id="gradeYearDisplay">Grade 1 | 2025-26</p>
                </div>
            </div>

            <!-- Form Card -->
            <div class="bg-white rounded-2xl shadow-lg p-6 md:p-8">
                <div class="mb-8">
                    <h2 class="font-playfair text-2xl font-bold text-slate-800 mb-2">
                        Tell us about your child
                    </h2>
                    <p class="text-slate-500">Please enter the student's details as they appear on official documents.</p>
                </div>

                <div class="space-y-6">
                    <!-- First Name -->
                    <div>
                        <label class="form-label">
                            First Name <span class="required">*</span>
                        </label>
                        <input type="text" id="txtFirstName" runat="server" 
                               class="form-input w-full px-4 py-3 rounded-xl"
                               placeholder="Enter first name"
                               oninput="validateField(this, 'firstName'); triggerAutosave();" />
                        <p class="error-message" id="firstNameError">Please enter the first name</p>
                    </div>

                    <!-- Middle Name -->
                    <div>
                        <label class="form-label">
                            Middle Name <span class="text-slate-400 text-xs font-normal">(Optional)</span>
                        </label>
                        <input type="text" id="txtMiddleName" runat="server" 
                               class="form-input w-full px-4 py-3 rounded-xl"
                               placeholder="Enter middle name if any"
                               oninput="triggerAutosave();" />
                    </div>

                    <!-- Last Name -->
                    <div>
                        <label class="form-label">
                            Last Name <span class="required">*</span>
                        </label>
                        <input type="text" id="txtLastName" runat="server" 
                               class="form-input w-full px-4 py-3 rounded-xl"
                               placeholder="Enter last name / surname"
                               oninput="validateField(this, 'lastName'); triggerAutosave();" />
                        <p class="error-message" id="lastNameError">Please enter the last name</p>
                    </div>

                    <!-- Gender -->
                    <div>
                        <label class="form-label">
                            Gender <span class="required">*</span>
                        </label>
                        <div class="grid grid-cols-3 gap-3">
                            <label class="cursor-pointer">
                                <input type="radio" name="gender" value="male" class="hidden peer" onchange="triggerAutosave();" />
                                <div class="peer-checked:border-amber-500 peer-checked:bg-amber-50 border-2 border-slate-200 rounded-xl p-4 text-center transition-all hover:border-slate-300">
                                    <i class="fas fa-male text-2xl text-blue-500 mb-2"></i>
                                    <p class="text-sm font-medium text-slate-700">Male</p>
                                </div>
                            </label>
                            <label class="cursor-pointer">
                                <input type="radio" name="gender" value="female" class="hidden peer" onchange="triggerAutosave();" />
                                <div class="peer-checked:border-amber-500 peer-checked:bg-amber-50 border-2 border-slate-200 rounded-xl p-4 text-center transition-all hover:border-slate-300">
                                    <i class="fas fa-female text-2xl text-pink-500 mb-2"></i>
                                    <p class="text-sm font-medium text-slate-700">Female</p>
                                </div>
                            </label>
                            <label class="cursor-pointer">
                                <input type="radio" name="gender" value="other" class="hidden peer" onchange="triggerAutosave();" />
                                <div class="peer-checked:border-amber-500 peer-checked:bg-amber-50 border-2 border-slate-200 rounded-xl p-4 text-center transition-all hover:border-slate-300">
                                    <i class="fas fa-genderless text-2xl text-purple-500 mb-2"></i>
                                    <p class="text-sm font-medium text-slate-700">Other</p>
                                </div>
                            </label>
                        </div>
                        <p class="error-message" id="genderError">Please select gender</p>
                    </div>

                    <!-- Date of Birth (Pre-filled & Locked) -->
                    <div>
                        <label class="form-label">
                            Date of Birth
                            <span class="text-xs font-normal text-slate-400 ml-2">
                                <i class="fas fa-lock text-xs"></i> From eligibility check
                            </span>
                        </label>
                        <input type="date" id="txtDob" runat="server" 
                               class="form-input locked w-full px-4 py-3 rounded-xl"
                               readonly="readonly" />
                        <p class="text-xs text-slate-400 mt-1">
                            Need to change? <a href="apply-now.aspx" class="text-blue-600 hover:underline">Start over</a>
                        </p>
                    </div>

                    <!-- Grade Applying For (Locked) -->
                    <div>
                        <label class="form-label">
                            Grade Applying For
                            <span class="text-xs font-normal text-slate-400 ml-2">
                                <i class="fas fa-lock text-xs"></i> From eligibility check
                            </span>
                        </label>
                        <input type="text" id="txtGrade" 
                               class="form-input locked w-full px-4 py-3 rounded-xl"
                               readonly="readonly" />
                    </div>

                    <!-- Academic Year (Locked) -->
                    <div>
                        <label class="form-label">
                            Academic Year
                            <span class="text-xs font-normal text-slate-400 ml-2">
                                <i class="fas fa-lock text-xs"></i> From eligibility check
                            </span>
                        </label>
                        <input type="text" id="txtAcademicYear" 
                               class="form-input locked w-full px-4 py-3 rounded-xl"
                               readonly="readonly" />
                    </div>

                    <!-- Nationality -->
                    <div>
                        <label class="form-label">
                            Nationality <span class="required">*</span>
                        </label>
                        <div class="relative">
                            <select id="ddlNationality" runat="server" 
                                    class="form-input w-full px-4 py-3 rounded-xl appearance-none cursor-pointer"
                                    onchange="triggerAutosave();">
                                <option value="">Select nationality</option>
                                <option value="Indian" selected="selected">Indian</option>
                                <option value="Other">Other</option>
                            </select>
                            <div class="absolute right-4 top-1/2 -translate-y-1/2 pointer-events-none">
                                <i class="fas fa-chevron-down text-slate-400"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Blood Group (Optional) -->
                    <div>
                        <label class="form-label">
                            Blood Group <span class="text-slate-400 text-xs font-normal">(Optional - for medical records)</span>
                        </label>
                        <div class="relative">
                            <select id="ddlBloodGroup" runat="server" 
                                    class="form-input w-full px-4 py-3 rounded-xl appearance-none cursor-pointer"
                                    onchange="triggerAutosave();">
                                <option value="">Select if known</option>
                                <option value="A+">A+</option>
                                <option value="A-">A-</option>
                                <option value="B+">B+</option>
                                <option value="B-">B-</option>
                                <option value="AB+">AB+</option>
                                <option value="AB-">AB-</option>
                                <option value="O+">O+</option>
                                <option value="O-">O-</option>
                            </select>
                            <div class="absolute right-4 top-1/2 -translate-y-1/2 pointer-events-none">
                                <i class="fas fa-chevron-down text-slate-400"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Any Medical Conditions (Optional) -->
                    <div>
                        <label class="form-label">
                            Medical Conditions / Allergies
                            <span class="text-slate-400 text-xs font-normal">(Optional - helps us care for your child)</span>
                        </label>
                        <textarea id="txtMedicalInfo" runat="server" 
                                  class="form-input w-full px-4 py-3 rounded-xl resize-none"
                                  rows="3"
                                  placeholder="E.g., Peanut allergy, Asthma, None"
                                  oninput="triggerAutosave();"></textarea>
                        <p class="text-xs text-slate-400 mt-1">
                            This information is kept confidential and shared only with school medical staff.
                        </p>
                    </div>
                </div>

                <!-- Navigation Buttons -->
                <div class="mt-10 pt-6 border-t border-slate-100">
                    <div class="flex flex-col sm:flex-row gap-3">
                        <button type="button" onclick="saveDraft()" 
                                class="btn-secondary flex-1 py-3 rounded-xl font-medium text-slate-600 flex items-center justify-center order-2 sm:order-1">
                            <i class="fas fa-save mr-2"></i>
                            Save Draft
                        </button>
                        <button type="button" onclick="proceedToNext()" id="btnNext"
                                class="btn-primary flex-1 py-3 rounded-xl font-semibold text-white flex items-center justify-center order-1 sm:order-2">
                            Continue to Parent Details
                            <i class="fas fa-arrow-right ml-2"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Help Section -->
            <div class="mt-8 text-center">
                <p class="text-sm text-slate-500">
                    <i class="fas fa-question-circle mr-1"></i>
                    Need help? Contact admissions at 
                    <a href="tel:+911234567890" class="text-blue-600 font-medium">+91 12345 67890</a>
                </p>
            </div>
        </main>

        <script>
            let autosaveTimeout;

            document.addEventListener('DOMContentLoaded', async function() {
                const urlParams = new URLSearchParams(window.location.search);
                const tokenFromUrl = urlParams.get('token');
                if (tokenFromUrl) sessionStorage.setItem('resume_token', tokenFromUrl);

                const token = sessionStorage.getItem('resume_token');
                const grade = sessionStorage.getItem('admission_grade');
                const dob = sessionStorage.getItem('admission_dob');
                const year = sessionStorage.getItem('admission_year');

                if (!token || !grade || !dob) {
                    window.location.href = 'apply-now.aspx';
                    return;
                }

                document.getElementById('<%= txtDob.ClientID %>').value = dob;

                const gradeNames = {
                    'nursery': 'Nursery', 'lkg': 'LKG', 'ukg': 'UKG',
                    '1': 'Grade 1', '2': 'Grade 2', '3': 'Grade 3',
                    '4': 'Grade 4', '5': 'Grade 5', '6': 'Grade 6',
                    '7': 'Grade 7', '8': 'Grade 8', '9': 'Grade 9',
                    '10': 'Grade 10', '11': 'Grade 11', '12': 'Grade 12'
                };

                document.getElementById('txtGrade').value = gradeNames[grade] || grade;
                document.getElementById('txtAcademicYear').value = year;

                try {
                    const res = await fetch('<%= ResolveUrl("~") %>' + 'admission-draft-api.ashx?action=payload&token=' + encodeURIComponent(token));
                    const data = await res.json();
                    if (data && data.ok && data.payload) {
                        const payload = (typeof data.payload === 'string') ? JSON.parse(data.payload) : data.payload;
                        if (payload && payload.draft && payload.draft.admission_no) {
                            document.getElementById('applicationIdDisplay').textContent = payload.draft.admission_no;
                            sessionStorage.setItem('application_id', payload.draft.admission_no);
                        }
                        if (payload && payload.student) {
                            document.getElementById('<%= txtFirstName.ClientID %>').value = payload.student.firstName || '';
                            document.getElementById('<%= txtMiddleName.ClientID %>').value = payload.student.middleName || '';
                            document.getElementById('<%= txtLastName.ClientID %>').value = payload.student.lastName || '';
                            document.getElementById('<%= ddlNationality.ClientID %>').value = payload.student.nationality || 'Indian';
                            document.getElementById('<%= ddlBloodGroup.ClientID %>').value = payload.student.bloodGroup || '';
                            document.getElementById('<%= txtMedicalInfo.ClientID %>').value = payload.student.medicalInfo || '';

                            if (payload.student.gender) {
                                const g = payload.student.gender.toLowerCase();
                                const genderRadio = document.querySelector(`input[name="gender"][value="${g}"]`);
                                if (genderRadio) genderRadio.checked = true;
                            }
                        }
                    }
                } catch { }

                const appId = sessionStorage.getItem('application_id');
                document.getElementById('applicationIdDisplay').textContent = appId || '...';
                document.getElementById('gradeYearDisplay').textContent = (gradeNames[grade] || grade) + ' | ' + year;
            });

            // Override the stub with the full UI indicator behavior (existing logic)
            window._triggerAutosaveImpl = function () {
                clearTimeout(autosaveTimeout);

                const indicator = document.getElementById('autosaveStatus');
                if (indicator) {
                    indicator.className = 'autosave-indicator text-sm flex items-center saving';
                    indicator.innerHTML = '<i class="fas fa-sync fa-spin mr-2"></i><span>Saving...</span>';
                }

                autosaveTimeout = setTimeout(async () => {
                    try {
                        const r = await saveDraftToBackend();
                        if (indicator) {
                            if (r && r.ok) {
                                indicator.className = 'autosave-indicator text-sm flex items-center saved';
                                indicator.innerHTML = '<i class="fas fa-check-circle mr-2"></i><span>Draft saved</span>';
                            } else {
                                indicator.className = 'autosave-indicator text-sm flex items-center saving';
                                indicator.innerHTML = '<i class="fas fa-exclamation-triangle mr-2"></i><span>Not saved</span>';
                            }
                        }
                    } catch {
                        if (indicator) {
                            indicator.className = 'autosave-indicator text-sm flex items-center saving';
                            indicator.innerHTML = '<i class="fas fa-exclamation-triangle mr-2"></i><span>Not saved</span>';
                        }
                    }
                }, 1000);
            };

            async function saveDraftToBackend() {
                const token = sessionStorage.getItem('resume_token');
                if (!token) return { ok: false, message: 'Missing token' };

                console.log('resume_token:', token);

                // Trace: verify token resolves to a draft before saving student
                try {
                    const probeRes = await fetch('<%= ResolveUrl("~") %>' + 'admission-draft-api.ashx?action=payload&token=' + encodeURIComponent(token));
                    const probe = await probeRes.json();
                    console.log('payload probe response:', probe);
                } catch (e) {
                    console.warn('payload probe failed', e);
                }

                const gender = document.querySelector('input[name="gender"]:checked')?.value || '';

                const payload = {
                    resume_token: token,
                    student: {
                        firstName: document.getElementById('<%= txtFirstName.ClientID %>').value,
                        middleName: document.getElementById('<%= txtMiddleName.ClientID %>').value,
                        lastName: document.getElementById('<%= txtLastName.ClientID %>').value,
                        dob: document.getElementById('<%= txtDob.ClientID %>').value,
                        gender: gender,
                        nationality: document.getElementById('<%= ddlNationality.ClientID %>').value,
                        bloodGroup: document.getElementById('<%= ddlBloodGroup.ClientID %>').value,
                        medicalInfo: document.getElementById('<%= txtMedicalInfo.ClientID %>').value
                    }
                };

                console.log('saveStudent request payload:', payload);

                const res = await fetch('<%= ResolveUrl("~") %>' + 'admission-draft-step.ashx?action=saveStudent', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                });

                const raw = await res.json();
                console.log('saveStudent raw response:', raw);

                if (!raw) {
                    return { ok: false, message: 'No response from server.' };
                }

                if (raw.ok !== true) {
                    return { ok: false, message: raw.message ? raw.message : 'Save failed.' };
                }

                return { ok: true, obj: raw.obj };
            }

            async function saveDraft() {
                try {
                    const r = await saveDraftToBackend();
                    if (r && r.ok) {
                        alert('Saved.');
                    } else {
                        alert(r && r.message ? r.message : 'Save failed.');
                    }
                } catch (e) {
                    console.error('saveDraft error', e);
                    alert('Unable to reach server.');
                }
            }

            async function proceedToNext() {
                let isValid = true;

                const firstName = document.getElementById('<%= txtFirstName.ClientID %>');
                const lastName = document.getElementById('<%= txtLastName.ClientID %>');
                const gender = document.querySelector('input[name="gender"]:checked');

                if (!validateField(firstName, 'firstName')) isValid = false;
                if (!validateField(lastName, 'lastName')) isValid = false;

                if (!gender) {
                    document.getElementById('genderError').classList.add('show');
                    isValid = false;
                } else {
                    document.getElementById('genderError').classList.remove('show');
                }

                if (!isValid) {
                    document.querySelector('.error, .error-message.show')?.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    return;
                }

                try {
                    const r = await saveDraftToBackend();
                    if (r && r.ok) {
                        const token = sessionStorage.getItem('resume_token');
                        window.location.href = 'application-parent.aspx?token=' + encodeURIComponent(token);
                    } else {
                        alert(r && r.message ? r.message : 'Save failed.');
                    }
                } catch (e) {
                    console.error('proceedToNext error', e);
                    alert('Unable to reach server.');
                }
            }
        </script>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeFile="application-academic.aspx.cs" Inherits="ApplicationAcademic" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Academic History - Step 3 of 5 | Westbrook Academy</title>
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
        
        .form-input { transition: all 0.3s ease; border: 2px solid #e2e8f0; }
        .form-input:focus { outline: none; border-color: #c9a227; box-shadow: 0 0 0 4px rgba(201, 162, 39, 0.15); }
        .form-input.error { border-color: #ef4444; }
        
        .form-label { font-size: 0.875rem; font-weight: 600; color: #334155; margin-bottom: 0.5rem; display: block; }
        .form-label .required { color: #ef4444; margin-left: 2px; }
        
        .error-message { color: #ef4444; font-size: 0.75rem; margin-top: 0.25rem; display: none; }
        .error-message.show { display: block; }
        
        .autosave-indicator { transition: all 0.3s ease; }
        .autosave-indicator.saving { color: #f59e0b; }
        .autosave-indicator.saved { color: #22c55e; }
        
        .btn-primary { background: linear-gradient(135deg, #1e3a5f 0%, #2d5a87 100%); transition: all 0.3s ease; }
        .btn-primary:hover:not(:disabled) { transform: translateY(-2px); box-shadow: 0 10px 25px -5px rgba(30, 58, 95, 0.4); }
        
        .btn-secondary { background: white; border: 2px solid #e2e8f0; transition: all 0.3s ease; }
        .btn-secondary:hover { border-color: #94a3b8; }
        
        .new-student-card {
            background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
            border: 2px solid #93c5fd;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .new-student-card:hover, .new-student-card.selected {
            border-color: #3b82f6;
            box-shadow: 0 4px 15px rgba(59, 130, 246, 0.2);
        }
        
        .transfer-card {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            border: 2px solid #fcd34d;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .transfer-card:hover, .transfer-card.selected {
            border-color: #f59e0b;
            box-shadow: 0 4px 15px rgba(245, 158, 11, 0.2);
        }
        
        .optional-section {
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            border-radius: 1rem;
            padding: 1.5rem;
        }
        
        .skip-section {
            background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%);
            border: 1px solid #86efac;
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
                        <a href="application-parent.aspx" class="text-slate-400 hover:text-slate-600">
                            <i class="fas fa-arrow-left"></i>
                        </a>
                        <div>
                            <h1 class="font-semibold text-slate-800">Academic History</h1>
                            <p class="text-xs text-slate-500">Step 3 of 5</p>
                        </div>
                    </div>
                    <div class="autosave-indicator text-sm flex items-center saved" id="autosaveStatus">
                        <i class="fas fa-check-circle mr-2"></i>
                        <span>Draft saved</span>
                    </div>
                </div>
                
                <!-- Progress Steps -->
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
                        <div class="step-dot active">3</div>
                        <span class="text-xs text-amber-600 font-medium hidden sm:inline">Academic</span>
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
            <!-- Form Card -->
            <div class="bg-white rounded-2xl shadow-lg p-6 md:p-8">
                <div class="mb-8">
                    <h2 class="font-playfair text-2xl font-bold text-slate-800 mb-2">
                        Previous Education
                    </h2>
                    <p class="text-slate-500">Help us understand your child's academic background.</p>
                </div>

                <div class="space-y-6">
                    <!-- Student Type Selection -->
                    <div>
                        <label class="form-label mb-4">
                            Is your child currently enrolled in another school? <span class="required">*</span>
                        </label>
                        <div class="grid sm:grid-cols-2 gap-4">
                            <div class="new-student-card rounded-xl p-5" onclick="selectStudentType('new')">
                                <div class="flex items-start space-x-4">
                                    <div class="w-12 h-12 bg-blue-500 rounded-xl flex items-center justify-center flex-shrink-0">
                                        <i class="fas fa-star text-white text-lg"></i>
                                    </div>
                                    <div>
                                        <h4 class="font-semibold text-blue-900">First-time Student</h4>
                                        <p class="text-sm text-blue-700 mt-1">
                                            Starting formal schooling for the first time
                                        </p>
                                    </div>
                                    <input type="radio" name="studentType" value="new" class="hidden" />
                                </div>
                            </div>
                            
                            <div class="transfer-card rounded-xl p-5" onclick="selectStudentType('transfer')">
                                <div class="flex items-start space-x-4">
                                    <div class="w-12 h-12 bg-amber-500 rounded-xl flex items-center justify-center flex-shrink-0">
                                        <i class="fas fa-exchange-alt text-white text-lg"></i>
                                    </div>
                                    <div>
                                        <h4 class="font-semibold text-amber-900">Transferring</h4>
                                        <p class="text-sm text-amber-700 mt-1">
                                            Currently enrolled in or attended another school
                                        </p>
                                    </div>
                                    <input type="radio" name="studentType" value="transfer" class="hidden" />
                                </div>
                            </div>
                        </div>
                        <p class="error-message" id="studentTypeError">Please select an option</p>
                    </div>

                    <!-- Transfer Student Details (shown conditionally) -->
                    <div id="transferDetails" class="space-y-6 hidden">
                        <!-- Previous School Name -->
                        <div>
                            <label class="form-label">
                                Previous/Current School Name <span class="required">*</span>
                            </label>
                            <input type="text" id="txtPrevSchool" runat="server" 
                                   class="form-input w-full px-4 py-3 rounded-xl"
                                   placeholder="Enter school name"
                                   oninput="validateField(this, 'prevSchool'); triggerAutosave();" />
                            <p class="error-message" id="prevSchoolError">Please enter the school name</p>
                        </div>

                        <!-- School Location -->
                        <div>
                            <label class="form-label">
                                School Location (City) <span class="required">*</span>
                            </label>
                            <input type="text" id="txtSchoolCity" runat="server" 
                                   class="form-input w-full px-4 py-3 rounded-xl"
                                   placeholder="City where school is located"
                                   oninput="validateField(this, 'schoolCity'); triggerAutosave();" />
                            <p class="error-message" id="schoolCityError">Please enter the city</p>
                        </div>

                        <!-- Board -->
                        <div>
                            <label class="form-label">
                                Board / Affiliation <span class="required">*</span>
                            </label>
                            <div class="relative">
                                <select id="ddlBoard" runat="server" 
                                        class="form-input w-full px-4 py-3 rounded-xl appearance-none cursor-pointer"
                                        onchange="triggerAutosave();">
                                    <option value="">Select board</option>
                                    <option value="CBSE">CBSE</option>
                                    <option value="ICSE">ICSE / ISC</option>
                                    <option value="State">State Board</option>
                                    <option value="IB">IB (International Baccalaureate)</option>
                                    <option value="Cambridge">Cambridge (IGCSE)</option>
                                    <option value="Other">Other</option>
                                </select>
                                <div class="absolute right-4 top-1/2 -translate-y-1/2 pointer-events-none">
                                    <i class="fas fa-chevron-down text-slate-400"></i>
                                </div>
                            </div>
                            <p class="error-message" id="boardError">Please select a board</p>
                        </div>

                        <!-- Last Grade Completed -->
                        <div>
                            <label class="form-label">
                                Last Grade/Class Completed <span class="required">*</span>
                            </label>
                            <div class="relative">
                                <select id="ddlLastGrade" runat="server" 
                                        class="form-input w-full px-4 py-3 rounded-xl appearance-none cursor-pointer"
                                        onchange="triggerAutosave();">
                                    <option value="">Select grade</option>
                                    <option value="Nursery">Nursery / Playgroup</option>
                                    <option value="LKG">LKG</option>
                                    <option value="UKG">UKG</option>
                                    <option value="1">Grade 1</option>
                                    <option value="2">Grade 2</option>
                                    <option value="3">Grade 3</option>
                                    <option value="4">Grade 4</option>
                                    <option value="5">Grade 5</option>
                                    <option value="6">Grade 6</option>
                                    <option value="7">Grade 7</option>
                                    <option value="8">Grade 8</option>
                                    <option value="9">Grade 9</option>
                                    <option value="10">Grade 10</option>
                                    <option value="11">Grade 11</option>
                                </select>
                                <div class="absolute right-4 top-1/2 -translate-y-1/2 pointer-events-none">
                                    <i class="fas fa-chevron-down text-slate-400"></i>
                                </div>
                            </div>
                            <p class="error-message" id="lastGradeError">Please select the last grade</p>
                        </div>

                        <!-- Reason for Transfer (Optional) -->
                        <div class="optional-section">
                            <label class="form-label flex items-center">
                                <span>Reason for Transfer</span>
                                <span class="ml-2 text-xs font-normal text-slate-400 bg-slate-200 px-2 py-0.5 rounded">Optional</span>
                            </label>
                            <div class="grid grid-cols-2 sm:grid-cols-3 gap-2 mt-3">
                                <label class="cursor-pointer">
                                    <input type="radio" name="transferReason" value="relocation" class="hidden peer" onchange="triggerAutosave();" />
                                    <div class="peer-checked:border-amber-500 peer-checked:bg-amber-50 border-2 border-slate-200 rounded-lg p-3 text-center text-sm transition-all hover:border-slate-300">
                                        <i class="fas fa-home text-slate-400 mb-1"></i>
                                        <p class="text-slate-700">Relocation</p>
                                    </div>
                                </label>
                                <label class="cursor-pointer">
                                    <input type="radio" name="transferReason" value="better-education" class="hidden peer" onchange="triggerAutosave();" />
                                    <div class="peer-checked:border-amber-500 peer-checked:bg-amber-50 border-2 border-slate-200 rounded-lg p-3 text-center text-sm transition-all hover:border-slate-300">
                                        <i class="fas fa-graduation-cap text-slate-400 mb-1"></i>
                                        <p class="text-slate-700">Better Education</p>
                                    </div>
                                </label>
                                <label class="cursor-pointer">
                                    <input type="radio" name="transferReason" value="closer-home" class="hidden peer" onchange="triggerAutosave();" />
                                    <div class="peer-checked:border-amber-500 peer-checked:bg-amber-50 border-2 border-slate-200 rounded-lg p-3 text-center text-sm transition-all hover:border-slate-300">
                                        <i class="fas fa-map-marker-alt text-slate-400 mb-1"></i>
                                        <p class="text-slate-700">Closer to Home</p>
                                    </div>
                                </label>
                                <label class="cursor-pointer">
                                    <input type="radio" name="transferReason" value="facilities" class="hidden peer" onchange="triggerAutosave();" />
                                    <div class="peer-checked:border-amber-500 peer-checked:bg-amber-50 border-2 border-slate-200 rounded-lg p-3 text-center text-sm transition-all hover:border-slate-300">
                                        <i class="fas fa-building text-slate-400 mb-1"></i>
                                        <p class="text-slate-700">Better Facilities</p>
                                    </div>
                                </label>
                                <label class="cursor-pointer">
                                    <input type="radio" name="transferReason" value="recommendation" class="hidden peer" onchange="triggerAutosave();" />
                                    <div class="peer-checked:border-amber-500 peer-checked:bg-amber-50 border-2 border-slate-200 rounded-lg p-3 text-center text-sm transition-all hover:border-slate-300">
                                        <i class="fas fa-thumbs-up text-slate-400 mb-1"></i>
                                        <p class="text-slate-700">Recommendation</p>
                                    </div>
                                </label>
                                <label class="cursor-pointer">
                                    <input type="radio" name="transferReason" value="other" class="hidden peer" onchange="triggerAutosave();" />
                                    <div class="peer-checked:border-amber-500 peer-checked:bg-amber-50 border-2 border-slate-200 rounded-lg p-3 text-center text-sm transition-all hover:border-slate-300">
                                        <i class="fas fa-ellipsis-h text-slate-400 mb-1"></i>
                                        <p class="text-slate-700">Other</p>
                                    </div>
                                </label>
                            </div>
                            <p class="text-xs text-slate-400 mt-3">
                                <i class="fas fa-info-circle mr-1"></i>
                                This helps us understand your expectations better.
                            </p>
                        </div>
                    </div>

                    <!-- New Student Message -->
                    <div id="newStudentMessage" class="skip-section rounded-xl p-6 hidden">
                        <div class="flex items-start space-x-4">
                            <div class="w-12 h-12 bg-green-500 rounded-xl flex items-center justify-center flex-shrink-0">
                                <i class="fas fa-rocket text-white text-lg"></i>
                            </div>
                            <div>
                                <h4 class="font-semibold text-green-800">Great!</h4>
                                <p class="text-green-700 mt-1">
                                    Since this is your child's first school, we don't need any previous academic records. 
                                    You can proceed to the next step.
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- How did you hear about us (Optional) -->
                    <div class="optional-section" id="referralSection">
                        <label class="form-label flex items-center">
                            <span>How did you hear about Westbrook Academy?</span>
                            <span class="ml-2 text-xs font-normal text-slate-400 bg-slate-200 px-2 py-0.5 rounded">Optional</span>
                        </label>
                        <div class="relative mt-3">
                            <select id="ddlReferral" runat="server" 
                                    class="form-input w-full px-4 py-3 rounded-xl appearance-none cursor-pointer"
                                    onchange="triggerAutosave();">
                                <option value="">Select an option</option>
                                <option value="friend-family">Friend or Family</option>
                                <option value="current-parent">Current Westbrook Parent</option>
                                <option value="online-search">Online Search (Google)</option>
                                <option value="social-media">Social Media</option>
                                <option value="newspaper">Newspaper / Magazine</option>
                                <option value="event">School Event / Fair</option>
                                <option value="other">Other</option>
                            </select>
                            <div class="absolute right-4 top-1/2 -translate-y-1/2 pointer-events-none">
                                <i class="fas fa-chevron-down text-slate-400"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Navigation Buttons -->
                <div class="mt-10 pt-6 border-t border-slate-100">
                    <div class="flex flex-col sm:flex-row gap-3">
                        <button type="button" onclick="goBack()" 
                                class="btn-secondary flex-1 py-3 rounded-xl font-medium text-slate-600 flex items-center justify-center order-2 sm:order-1">
                            <i class="fas fa-arrow-left mr-2"></i>
                            Back
                        </button>
                        <button type="button" onclick="proceedToNext()" id="btnNext"
                                class="btn-primary flex-1 py-3 rounded-xl font-semibold text-white flex items-center justify-center order-1 sm:order-2">
                            Continue to Documents
                            <i class="fas fa-arrow-right ml-2"></i>
                        </button>
                    </div>
                </div>
            </div>
        </main>

        <script>
            let autosaveTimeout;
            let selectedStudentType = '';

            document.addEventListener('DOMContentLoaded', async function() {
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
                    if (data && data.ok && data.payload) {
                        const payload = (typeof data.payload === 'string') ? JSON.parse(data.payload) : data.payload;
                        if (payload && payload.previous_schools && payload.previous_schools.length > 0) {
                            selectStudentType('transfer');
                            const ps = payload.previous_schools[0];
                            document.getElementById('<%= txtPrevSchool.ClientID %>').value = ps.schoolName || '';
                            document.getElementById('<%= ddlLastGrade.ClientID %>').value = ps.previousClass || '';
                        }
                    }
                } catch { }
            });

            function selectStudentType(type) {
                selectedStudentType = type;

                document.querySelectorAll('.new-student-card, .transfer-card').forEach(card => {
                    card.classList.remove('selected');
                });

                if (type === 'new') {
                    document.querySelector('.new-student-card').classList.add('selected');
                    document.getElementById('transferDetails').classList.add('hidden');
                    document.getElementById('newStudentMessage').classList.remove('hidden');
                } else {
                    document.querySelector('.transfer-card').classList.add('selected');
                    document.getElementById('transferDetails').classList.remove('hidden');
                    document.getElementById('newStudentMessage').classList.add('hidden');
                }

                document.getElementById('studentTypeError').classList.remove('show');
                triggerAutosave();
            }

            async function saveAcademicToBackend() {
                const token = sessionStorage.getItem('resume_token');
                const payload = {
                    resume_token: token,
                    student_type: selectedStudentType,
                    previous_school: {
                        schoolName: document.getElementById('<%= txtPrevSchool.ClientID %>').value,
                        previousClass: document.getElementById('<%= ddlLastGrade.ClientID %>').value,
                        tcNumber: ''
                    }
                };

                const res = await fetch('<%= ResolveUrl("~") %>' + 'admission-draft-step.ashx?action=saveAcademic', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                });
                return await res.json();
            }

            function triggerAutosave() {
                clearTimeout(autosaveTimeout);

                const indicator = document.getElementById('autosaveStatus');
                indicator.className = 'autosave-indicator text-sm flex items-center saving';
                indicator.innerHTML = '<i class="fas fa-sync fa-spin mr-2"></i><span>Saving...</span>';

                autosaveTimeout = setTimeout(async () => {
                    try {
                        const r = await saveAcademicToBackend();
                        indicator.className = 'autosave-indicator text-sm flex items-center ' + ((r && r.ok) ? 'saved' : 'saving');
                        indicator.innerHTML = (r && r.ok)
                            ? '<i class="fas fa-check-circle mr-2"></i><span>Draft saved</span>'
                            : '<i class="fas fa-exclamation-triangle mr-2"></i><span>Not saved</span>';
                    } catch {
                        indicator.className = 'autosave-indicator text-sm flex items-center saving';
                        indicator.innerHTML = '<i class="fas fa-exclamation-triangle mr-2"></i><span>Not saved</span>';
                    }
                }, 1000);
            }

            function goBack() {
                const token = sessionStorage.getItem('resume_token');
                window.location.href = 'application-parent.aspx?token=' + encodeURIComponent(token);
            }

            async function proceedToNext() {
                let isValid = true;

                if (!selectedStudentType) {
                    document.getElementById('studentTypeError').classList.add('show');
                    isValid = false;
                }

                if (selectedStudentType === 'transfer') {
                    const prevSchool = document.getElementById('<%= txtPrevSchool.ClientID %>');
                    const schoolCity = document.getElementById('<%= txtSchoolCity.ClientID %>');
                    const board = document.getElementById('<%= ddlBoard.ClientID %>');
                    const lastGrade = document.getElementById('<%= ddlLastGrade.ClientID %>');

                    if (!validateField(prevSchool, 'prevSchool')) isValid = false;
                    if (!validateField(schoolCity, 'schoolCity')) isValid = false;

                    if (!board.value) {
                        document.getElementById('boardError').classList.add('show');
                        isValid = false;
                    } else {
                        document.getElementById('boardError').classList.remove('show');
                    }

                    if (!lastGrade.value) {
                        document.getElementById('lastGradeError').classList.add('show');
                        isValid = false;
                    } else {
                        document.getElementById('lastGradeError').classList.remove('show');
                    }
                }

                if (!isValid) {
                    document.querySelector('.error, .error-message.show')?.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    return;
                }

                try {
                    const r = await saveAcademicToBackend();
                    if (r && r.ok) {
                        const token = sessionStorage.getItem('resume_token');
                        window.location.href = 'application-documents.aspx?token=' + encodeURIComponent(token);
                    } else {
                        alert(r && r.message ? r.message : 'Save failed.');
                    }
                } catch {
                    alert('Unable to reach server.');
                }
            }
        </script>
    </form>
</body>
</html>

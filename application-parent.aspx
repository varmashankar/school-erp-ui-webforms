<%@ Page Language="C#" AutoEventWireup="true" CodeFile="application-parent.aspx.cs" Inherits="ApplicationParent" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Parent Details - Step 2 of 5 | Westbrook Academy</title>
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
        
        .contact-method-card {
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .contact-method-card:hover {
            border-color: #c9a227;
        }
        
        .contact-method-card.selected {
            border-color: #c9a227;
            background: #fffbeb;
        }
        
        .trust-notice {
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
                        <a href="application-student.aspx" class="text-slate-400 hover:text-slate-600">
                            <i class="fas fa-arrow-left"></i>
                        </a>
                        <div>
                            <h1 class="font-semibold text-slate-800">Parent/Guardian Details</h1>
                            <p class="text-xs text-slate-500">Step 2 of 5</p>
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
                        <div class="step-dot active">2</div>
                        <span class="text-xs text-amber-600 font-medium hidden sm:inline">Parent</span>
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
            <!-- Student Name Display -->
            <div class="bg-slate-100 rounded-xl p-4 mb-8 flex items-center space-x-4">
                <div class="w-12 h-12 bg-blue-500 rounded-full flex items-center justify-center text-white font-bold text-lg" id="studentInitials">
                    --
                </div>
                <div>
                    <p class="text-xs text-slate-500">Applying for</p>
                    <p class="font-semibold text-slate-800" id="studentNameDisplay">Student Name</p>
                </div>
            </div>

            <!-- Form Card -->
            <div class="bg-white rounded-2xl shadow-lg p-6 md:p-8">
                <div class="mb-8">
                    <h2 class="font-playfair text-2xl font-bold text-slate-800 mb-2">
                        Your Contact Information
                    </h2>
                    <p class="text-slate-500">We'll use this to keep you updated on the application status.</p>
                </div>

                <div class="space-y-6">
                    <!-- Relationship to Student -->
                    <div>
                        <label class="form-label">
                            Relationship to Student <span class="required">*</span>
                        </label>
                        <div class="grid grid-cols-2 sm:grid-cols-4 gap-3">
                            <label class="cursor-pointer">
                                <input type="radio" name="relationship" value="father" class="hidden peer" onchange="triggerAutosave();" />
                                <div class="peer-checked:border-amber-500 peer-checked:bg-amber-50 border-2 border-slate-200 rounded-xl p-3 text-center transition-all hover:border-slate-300">
                                    <i class="fas fa-male text-xl text-blue-500 mb-1"></i>
                                    <p class="text-sm font-medium text-slate-700">Father</p>
                                </div>
                            </label>
                            <label class="cursor-pointer">
                                <input type="radio" name="relationship" value="mother" class="hidden peer" onchange="triggerAutosave();" />
                                <div class="peer-checked:border-amber-500 peer-checked:bg-amber-50 border-2 border-slate-200 rounded-xl p-3 text-center transition-all hover:border-slate-300">
                                    <i class="fas fa-female text-xl text-pink-500 mb-1"></i>
                                    <p class="text-sm font-medium text-slate-700">Mother</p>
                                </div>
                            </label>
                            <label class="cursor-pointer">
                                <input type="radio" name="relationship" value="guardian" class="hidden peer" onchange="triggerAutosave();" />
                                <div class="peer-checked:border-amber-500 peer-checked:bg-amber-50 border-2 border-slate-200 rounded-xl p-3 text-center transition-all hover:border-slate-300">
                                    <i class="fas fa-user-shield text-xl text-purple-500 mb-1"></i>
                                    <p class="text-sm font-medium text-slate-700">Guardian</p>
                                </div>
                            </label>
                            <label class="cursor-pointer">
                                <input type="radio" name="relationship" value="other" class="hidden peer" onchange="triggerAutosave();" />
                                <div class="peer-checked:border-amber-500 peer-checked:bg-amber-50 border-2 border-slate-200 rounded-xl p-3 text-center transition-all hover:border-slate-300">
                                    <i class="fas fa-user text-xl text-slate-500 mb-1"></i>
                                    <p class="text-sm font-medium text-slate-700">Other</p>
                                </div>
                            </label>
                        </div>
                        <p class="error-message" id="relationshipError">Please select your relationship</p>
                    </div>

                    <!-- Full Name -->
                    <div>
                        <label class="form-label">
                            Full Name <span class="required">*</span>
                        </label>
                        <input type="text" id="txtParentName" runat="server" 
                               class="form-input w-full px-4 py-3 rounded-xl"
                               placeholder="Enter your full name"
                               oninput="validateField(this, 'parentName'); triggerAutosave();" />
                        <p class="error-message" id="parentNameError">Please enter your full name</p>
                    </div>

                    <!-- Mobile Number -->
                    <div>
                        <label class="form-label">
                            Mobile Number <span class="required">*</span>
                        </label>
                        <div class="flex">
                            <span class="inline-flex items-center px-4 bg-slate-100 border-2 border-r-0 border-slate-200 rounded-l-xl text-slate-600 font-medium">
                                +91
                            </span>
                            <input type="tel" id="txtMobile" runat="server" 
                                   class="form-input flex-1 px-4 py-3 rounded-r-xl rounded-l-none"
                                   placeholder="10-digit mobile number"
                                   maxlength="10"
                                   pattern="[0-9]{10}"
                                   oninput="validateMobile(this); triggerAutosave();" />
                        </div>
                        <p class="error-message" id="mobileError">Please enter a valid 10-digit mobile number</p>
                    </div>

                    <!-- Email Address -->
                    <div>
                        <label class="form-label">
                            Email Address <span class="required">*</span>
                        </label>
                        <input type="email" id="txtEmail" runat="server" 
                               class="form-input w-full px-4 py-3 rounded-xl"
                               placeholder="yourname@email.com"
                               oninput="validateEmail(this); triggerAutosave();" />
                        <p class="error-message" id="emailError">Please enter a valid email address</p>
                    </div>

                    <!-- Alternative Contact (Optional) -->
                    <div>
                        <label class="form-label">
                            Alternative Contact Number 
                            <span class="text-slate-400 text-xs font-normal">(Optional)</span>
                        </label>
                        <div class="flex">
                            <span class="inline-flex items-center px-4 bg-slate-100 border-2 border-r-0 border-slate-200 rounded-l-xl text-slate-600 font-medium">
                                +91
                            </span>
                            <input type="tel" id="txtAltMobile" runat="server" 
                                   class="form-input flex-1 px-4 py-3 rounded-r-xl rounded-l-none"
                                   placeholder="Secondary phone number"
                                   maxlength="10"
                                   oninput="triggerAutosave();" />
                        </div>
                    </div>

                    <!-- Preferred Communication Method -->
                    <div>
                        <label class="form-label">
                            How would you like us to contact you? <span class="required">*</span>
                        </label>
                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
                            <label class="cursor-pointer">
                                <input type="radio" name="contactMethod" value="whatsapp" class="hidden peer" onchange="triggerAutosave();" checked="checked" />
                                <div class="contact-method-card peer-checked:border-amber-500 peer-checked:bg-amber-50 border-2 border-slate-200 rounded-xl p-4 flex items-center space-x-3 transition-all hover:border-slate-300">
                                    <div class="w-10 h-10 bg-green-500 rounded-full flex items-center justify-center">
                                        <i class="fab fa-whatsapp text-white text-lg"></i>
                                    </div>
                                    <div>
                                        <p class="font-medium text-slate-700">WhatsApp</p>
                                        <p class="text-xs text-slate-500">Quick updates</p>
                                    </div>
                                </div>
                            </label>
                            <label class="cursor-pointer">
                                <input type="radio" name="contactMethod" value="call" class="hidden peer" onchange="triggerAutosave();" />
                                <div class="contact-method-card peer-checked:border-amber-500 peer-checked:bg-amber-50 border-2 border-slate-200 rounded-xl p-4 flex items-center space-x-3 transition-all hover:border-slate-300">
                                    <div class="w-10 h-10 bg-blue-500 rounded-full flex items-center justify-center">
                                        <i class="fas fa-phone-alt text-white"></i>
                                    </div>
                                    <div>
                                        <p class="font-medium text-slate-700">Phone Call</p>
                                        <p class="text-xs text-slate-500">Direct conversation</p>
                                    </div>
                                </div>
                            </label>
                            <label class="cursor-pointer">
                                <input type="radio" name="contactMethod" value="email" class="hidden peer" onchange="triggerAutosave();" />
                                <div class="contact-method-card peer-checked:border-amber-500 peer-checked:bg-amber-50 border-2 border-slate-200 rounded-xl p-4 flex items-center space-x-3 transition-all hover:border-slate-300">
                                    <div class="w-10 h-10 bg-purple-500 rounded-full flex items-center justify-center">
                                        <i class="fas fa-envelope text-white"></i>
                                    </div>
                                    <div>
                                        <p class="font-medium text-slate-700">Email</p>
                                        <p class="text-xs text-slate-500">Detailed info</p>
                                    </div>
                                </div>
                            </label>
                        </div>
                    </div>

                    <!-- Current Address -->
                    <div>
                        <label class="form-label">
                            Current Residential Address <span class="required">*</span>
                        </label>
                        <textarea id="txtAddress" runat="server" 
                                  class="form-input w-full px-4 py-3 rounded-xl resize-none"
                                  rows="3"
                                  placeholder="House/Flat No., Street, Locality, City, State, Pincode"
                                  oninput="validateField(this, 'address'); triggerAutosave();"></textarea>
                        <p class="error-message" id="addressError">Please enter your address</p>
                    </div>

                    <!-- Trust Notice -->
                    <div class="trust-notice rounded-xl p-4">
                        <div class="flex items-start space-x-3">
                            <div class="w-8 h-8 bg-green-500 rounded-full flex items-center justify-center flex-shrink-0">
                                <i class="fas fa-shield-alt text-white text-sm"></i>
                            </div>
                            <div>
                                <h4 class="font-semibold text-green-800 text-sm">Your Privacy Matters</h4>
                                <p class="text-sm text-green-700">
                                    We will contact you only for admission-related purposes. Your information 
                                    is never shared with third parties or used for marketing.
                                </p>
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
                            Continue to Academic History
                            <i class="fas fa-arrow-right ml-2"></i>
                        </button>
                    </div>
                </div>
            </div>
        </main>

        <script>
            let autosaveTimeout;

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
                        if (payload && payload.student) {
                            const fullName = [payload.student.firstName, payload.student.middleName, payload.student.lastName].filter(Boolean).join(' ');
                            document.getElementById('studentNameDisplay').textContent = fullName || 'Student';
                            const initials = ((payload.student.firstName?.[0] || '') + (payload.student.lastName?.[0] || '')).toUpperCase();
                            document.getElementById('studentInitials').textContent = initials || '--';
                        }

                        // Parent details (take first parent if present)
                        if (payload && payload.parents && payload.parents.length > 0) {
                            const p = payload.parents[0];
                            document.getElementById('<%= txtParentName.ClientID %>').value = p.fullName || '';
                            document.getElementById('<%= txtMobile.ClientID %>').value = p.mobile || '';
                            // email is stored on student model in current DB contract
                            if (payload.student && payload.student.email)
                                document.getElementById('<%= txtEmail.ClientID %>').value = payload.student.email;

                            if (p.parentType) {
                                const relRadio = document.querySelector(`input[name="relationship"][value="${(p.parentType || '').toLowerCase()}"]`);
                                if (relRadio) relRadio.checked = true;
                            }
                        }

                        if (payload && payload.student) {
                            document.getElementById('<%= txtAddress.ClientID %>').value = payload.student.address || '';
                        }

                        if (payload && payload.draft && payload.draft.admission_no)
                            sessionStorage.setItem('application_id', payload.draft.admission_no);
                    }
                } catch { }
            });

            async function saveParentToBackend() {
                const token = sessionStorage.getItem('resume_token');
                const relationship = document.querySelector('input[name="relationship"]:checked')?.value || '';

                const payload = {
                    resume_token: token,
                    address: document.getElementById('<%= txtAddress.ClientID %>').value,
                    parent: {
                        parentType: relationship,
                        fullName: document.getElementById('<%= txtParentName.ClientID %>').value,
                        mobile: document.getElementById('<%= txtMobile.ClientID %>').value,
                        relationship: relationship,
                        isGuardian: relationship === 'guardian'
                    }
                };

                // Save email through student step endpoint (current models don't support parent email)
                const email = document.getElementById('<%= txtEmail.ClientID %>').value;
                if (email) {
                    await fetch('<%= ResolveUrl("~") %>' + 'admission-draft-step.ashx?action=saveStudent', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ resume_token: token, student: { email: email } })
                    });
                }

                const res = await fetch('<%= ResolveUrl("~") %>' + 'admission-draft-step.ashx?action=saveParent', {
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
                        const r = await saveParentToBackend();
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
                window.location.href = 'application-student.aspx?token=' + encodeURIComponent(token);
            }

            async function proceedToNext() {
                let isValid = true;

                const relationship = document.querySelector('input[name="relationship"]:checked');
                const parentName = document.getElementById('<%= txtParentName.ClientID %>');
                const mobile = document.getElementById('<%= txtMobile.ClientID %>');
                const email = document.getElementById('<%= txtEmail.ClientID %>');
                const address = document.getElementById('<%= txtAddress.ClientID %>');

                if (!relationship) {
                    document.getElementById('relationshipError').classList.add('show');
                    isValid = false;
                } else {
                    document.getElementById('relationshipError').classList.remove('show');
                }

                if (!validateField(parentName, 'parentName')) isValid = false;
                if (!validateMobile(mobile)) isValid = false;
                if (!validateEmail(email)) isValid = false;
                if (!validateField(address, 'address')) isValid = false;

                if (!isValid) {
                    document.querySelector('.error, .error-message.show')?.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    return;
                }

                try {
                    const r = await saveParentToBackend();
                    if (r && r.ok) {
                        const token = sessionStorage.getItem('resume_token');
                        window.location.href = 'application-academic.aspx?token=' + encodeURIComponent(token);
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

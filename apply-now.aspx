<%@ Page Language="C#" AutoEventWireup="true" CodeFile="apply-now.aspx.cs" Inherits="_ApplyNow" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Apply Now - Check Eligibility | Westbrook Academy</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="css/admission-journey.css"/>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600;700&display=swap');
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            min-height: 100vh;
        }
        
        .font-playfair {
            font-family: 'Playfair Display', serif;
        }
        
        .gradient-primary {
            background: linear-gradient(135deg, #1e3a5f 0%, #2d5a87 100%);
        }
        
        .gradient-accent {
            background: linear-gradient(135deg, #c9a227 0%, #e8c547 100%);
        }
        
        .eligibility-card {
            background: white;
            border-radius: 1.5rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.1);
        }
        
        .form-input {
            transition: all 0.3s ease;
            border: 2px solid #e2e8f0;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #c9a227;
            box-shadow: 0 0 0 4px rgba(201, 162, 39, 0.15);
        }
        
        .eligibility-badge {
            animation: slideIn 0.4s ease-out;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .trust-badge {
            background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%);
            border: 1px solid #86efac;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #1e3a5f 0%, #2d5a87 100%);
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px -5px rgba(30, 58, 95, 0.4);
        }
        
        .btn-primary:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
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
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Minimal Header -->
        <header class="bg-white shadow-sm">
            <div class="max-w-7xl mx-auto px-4 py-4">
                <div class="flex items-center justify-between">
                    <a href="Default.aspx" class="flex items-center space-x-3">
                        <div class="w-12 h-12 gradient-primary rounded-xl flex items-center justify-center">
                            <i class="fas fa-graduation-cap text-white text-lg"></i>
                        </div>
                        <div>
                            <h1 class="font-playfair font-bold text-lg text-slate-800">Westbrook Academy</h1>
                            <p class="text-xs text-slate-500">Excellence in Education</p>
                        </div>
                    </a>
                    <a href="Default.aspx" class="text-slate-500 hover:text-slate-700 text-sm flex items-center">
                        <i class="fas fa-arrow-left mr-2"></i>Back to Home
                    </a>
                </div>
            </div>
        </header>

        <main class="max-w-6xl mx-auto px-4 py-8 md:py-16">
            <div class="grid lg:grid-cols-2 gap-8 lg:gap-16 items-start">
                
                <!-- Left Column: Info & Trust -->
                <div class="order-2 lg:order-1">
                    <div class="mb-8">
                        <span class="inline-block bg-amber-100 text-amber-800 px-4 py-1.5 rounded-full text-sm font-semibold mb-4">
                            <i class="fas fa-calendar-check mr-2"></i>Admissions 2025-2026
                        </span>
                        <h1 class="font-playfair text-3xl md:text-4xl lg:text-5xl font-bold text-slate-800 leading-tight mb-4">
                            Start Your Child's Journey to Excellence
                        </h1>
                        <p class="text-slate-600 text-lg leading-relaxed">
                            Before we begin, let's make sure your child is eligible for the grade you're 
                            interested in. This takes less than a minute.
                        </p>
                    </div>
                    
                    <!-- Trust Signals -->
                    <div class="space-y-4 mb-8">
                        <div class="trust-badge rounded-xl p-4 flex items-start space-x-3">
                            <div class="w-10 h-10 bg-green-500 rounded-full flex items-center justify-center flex-shrink-0">
                                <i class="fas fa-shield-alt text-white"></i>
                            </div>
                            <div>
                                <h4 class="font-semibold text-slate-800">Your Information is Secure</h4>
                                <p class="text-sm text-slate-600">We never share your details with third parties.</p>
                            </div>
                        </div>
                        
                        <div class="trust-badge rounded-xl p-4 flex items-start space-x-3">
                            <div class="w-10 h-10 bg-green-500 rounded-full flex items-center justify-center flex-shrink-0">
                                <i class="fas fa-clock text-white"></i>
                            </div>
                            <div>
                                <h4 class="font-semibold text-slate-800">Save & Continue Anytime</h4>
                                <p class="text-sm text-slate-600">Your progress is saved automatically. Complete at your own pace.</p>
                            </div>
                        </div>
                        
                        <div class="trust-badge rounded-xl p-4 flex items-start space-x-3">
                            <div class="w-10 h-10 bg-green-500 rounded-full flex items-center justify-center flex-shrink-0">
                                <i class="fas fa-rupee-sign text-white"></i>
                            </div>
                            <div>
                                <h4 class="font-semibold text-slate-800">No Application Fee</h4>
                                <p class="text-sm text-slate-600">Applying to Westbrook Academy is completely free.</p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Quick Stats -->
                    <div class="grid grid-cols-3 gap-4 bg-slate-50 rounded-xl p-6">
                        <div class="text-center">
                            <div class="text-2xl font-bold text-slate-800">10-12</div>
                            <div class="text-xs text-slate-500">Minutes to Apply</div>
                        </div>
                        <div class="text-center border-x border-slate-200">
                            <div class="text-2xl font-bold text-slate-800">5</div>
                            <div class="text-xs text-slate-500">Simple Steps</div>
                        </div>
                        <div class="text-center">
                            <div class="text-2xl font-bold text-slate-800">48h</div>
                            <div class="text-xs text-slate-500">Response Time</div>
                        </div>
                    </div>
                </div>
                
                <!-- Right Column: Eligibility Form -->
                <div class="order-1 lg:order-2">
                    <div class="eligibility-card p-6 md:p-8">
                        <div class="text-center mb-8">
                            <div class="w-16 h-16 gradient-accent rounded-full flex items-center justify-center mx-auto mb-4">
                                <i class="fas fa-clipboard-check text-white text-2xl"></i>
                            </div>
                            <h2 class="font-playfair text-2xl font-bold text-slate-800 mb-2">Check Eligibility</h2>
                            <p class="text-slate-500">Tell us a few details about your child</p>
                        </div>
                        
                        <div class="space-y-5">
                            <!-- Academic Year -->
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">
                                    Academic Year
                                </label>
                                <div class="relative">
                                    <select id="ddlAcademicYear" runat="server" 
                                            class="form-input w-full px-4 py-3.5 rounded-xl bg-slate-50 appearance-none cursor-pointer">
                                        <option value="2025-2026" selected="selected">2025-2026</option>
                                        <option value="2026-2027">2026-2027</option>
                                    </select>
                                    <div class="absolute right-4 top-1/2 -translate-y-1/2 pointer-events-none">
                                        <i class="fas fa-chevron-down text-slate-400"></i>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Grade Applying For -->
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">
                                    Grade Applying For <span class="text-red-500">*</span>
                                </label>
                                <div class="relative">
                                    <select id="ddlGrade" runat="server" 
                                            class="form-input w-full px-4 py-3.5 rounded-xl bg-white appearance-none cursor-pointer"
                                            onchange="checkEligibility()">
                                        <option value="">Select a grade</option>
                                        <option value="nursery">Nursery (Age 3+)</option>
                                        <option value="lkg">LKG (Age 4+)</option>
                                        <option value="ukg">UKG (Age 5+)</option>
                                        <option value="1">Grade 1 (Age 6+)</option>
                                        <option value="2">Grade 2 (Age 7+)</option>
                                        <option value="3">Grade 3 (Age 8+)</option>
                                        <option value="4">Grade 4 (Age 9+)</option>
                                        <option value="5">Grade 5 (Age 10+)</option>
                                        <option value="6">Grade 6 (Age 11+)</option>
                                        <option value="7">Grade 7 (Age 12+)</option>
                                        <option value="8">Grade 8 (Age 13+)</option>
                                        <option value="9">Grade 9 (Age 14+)</option>
                                        <option value="10">Grade 10 (Age 15+)</option>
                                        <option value="11">Grade 11 (Age 16+)</option>
                                        <option value="12">Grade 12 (Age 17+)</option>
                                    </select>
                                    <div class="absolute right-4 top-1/2 -translate-y-1/2 pointer-events-none">
                                        <i class="fas fa-chevron-down text-slate-400"></i>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Child's Date of Birth -->
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">
                                    Child's Date of Birth <span class="text-red-500">*</span>
                                </label>
                                <input type="date" id="txtDob" runat="server" 
                                       class="form-input w-full px-4 py-3.5 rounded-xl bg-white"
                                       onchange="checkEligibility()" />
                                <p class="text-xs text-slate-400 mt-1.5">
                                    Age is calculated as on April 1st of the academic year
                                </p>
                            </div>
                            
                            <!-- Eligibility Result -->
                            <div id="eligibilityResult" class="hidden">
                                <!-- Eligible State -->
                                <div id="eligibleBadge" class="eligibility-badge bg-green-50 border border-green-200 rounded-xl p-4 hidden">
                                    <div class="flex items-center space-x-3">
                                        <div class="w-10 h-10 bg-green-500 rounded-full flex items-center justify-center flex-shrink-0">
                                            <i class="fas fa-check text-white"></i>
                                        </div>
                                        <div>
                                            <h4 class="font-semibold text-green-800">Eligible!</h4>
                                            <p class="text-sm text-green-700" id="eligibleMessage">
                                                Your child is eligible for admission.
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Not Eligible State -->
                                <div id="notEligibleBadge" class="eligibility-badge bg-amber-50 border border-amber-200 rounded-xl p-4 hidden">
                                    <div class="flex items-start space-x-3">
                                        <div class="w-10 h-10 bg-amber-500 rounded-full flex items-center justify-center flex-shrink-0">
                                            <i class="fas fa-exclamation text-white"></i>
                                        </div>
                                        <div>
                                            <h4 class="font-semibold text-amber-800">Age Criteria Not Met</h4>
                                            <p class="text-sm text-amber-700" id="notEligibleMessage">
                                                Your child doesn't meet the age requirement for this grade.
                                            </p>
                                            <p class="text-sm text-amber-600 mt-2" id="suggestedGrade"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="mt-8 space-y-3">
                            <button type="button" id="btnProceed" 
                                    class="btn-primary w-full text-white py-4 rounded-xl font-semibold text-lg flex items-center justify-center disabled:opacity-50"
                                    disabled="disabled"
                                    onclick="proceedToApplication()">
                                <span>Proceed with Application</span>
                                <i class="fas fa-arrow-right ml-3"></i>
                            </button>
                            
                            <div class="text-center">
                                <span class="text-slate-400 text-sm">or</span>
                            </div>
                            
                            <a href="inquiry.aspx" 
                               class="btn-secondary w-full py-3.5 rounded-xl font-medium text-slate-700 flex items-center justify-center">
                                <i class="fas fa-question-circle mr-2 text-amber-500"></i>
                                <span>Just want information? Make an Inquiry</span>
                            </a>
                        </div>
                        
                        <!-- Help Text -->
                        <div class="mt-6 pt-6 border-t border-slate-100 text-center">
                            <p class="text-sm text-slate-500">
                                <i class="fas fa-phone-alt mr-2 text-slate-400"></i>
                                Need help? Call us at <a href="tel:+911234567890" class="text-blue-600 font-medium">+91 12345 67890</a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        
        <!-- Footer -->
        <footer class="bg-white border-t border-slate-200 py-6 mt-auto">
            <div class="max-w-6xl mx-auto px-4 text-center">
                <p class="text-sm text-slate-500">
                    © 2024 Westbrook Academy. All rights reserved. | 
                    <a href="#" class="text-blue-600 hover:underline">Privacy Policy</a> | 
                    <a href="#" class="text-blue-600 hover:underline">Terms of Use</a>
                </p>
            </div>
        </footer>

        <script>
            // Grade age requirements (minimum age as on April 1st)
            const gradeAgeRequirements = {
                'nursery': { min: 3, max: 4, name: 'Nursery' },
                'lkg': { min: 4, max: 5, name: 'LKG' },
                'ukg': { min: 5, max: 6, name: 'UKG' },
                '1': { min: 6, max: 7, name: 'Grade 1' },
                '2': { min: 7, max: 8, name: 'Grade 2' },
                '3': { min: 8, max: 9, name: 'Grade 3' },
                '4': { min: 9, max: 10, name: 'Grade 4' },
                '5': { min: 10, max: 11, name: 'Grade 5' },
                '6': { min: 11, max: 12, name: 'Grade 6' },
                '7': { min: 12, max: 13, name: 'Grade 7' },
                '8': { min: 13, max: 14, name: 'Grade 8' },
                '9': { min: 14, max: 15, name: 'Grade 9' },
                '10': { min: 15, max: 16, name: 'Grade 10' },
                '11': { min: 16, max: 17, name: 'Grade 11' },
                '12': { min: 17, max: 18, name: 'Grade 12' }
            };

            function calculateAge(dob, referenceDate) {
                const birthDate = new Date(dob);
                const refDate = new Date(referenceDate);
                let age = refDate.getFullYear() - birthDate.getFullYear();
                const monthDiff = refDate.getMonth() - birthDate.getMonth();
                
                if (monthDiff < 0 || (monthDiff === 0 && refDate.getDate() < birthDate.getDate())) {
                    age--;
                }
                return age;
            }

            function getSuggestedGrade(age) {
                for (const [gradeKey, gradeInfo] of Object.entries(gradeAgeRequirements)) {
                    if (age >= gradeInfo.min && age < gradeInfo.max) {
                        return gradeInfo;
                    }
                }
                return null;
            }

            function checkEligibility() {
                const grade = document.getElementById('<%= ddlGrade.ClientID %>').value;
                const dob = document.getElementById('<%= txtDob.ClientID %>').value;
                const academicYear = document.getElementById('<%= ddlAcademicYear.ClientID %>').value;
                
                const resultDiv = document.getElementById('eligibilityResult');
                const eligibleBadge = document.getElementById('eligibleBadge');
                const notEligibleBadge = document.getElementById('notEligibleBadge');
                const btnProceed = document.getElementById('btnProceed');
                
                // Reset
                resultDiv.classList.add('hidden');
                eligibleBadge.classList.add('hidden');
                notEligibleBadge.classList.add('hidden');
                btnProceed.disabled = true;
                
                if (!grade || !dob) {
                    return;
                }
                
                // Calculate reference date (April 1st of academic year)
                const yearStart = parseInt(academicYear.split('-')[0]);
                const referenceDate = `${yearStart}-04-01`;
                
                const age = calculateAge(dob, referenceDate);
                const gradeRequirement = gradeAgeRequirements[grade];
                
                resultDiv.classList.remove('hidden');
                
                if (age >= gradeRequirement.min && age < gradeRequirement.max + 1) {
                    // Eligible
                    eligibleBadge.classList.remove('hidden');
                    document.getElementById('eligibleMessage').textContent = 
                        `Your child (age ${age}) is eligible for ${gradeRequirement.name} admission.`;
                    btnProceed.disabled = false;
                    
                    // Store in session storage
                    sessionStorage.setItem('admission_grade', grade);
                    sessionStorage.setItem('admission_dob', dob);
                    sessionStorage.setItem('admission_year', academicYear);
                    sessionStorage.setItem('admission_eligible', 'true');
                } else {
                    // Not Eligible
                    notEligibleBadge.classList.remove('hidden');
                    document.getElementById('notEligibleMessage').textContent = 
                        `Your child is ${age} years old on April 1st, ${yearStart}. The age requirement for ${gradeRequirement.name} is ${gradeRequirement.min}-${gradeRequirement.max} years.`;
                    
                    const suggested = getSuggestedGrade(age);
                    if (suggested) {
                        document.getElementById('suggestedGrade').textContent = 
                            `Based on their age, ${suggested.name} may be a suitable option.`;
                    } else {
                        document.getElementById('suggestedGrade').textContent = '';
                    }
                }
            }

            async function proceedToApplication() {
                const eligible = sessionStorage.getItem('admission_eligible');
                if (eligible !== 'true') return;

                const grade = sessionStorage.getItem('admission_grade');
                const dob = sessionStorage.getItem('admission_dob');
                const year = sessionStorage.getItem('admission_year');

                try {
                    const res = await fetch('admission-draft-api.ashx?action=create', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ admission_grade: grade, admission_dob: dob, admission_year: year })
                    });

                    const data = await res.json();
                    if (!data || data.ok !== true) {
                        alert(data && data.message ? data.message : 'Unable to start application.');
                        return;
                    }

                    sessionStorage.setItem('resume_token', data.resume_token);
                    sessionStorage.setItem('application_id', data.admission_no);

                    window.location.href = 'application-overview.aspx?token=' + encodeURIComponent(data.resume_token);
                }
                catch {
                    alert('Unable to reach server. Please try again.');
                }
            }
        </script>
    </form>
</body>
</html>

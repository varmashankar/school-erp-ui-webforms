<%@ Page Language="C#" AutoEventWireup="true" CodeFile="application-confirmation.aspx.cs" Inherits="ApplicationConfirmation" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Application Submitted | Westbrook Academy</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600;700&display=swap');
        
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%); min-height: 100vh; }
        .font-playfair { font-family: 'Playfair Display', serif; }
        
        .gradient-primary { background: linear-gradient(135deg, #1e3a5f 0%, #2d5a87 100%); }
        .gradient-accent { background: linear-gradient(135deg, #c9a227 0%, #e8c547 100%); }
        
        .success-icon {
            animation: successPop 0.6s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        }
        
        @keyframes successPop {
            0% { transform: scale(0); opacity: 0; }
            50% { transform: scale(1.2); }
            100% { transform: scale(1); opacity: 1; }
        }
        
        .confetti {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            overflow: hidden;
            z-index: 0;
        }
        
        .confetti-piece {
            position: absolute;
            width: 10px;
            height: 10px;
            animation: confettiFall 3s ease-out forwards;
        }
        
        @keyframes confettiFall {
            0% { transform: translateY(-100vh) rotate(0deg); opacity: 1; }
            100% { transform: translateY(100vh) rotate(720deg); opacity: 0; }
        }
        
        .timeline-step {
            position: relative;
            padding-left: 40px;
        }
        
        .timeline-step::before {
            content: '';
            position: absolute;
            left: 15px;
            top: 30px;
            bottom: -20px;
            width: 2px;
            background: #e2e8f0;
        }
        
        .timeline-step:last-child::before {
            display: none;
        }
        
        .timeline-dot {
            position: absolute;
            left: 0;
            top: 4px;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            font-weight: 600;
        }
        
        .timeline-dot.active {
            background: #22c55e;
            color: white;
        }
        
        .timeline-dot.pending {
            background: #e2e8f0;
            color: #64748b;
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
        
        .btn-outline {
            border: 2px solid #1e3a5f;
            color: #1e3a5f;
            transition: all 0.3s ease;
        }
        
        .btn-outline:hover {
            background: #1e3a5f;
            color: white;
        }
        
        .id-card {
            background: linear-gradient(135deg, #1e3a5f 0%, #2d5a87 100%);
            border-radius: 1rem;
            position: relative;
            overflow: hidden;
        }
        
        .id-card::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
        }
        
        .share-btn {
            transition: all 0.2s ease;
        }
        
        .share-btn:hover {
            transform: scale(1.1);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Confetti Animation -->
        <div class="confetti" id="confetti"></div>

        <!-- Header -->
        <header class="bg-white shadow-sm relative z-10">
            <div class="max-w-5xl mx-auto px-4 py-4">
                <div class="flex items-center justify-between">
                    <a href="Default.aspx" class="flex items-center space-x-3">
                        <div class="w-10 h-10 gradient-primary rounded-lg flex items-center justify-center">
                            <i class="fas fa-graduation-cap text-white text-sm"></i>
                        </div>
                        <span class="font-playfair font-bold text-slate-800">Westbrook Academy</span>
                    </a>
                    <a href="Default.aspx" class="text-slate-500 hover:text-slate-700 text-sm">
                        <i class="fas fa-home mr-1"></i>Home
                    </a>
                </div>
            </div>
        </header>

        <main class="max-w-2xl mx-auto px-4 py-8 relative z-10">
            <!-- Success Card -->
            <div class="bg-white rounded-3xl shadow-2xl p-8 md:p-10 text-center mb-8">
                <!-- Success Icon -->
                <div class="success-icon w-24 h-24 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-6">
                    <i class="fas fa-check text-white text-4xl"></i>
                </div>
                
                <h1 class="font-playfair text-3xl md:text-4xl font-bold text-slate-800 mb-3">
                    Application Submitted!
                </h1>
                <p class="text-slate-600 text-lg mb-8">
                    Thank you for applying to Westbrook Academy. We've received your application 
                    and our admissions team will review it shortly.
                </p>
                
                <!-- Application ID Card -->
                <div class="id-card p-6 mb-8">
                    <p class="text-blue-200 text-sm mb-1">Your Application ID</p>
                    <p class="font-mono text-3xl font-bold text-white mb-3" id="applicationId">WA-XXXXXX</p>
                    <div class="flex items-center justify-center space-x-4 text-blue-200 text-sm">
                        <span><i class="fas fa-user-graduate mr-1"></i><span id="studentName">Student Name</span></span>
                        <span class="text-blue-300">|</span>
                        <span><i class="fas fa-book mr-1"></i><span id="gradeDisplay">Grade 1</span></span>
                    </div>
                    <button type="button" onclick="copyApplicationId()" 
                            class="mt-4 text-white text-sm underline hover:no-underline">
                        <i class="fas fa-copy mr-1"></i>Copy ID
                    </button>
                </div>
                
                <!-- Confirmation Email Notice -->
                <div class="bg-blue-50 border border-blue-200 rounded-xl p-4 mb-6">
                    <div class="flex items-center justify-center space-x-3">
                        <i class="fas fa-envelope text-blue-500 text-xl"></i>
                        <p class="text-blue-800">
                            A confirmation email has been sent to <strong id="emailDisplay">your@email.com</strong>
                        </p>
                    </div>
                </div>
            </div>

            <!-- What Happens Next -->
            <div class="bg-white rounded-2xl shadow-lg p-6 md:p-8 mb-8">
                <h2 class="font-playfair text-2xl font-bold text-slate-800 mb-6 text-center">
                    <i class="fas fa-route text-amber-500 mr-2"></i>
                    What Happens Next?
                </h2>
                
                <div class="space-y-6">
                    <div class="timeline-step">
                        <div class="timeline-dot active">
                            <i class="fas fa-check text-xs"></i>
                        </div>
                        <div class="ml-2">
                            <h4 class="font-semibold text-slate-800">Application Received</h4>
                            <p class="text-sm text-slate-500 mt-1" id="submissionTime">Just now</p>
                        </div>
                    </div>
                    
                    <div class="timeline-step">
                        <div class="timeline-dot pending">2</div>
                        <div class="ml-2">
                            <h4 class="font-semibold text-slate-800">Document Review</h4>
                            <p class="text-sm text-slate-500 mt-1">
                                Our team will verify your submitted documents within <strong>24-48 hours</strong>
                            </p>
                        </div>
                    </div>
                    
                    <div class="timeline-step">
                        <div class="timeline-dot pending">3</div>
                        <div class="ml-2">
                            <h4 class="font-semibold text-slate-800">Interaction Call</h4>
                            <p class="text-sm text-slate-500 mt-1">
                                We'll contact you to schedule a brief interaction with the student
                            </p>
                        </div>
                    </div>
                    
                    <div class="timeline-step">
                        <div class="timeline-dot pending">4</div>
                        <div class="ml-2">
                            <h4 class="font-semibold text-slate-800">Admission Decision</h4>
                            <p class="text-sm text-slate-500 mt-1">
                                Final decision communicated within <strong>7-10 working days</strong>
                            </p>
                        </div>
                    </div>
                </div>
                
                <!-- Contact Info -->
                <div class="mt-8 pt-6 border-t border-slate-100">
                    <p class="text-center text-sm text-slate-500">
                        <i class="fas fa-question-circle mr-1"></i>
                        Questions? Contact our admissions team at 
                        <a href="tel:+911234567890" class="text-blue-600 font-medium">+91 12345 67890</a>
                        or email 
                        <a href="mailto:admissions@westbrook.edu" class="text-blue-600 font-medium">admissions@westbrook.edu</a>
                    </p>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="bg-white rounded-2xl shadow-lg p-6">
                <h3 class="font-semibold text-slate-800 mb-4 text-center">What would you like to do?</h3>
                
                <div class="grid sm:grid-cols-3 gap-4 mb-6">
                    <button type="button" onclick="trackApplication()" 
                            class="btn-primary py-4 rounded-xl font-semibold text-white flex flex-col items-center justify-center">
                        <i class="fas fa-search text-xl mb-2"></i>
                        <span>Track Application</span>
                    </button>
                    
                    <button type="button" onclick="bookVisit()" 
                            class="btn-secondary py-4 rounded-xl font-semibold text-slate-700 flex flex-col items-center justify-center">
                        <i class="fas fa-calendar-alt text-xl mb-2 text-amber-500"></i>
                        <span>Book Campus Visit</span>
                    </button>
                    
                    <button type="button" onclick="downloadPdf()" 
                            class="btn-outline py-4 rounded-xl font-semibold flex flex-col items-center justify-center">
                        <i class="fas fa-file-download text-xl mb-2"></i>
                        <span>Download PDF</span>
                    </button>
                </div>
                
                <!-- Share Section -->
                <div class="text-center pt-4 border-t border-slate-100">
                    <p class="text-sm text-slate-500 mb-3">Share the good news!</p>
                    <div class="flex items-center justify-center space-x-4">
                        <button type="button" onclick="shareWhatsApp()" 
                                class="share-btn w-10 h-10 bg-green-500 rounded-full flex items-center justify-center text-white">
                            <i class="fab fa-whatsapp text-lg"></i>
                        </button>
                        <button type="button" onclick="shareFacebook()" 
                                class="share-btn w-10 h-10 bg-blue-600 rounded-full flex items-center justify-center text-white">
                            <i class="fab fa-facebook-f text-lg"></i>
                        </button>
                        <button type="button" onclick="shareTwitter()" 
                                class="share-btn w-10 h-10 bg-sky-500 rounded-full flex items-center justify-center text-white">
                            <i class="fab fa-twitter text-lg"></i>
                        </button>
                        <button type="button" onclick="copyLink()" 
                                class="share-btn w-10 h-10 bg-slate-200 rounded-full flex items-center justify-center text-slate-600">
                            <i class="fas fa-link text-lg"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Return Home -->
            <div class="text-center mt-8">
                <a href="Default.aspx" class="text-slate-500 hover:text-slate-700 transition-colors">
                    <i class="fas fa-arrow-left mr-2"></i>
                    Return to Home Page
                </a>
            </div>
        </main>

        <!-- Footer -->
        <footer class="bg-white border-t border-slate-200 py-6 mt-12 relative z-10">
            <div class="max-w-5xl mx-auto px-4 text-center">
                <p class="text-sm text-slate-500">
                    © 2024 Westbrook Academy | 
                    <a href="#" class="text-blue-600 hover:underline">Privacy Policy</a> | 
                    <a href="#" class="text-blue-600 hover:underline">Contact Us</a>
                </p>
            </div>
        </footer>

        <script>
            // Create confetti effect
            function createConfetti() {
                const confettiContainer = document.getElementById('confetti');
                const colors = ['#c9a227', '#e8c547', '#22c55e', '#3b82f6', '#a855f7', '#ec4899'];
                
                for (let i = 0; i < 50; i++) {
                    const piece = document.createElement('div');
                    piece.className = 'confetti-piece';
                    piece.style.left = Math.random() * 100 + '%';
                    piece.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                    piece.style.animationDelay = Math.random() * 2 + 's';
                    piece.style.borderRadius = Math.random() > 0.5 ? '50%' : '0';
                    confettiContainer.appendChild(piece);
                }
                
                // Remove confetti after animation
                setTimeout(() => {
                    confettiContainer.innerHTML = '';
                }, 5000);
            }

            // Initialize page
            document.addEventListener('DOMContentLoaded', function() {
                createConfetti();
                loadApplicationData();
            });

            function loadApplicationData() {
                const appId = sessionStorage.getItem('application_id') || 'WA-XXXXXX';
                const grade = sessionStorage.getItem('admission_grade');
                const studentData = JSON.parse(sessionStorage.getItem('student_data') || '{}');
                const parentData = JSON.parse(sessionStorage.getItem('parent_data') || '{}');
                const submissionTime = sessionStorage.getItem('submission_time');
                
                document.getElementById('applicationId').textContent = appId;
                
                const fullName = [studentData.firstName, studentData.lastName].filter(Boolean).join(' ');
                document.getElementById('studentName').textContent = fullName || 'Student';
                
                const gradeNames = {
                    'nursery': 'Nursery', 'lkg': 'LKG', 'ukg': 'UKG',
                    '1': 'Grade 1', '2': 'Grade 2', '3': 'Grade 3',
                    '4': 'Grade 4', '5': 'Grade 5', '6': 'Grade 6',
                    '7': 'Grade 7', '8': 'Grade 8', '9': 'Grade 9',
                    '10': 'Grade 10', '11': 'Grade 11', '12': 'Grade 12'
                };
                document.getElementById('gradeDisplay').textContent = gradeNames[grade] || grade;
                
                document.getElementById('emailDisplay').textContent = parentData.email || 'your email';
                
                if (submissionTime) {
                    const date = new Date(submissionTime);
                    document.getElementById('submissionTime').textContent = 
                        date.toLocaleDateString('en-IN', { 
                            day: 'numeric', 
                            month: 'long', 
                            year: 'numeric',
                            hour: '2-digit',
                            minute: '2-digit'
                        });
                }
            }

            function copyApplicationId() {
                const appId = document.getElementById('applicationId').textContent;
                navigator.clipboard.writeText(appId).then(() => {
                    alert('Application ID copied to clipboard!');
                });
            }

            function trackApplication() {
                alert('Application tracking feature coming soon! You can track your application using ID: ' + 
                      document.getElementById('applicationId').textContent);
            }

            function bookVisit() {
                window.location.href = 'Default.aspx#contact';
            }

            function downloadPdf() {
                alert('PDF download feature coming soon! A detailed application summary will be generated.');
            }

            function shareWhatsApp() {
                const appId = document.getElementById('applicationId').textContent;
                const text = `I just applied to Westbrook Academy! Application ID: ${appId}`;
                window.open(`https://wa.me/?text=${encodeURIComponent(text)}`, '_blank');
            }

            function shareFacebook() {
                window.open('https://www.facebook.com/sharer/sharer.php?u=' + 
                    encodeURIComponent(window.location.origin), '_blank');
            }

            function shareTwitter() {
                const text = 'Just applied to Westbrook Academy! Excited for this new journey! ??';
                window.open(`https://twitter.com/intent/tweet?text=${encodeURIComponent(text)}`, '_blank');
            }

            function copyLink() {
                navigator.clipboard.writeText(window.location.href).then(() => {
                    alert('Link copied to clipboard!');
                });
            }
        </script>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeFile="application-documents.aspx.cs" Inherits="ApplicationDocuments" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Upload Documents - Step 4 of 5 | Westbrook Academy</title>
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
        
        .btn-secondary { background: white; border: 2px solid #e2e8f0; transition: all 0.3s ease; }
        .btn-secondary:hover { border-color: #94a3b8; }
        
        .autosave-indicator { transition: all 0.3s ease; }
        .autosave-indicator.saving { color: #f59e0b; }
        .autosave-indicator.saved { color: #22c55e; }
        
        /* Upload Card Styles */
        .upload-card {
            border: 2px dashed #cbd5e1;
            border-radius: 1rem;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .upload-card:hover {
            border-color: #c9a227;
            background: #fffbeb;
        }
        
        .upload-card.dragover {
            border-color: #c9a227;
            background: #fef3c7;
            transform: scale(1.02);
        }
        
        .upload-card.uploaded {
            border-style: solid;
            border-color: #22c55e;
            background: #f0fdf4;
        }
        
        .upload-card.error {
            border-color: #ef4444;
            background: #fef2f2;
        }
        
        .upload-card.required {
            position: relative;
        }
        
        .upload-card.required::before {
            content: 'Required';
            position: absolute;
            top: -10px;
            right: 12px;
            background: #ef4444;
            color: white;
            font-size: 10px;
            font-weight: 600;
            padding: 2px 8px;
            border-radius: 10px;
        }
        
        .upload-card.optional::before {
            content: 'Optional';
            position: absolute;
            top: -10px;
            right: 12px;
            background: #94a3b8;
            color: white;
            font-size: 10px;
            font-weight: 600;
            padding: 2px 8px;
            border-radius: 10px;
        }
        
        .file-input {
            display: none;
        }
        
        .upload-progress {
            height: 4px;
            background: #e2e8f0;
            border-radius: 2px;
            overflow: hidden;
            margin-top: 12px;
        }
        
        .upload-progress-bar {
            height: 100%;
            background: linear-gradient(135deg, #c9a227 0%, #e8c547 100%);
            transition: width 0.3s ease;
        }
        
        .preview-image {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
        }
        
        .file-type-icon {
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            font-size: 24px;
        }
        
        .skip-notice {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            border: 1px solid #fcd34d;
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
                        <a href="application-academic.aspx" class="text-slate-400 hover:text-slate-600">
                            <i class="fas fa-arrow-left"></i>
                        </a>
                        <div>
                            <h1 class="font-semibold text-slate-800">Upload Documents</h1>
                            <p class="text-xs text-slate-500">Step 4 of 5</p>
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
                        <div class="step-dot completed"><i class="fas fa-check text-xs"></i></div>
                        <span class="text-xs text-green-600 font-medium hidden sm:inline">Academic</span>
                    </div>
                    <div class="flex-1 mx-2">
                        <div class="progress-bar"><div class="progress-fill" style="width: 100%"></div></div>
                    </div>
                    <div class="flex items-center space-x-2">
                        <div class="step-dot active">4</div>
                        <span class="text-xs text-amber-600 font-medium hidden sm:inline">Documents</span>
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
            <!-- Info Card -->
            <div class="bg-blue-50 border border-blue-200 rounded-xl p-4 mb-8">
                <div class="flex items-start space-x-3">
                    <div class="w-10 h-10 bg-blue-500 rounded-lg flex items-center justify-center flex-shrink-0">
                        <i class="fas fa-info text-white"></i>
                    </div>
                    <div>
                        <h4 class="font-semibold text-blue-800">Upload Tips</h4>
                        <ul class="text-sm text-blue-700 mt-1 space-y-1">
                            <li>• Accepted formats: JPG, PNG, PDF (max 5MB each)</li>
                            <li>• Ensure documents are clear and readable</li>
                            <li>• You can take a photo with your phone camera</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Form Card -->
            <div class="bg-white rounded-2xl shadow-lg p-6 md:p-8">
                <div class="mb-8">
                    <h2 class="font-playfair text-2xl font-bold text-slate-800 mb-2">
                        Required Documents
                    </h2>
                    <p class="text-slate-500">Upload clear photos or scans of the following documents.</p>
                </div>

                <div class="space-y-6">
                    <!-- Birth Certificate (Required) -->
                    <div class="upload-card required p-6" id="birthCertCard" 
                         onclick="document.getElementById('birthCertInput').click();"
                         ondrop="handleDrop(event, 'birthCert')" 
                         ondragover="handleDragOver(event, 'birthCertCard')"
                         ondragleave="handleDragLeave(event, 'birthCertCard')">
                        <input type="file" id="birthCertInput" class="file-input" 
                               accept=".jpg,.jpeg,.png,.pdf" 
                               onchange="handleFileSelect(this, 'birthCert')" />
                        
                        <div id="birthCertDefault" class="text-center">
                            <div class="w-16 h-16 bg-slate-100 rounded-full flex items-center justify-center mx-auto mb-4">
                                <i class="fas fa-file-medical text-slate-400 text-2xl"></i>
                            </div>
                            <h4 class="font-semibold text-slate-800 mb-1">Birth Certificate</h4>
                            <p class="text-sm text-slate-500 mb-4">Government-issued birth certificate</p>
                            <div class="flex items-center justify-center space-x-2 text-amber-600">
                                <i class="fas fa-cloud-upload-alt"></i>
                                <span class="text-sm font-medium">Click or drag to upload</span>
                            </div>
                        </div>
                        
                        <div id="birthCertUploaded" class="hidden">
                            <div class="flex items-center space-x-4">
                                <div class="file-type-icon bg-green-100 text-green-600">
                                    <i class="fas fa-file-alt"></i>
                                </div>
                                <div class="flex-1">
                                    <h4 class="font-semibold text-slate-800" id="birthCertFileName">filename.pdf</h4>
                                    <p class="text-sm text-green-600"><i class="fas fa-check-circle mr-1"></i>Uploaded successfully</p>
                                </div>
                                <button type="button" onclick="event.stopPropagation(); removeFile('birthCert');" 
                                        class="text-red-500 hover:text-red-700 p-2">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </div>
                        </div>
                        
                        <div id="birthCertProgress" class="hidden">
                            <div class="upload-progress">
                                <div class="upload-progress-bar" style="width: 0%"></div>
                            </div>
                            <p class="text-xs text-slate-500 mt-2 text-center">Uploading...</p>
                        </div>
                    </div>

                    <!-- Passport Photo (Required) -->
                    <div class="upload-card required p-6" id="photoCard" 
                         onclick="document.getElementById('photoInput').click();"
                         ondrop="handleDrop(event, 'photo')" 
                         ondragover="handleDragOver(event, 'photoCard')"
                         ondragleave="handleDragLeave(event, 'photoCard')">
                        <input type="file" id="photoInput" class="file-input" 
                               accept=".jpg,.jpeg,.png" 
                               onchange="handleFileSelect(this, 'photo')" />
                        
                        <div id="photoDefault" class="text-center">
                            <div class="w-16 h-16 bg-slate-100 rounded-full flex items-center justify-center mx-auto mb-4">
                                <i class="fas fa-camera text-slate-400 text-2xl"></i>
                            </div>
                            <h4 class="font-semibold text-slate-800 mb-1">Passport Size Photo</h4>
                            <p class="text-sm text-slate-500 mb-4">Recent color photograph of the student</p>
                            <div class="flex items-center justify-center space-x-2 text-amber-600">
                                <i class="fas fa-cloud-upload-alt"></i>
                                <span class="text-sm font-medium">Click or drag to upload</span>
                            </div>
                        </div>
                        
                        <div id="photoUploaded" class="hidden">
                            <div class="flex items-center space-x-4">
                                <img id="photoPreview" src="" alt="Preview" class="preview-image" />
                                <div class="flex-1">
                                    <h4 class="font-semibold text-slate-800" id="photoFileName">photo.jpg</h4>
                                    <p class="text-sm text-green-600"><i class="fas fa-check-circle mr-1"></i>Uploaded successfully</p>
                                </div>
                                <button type="button" onclick="event.stopPropagation(); removeFile('photo');" 
                                        class="text-red-500 hover:text-red-700 p-2">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </div>
                        </div>
                        
                        <div id="photoProgress" class="hidden">
                            <div class="upload-progress">
                                <div class="upload-progress-bar" style="width: 0%"></div>
                            </div>
                            <p class="text-xs text-slate-500 mt-2 text-center">Uploading...</p>
                        </div>
                    </div>

                    <!-- Optional Documents Section -->
                    <div class="pt-6 border-t border-slate-100">
                        <h3 class="font-semibold text-slate-800 mb-4 flex items-center">
                            <i class="fas fa-folder-open text-slate-400 mr-2"></i>
                            Additional Documents
                            <span class="ml-2 text-xs font-normal text-slate-400">(Optional - can upload later)</span>
                        </h3>
                    </div>

                    <!-- Previous Report Card (Optional) -->
                    <div class="upload-card optional p-6" id="reportCardCard" 
                         onclick="document.getElementById('reportCardInput').click();"
                         ondrop="handleDrop(event, 'reportCard')" 
                         ondragover="handleDragOver(event, 'reportCardCard')"
                         ondragleave="handleDragLeave(event, 'reportCardCard')">
                        <input type="file" id="reportCardInput" class="file-input" 
                               accept=".jpg,.jpeg,.png,.pdf" 
                               onchange="handleFileSelect(this, 'reportCard')" />
                        
                        <div id="reportCardDefault" class="text-center">
                            <div class="w-16 h-16 bg-slate-100 rounded-full flex items-center justify-center mx-auto mb-4">
                                <i class="fas fa-chart-line text-slate-400 text-2xl"></i>
                            </div>
                            <h4 class="font-semibold text-slate-800 mb-1">Previous Report Card</h4>
                            <p class="text-sm text-slate-500 mb-4">Last year's academic report</p>
                            <div class="flex items-center justify-center space-x-2 text-slate-400">
                                <i class="fas fa-cloud-upload-alt"></i>
                                <span class="text-sm font-medium">Click or drag to upload</span>
                            </div>
                        </div>
                        
                        <div id="reportCardUploaded" class="hidden">
                            <div class="flex items-center space-x-4">
                                <div class="file-type-icon bg-green-100 text-green-600">
                                    <i class="fas fa-file-alt"></i>
                                </div>
                                <div class="flex-1">
                                    <h4 class="font-semibold text-slate-800" id="reportCardFileName">report.pdf</h4>
                                    <p class="text-sm text-green-600"><i class="fas fa-check-circle mr-1"></i>Uploaded successfully</p>
                                </div>
                                <button type="button" onclick="event.stopPropagation(); removeFile('reportCard');" 
                                        class="text-red-500 hover:text-red-700 p-2">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Transfer Certificate (Optional) -->
                    <div class="upload-card optional p-6" id="transferCertCard" 
                         onclick="document.getElementById('transferCertInput').click();"
                         ondrop="handleDrop(event, 'transferCert')" 
                         ondragover="handleDragOver(event, 'transferCertCard')"
                         ondragleave="handleDragLeave(event, 'transferCertCard')">
                        <input type="file" id="transferCertInput" class="file-input" 
                               accept=".jpg,.jpeg,.png,.pdf" 
                               onchange="handleFileSelect(this, 'transferCert')" />
                        
                        <div id="transferCertDefault" class="text-center">
                            <div class="w-16 h-16 bg-slate-100 rounded-full flex items-center justify-center mx-auto mb-4">
                                <i class="fas fa-exchange-alt text-slate-400 text-2xl"></i>
                            </div>
                            <h4 class="font-semibold text-slate-800 mb-1">Transfer Certificate</h4>
                            <p class="text-sm text-slate-500 mb-4">If transferring from another school</p>
                            <div class="flex items-center justify-center space-x-2 text-slate-400">
                                <i class="fas fa-cloud-upload-alt"></i>
                                <span class="text-sm font-medium">Click or drag to upload</span>
                            </div>
                        </div>
                        
                        <div id="transferCertUploaded" class="hidden">
                            <div class="flex items-center space-x-4">
                                <div class="file-type-icon bg-green-100 text-green-600">
                                    <i class="fas fa-file-alt"></i>
                                </div>
                                <div class="flex-1">
                                    <h4 class="font-semibold text-slate-800" id="transferCertFileName">tc.pdf</h4>
                                    <p class="text-sm text-green-600"><i class="fas fa-check-circle mr-1"></i>Uploaded successfully</p>
                                </div>
                                <button type="button" onclick="event.stopPropagation(); removeFile('transferCert');" 
                                        class="text-red-500 hover:text-red-700 p-2">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Skip Notice -->
                    <div class="skip-notice rounded-xl p-4">
                        <div class="flex items-start space-x-3">
                            <i class="fas fa-lightbulb text-amber-600 mt-0.5"></i>
                            <div>
                                <p class="text-sm text-amber-800">
                                    <strong>Don't have all documents right now?</strong> 
                                    No problem! You can skip optional documents and upload them later from your application dashboard.
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
                            Continue to Review
                            <i class="fas fa-arrow-right ml-2"></i>
                        </button>
                    </div>
                </div>
            </div>
        </main>

        <script>
            const uploadedFiles = {
                birthCert: null,
                photo: null,
                reportCard: null,
                transferCert: null
            };

            // Load saved data on page load
            document.addEventListener('DOMContentLoaded', async function() {
                const urlParams = new URLSearchParams(window.location.search);
                const tokenFromUrl = urlParams.get('token');
                if (tokenFromUrl) sessionStorage.setItem('resume_token', tokenFromUrl);

                const token = sessionStorage.getItem('resume_token');
                if (!token) {
                    window.location.href = 'apply-now.aspx';
                    return;
                }

                await loadFromBackend(token);
            });

            async function loadFromBackend(token) {
                try {
                    const res = await fetch('<%= ResolveUrl("~") %>' + 'admission-draft-api.ashx?action=payload&token=' + encodeURIComponent(token));
                    const data = await res.json();
                    if (!data || !data.ok || !data.payload) return;

                    const payload = (typeof data.payload === 'string') ? JSON.parse(data.payload) : data.payload;
                    const docs = (payload && payload.documents) ? payload.documents : [];

                    const map = {
                        'Birth Certificate': 'birthCert',
                        'birthCert': 'birthCert',
                        'Photo': 'photo',
                        'photo': 'photo',
                        'Report Card': 'reportCard',
                        'reportCard': 'reportCard',
                        'Transfer Certificate': 'transferCert',
                        'transferCert': 'transferCert'
                    };

                    (docs || []).forEach(d => {
                        const key = map[d.documentType] || map[(d.documentType || '').toLowerCase()] || null;
                        if (!key) return;
                        uploadedFiles[key] = {
                            name: (d.filePath || '').split('/').pop(),
                            type: (d.filePath || '').toLowerCase().endsWith('.pdf') ? 'application/pdf' : 'image',
                            size: 0,
                            dataUrl: null,
                            filePath: d.filePath
                        };

                        reflectUploadedState(key);
                    });
                } catch { }
            }

            function reflectUploadedState(docType) {
                const fileInfo = uploadedFiles[docType];
                if (!fileInfo) return;

                const card = document.getElementById(docType + 'Card');
                const defaultView = document.getElementById(docType + 'Default');
                const uploadedView = document.getElementById(docType + 'Uploaded');
                const progressView = document.getElementById(docType + 'Progress');

                if (defaultView) defaultView.classList.add('hidden');
                if (progressView) progressView.classList.add('hidden');
                if (uploadedView) uploadedView.classList.remove('hidden');
                if (card) card.classList.add('uploaded');

                const fileNameEl = document.getElementById(docType + 'FileName');
                if (fileNameEl) fileNameEl.textContent = fileInfo.name || 'uploaded';

                if (docType === 'photo' && fileInfo.filePath) {
                    const previewImg = document.getElementById('photoPreview');
                    if (previewImg) previewImg.src = fileInfo.filePath;
                }
            }

            function handleDragOver(e, cardId) {
                e.preventDefault();
                e.stopPropagation();
                document.getElementById(cardId).classList.add('dragover');
            }

            function handleDragLeave(e, cardId) {
                e.preventDefault();
                e.stopPropagation();
                document.getElementById(cardId).classList.remove('dragover');
            }

            function handleDrop(e, docType) {
                e.preventDefault();
                e.stopPropagation();
                document.getElementById(docType + 'Card').classList.remove('dragover');

                const files = e.dataTransfer.files;
                if (files.length > 0) {
                    processFile(files[0], docType);
                }
            }

            function handleFileSelect(input, docType) {
                if (input.files.length > 0) {
                    processFile(input.files[0], docType);
                }
            }

            function processFile(file, docType) {
                if (file.size > 5 * 1024 * 1024) {
                    alert('File size exceeds 5MB limit. Please choose a smaller file.');
                    return;
                }

                const allowedTypes = ['image/jpeg', 'image/png', 'image/jpg', 'application/pdf'];
                if (!allowedTypes.includes(file.type)) {
                    alert('Invalid file type. Please upload JPG, PNG, or PDF files only.');
                    return;
                }

                uploadToBackend(file, docType);
            }

            async function uploadToBackend(file, docType) {
                const card = document.getElementById(docType + 'Card');
                const defaultView = document.getElementById(docType + 'Default');
                const uploadedView = document.getElementById(docType + 'Uploaded');
                const progressView = document.getElementById(docType + 'Progress');

                if (defaultView) defaultView.classList.add('hidden');
                if (uploadedView) uploadedView.classList.add('hidden');
                if (progressView) progressView.classList.remove('hidden');

                const progressBar = progressView ? progressView.querySelector('.upload-progress-bar') : null;
                if (progressBar) progressBar.style.width = '20%';

                const token = sessionStorage.getItem('resume_token');
                if (!token) {
                    alert('Missing token.');
                    return;
                }

                const dataUrl = await readAsDataUrl(file);
                if (progressBar) progressBar.style.width = '60%';

                const docTypeMap = {
                    birthCert: 'Birth Certificate',
                    photo: 'Photo',
                    reportCard: 'Report Card',
                    transferCert: 'Transfer Certificate'
                };

                const payload = {
                    resume_token: token,
                    document: {
                        documentType: docTypeMap[docType] || docType,
                        filePath: dataUrl
                    }
                };

                try {
                    const res = await fetch('<%= ResolveUrl("~") %>' + 'admission-draft-step.ashx?action=uploadDocument', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(payload)
                    });
                    const r = await res.json();
                    if (!r || !r.ok) {
                        alert(r && r.message ? r.message : 'Upload failed');
                        if (card) card.classList.add('error');
                        if (progressView) progressView.classList.add('hidden');
                        if (defaultView) defaultView.classList.remove('hidden');
                        return;
                    }

                    if (progressBar) progressBar.style.width = '100%';

                    setTimeout(() => {
                        if (progressView) progressView.classList.add('hidden');
                        if (uploadedView) uploadedView.classList.remove('hidden');
                        if (card) card.classList.add('uploaded');

                        const fileNameEl = document.getElementById(docType + 'FileName');
                        if (fileNameEl) fileNameEl.textContent = file.name;

                        if (docType === 'photo') {
                            const previewImg = document.getElementById('photoPreview');
                            if (previewImg) previewImg.src = dataUrl;
                        }

                        uploadedFiles[docType] = { name: file.name, type: file.type, size: file.size };
                        updateAutosave();
                    }, 250);
                }
                catch {
                    alert('Unable to reach server.');
                }
            }

            function readAsDataUrl(file) {
                return new Promise((resolve, reject) => {
                    const reader = new FileReader();
                    reader.onload = e => resolve(e.target.result);
                    reader.onerror = () => reject();
                    reader.readAsDataURL(file);
                });
            }

            function removeFile(docType) {
                // UI reset only; full delete endpoint can be added later
                const card = document.getElementById(docType + 'Card');
                const defaultView = document.getElementById(docType + 'Default');
                const uploadedView = document.getElementById(docType + 'Uploaded');
                const progressView = document.getElementById(docType + 'Progress');
                const input = document.getElementById(docType + 'Input');

                if (uploadedView) uploadedView.classList.add('hidden');
                if (progressView) progressView.classList.add('hidden');
                if (defaultView) defaultView.classList.remove('hidden');
                if (card) card.classList.remove('uploaded');
                if (input) input.value = '';

                const previewImg = document.getElementById(docType + 'Preview');
                if (previewImg) previewImg.src = '';

                uploadedFiles[docType] = null;
                updateAutosave();
            }

            function updateAutosave() {
                const indicator = document.getElementById('autosaveStatus');
                indicator.className = 'autosave-indicator text-sm flex items-center saving';
                indicator.innerHTML = '<i class="fas fa-sync fa-spin mr-2"></i><span>Saving...</span>';

                setTimeout(() => {
                    indicator.className = 'autosave-indicator text-sm flex items-center saved';
                    indicator.innerHTML = '<i class="fas fa-check-circle mr-2"></i><span>Draft saved</span>';
                }, 400);
            }

            function goBack() {
                const token = sessionStorage.getItem('resume_token');
                window.location.href = 'application-academic.aspx?token=' + encodeURIComponent(token);
            }

            function proceedToNext() {
                if (!uploadedFiles.birthCert) {
                    alert('Please upload the Birth Certificate to continue.');
                    document.getElementById('birthCertCard').scrollIntoView({ behavior: 'smooth', block: 'center' });
                    return;
                }

                if (!uploadedFiles.photo) {
                    alert('Please upload a Passport Size Photo to continue.');
                    document.getElementById('photoCard').scrollIntoView({ behavior: 'smooth', block: 'center' });
                    return;
                }

                const token = sessionStorage.getItem('resume_token');
                window.location.href = 'application-review.aspx?token=' + encodeURIComponent(token);
            }
        </script>
    </form>
</body>
</html>

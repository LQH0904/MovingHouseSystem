<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn vị kho bãi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }

        .detail-container {
            max-width: 1200px;
            margin: 20px auto;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            position: relative;
        }

        .detail-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #667eea, #764ba2, #f093fb, #f5576c);
        }

        .detail-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px 40px;
            position: relative;
            overflow: hidden;
        }

        .detail-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }

        .detail-title {
            font-size: 32px;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 15px;
            position: relative;
            z-index: 1;
        }

        .detail-title i {
            font-size: 28px;
            opacity: 0.9;
        }

        .detail-content {
            padding: 40px;
        }

        .info-section {
            margin-bottom: 40px;
        }

        .section-title {
            font-size: 20px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e8f4fd;
        }

        .section-title i {
            color: #667eea;
            font-size: 18px;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .detail-item {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 20px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .detail-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            transform: scaleY(0);
            transition: transform 0.3s ease;
        }

        .detail-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border-color: #667eea;
        }

        .detail-item:hover::before {
            transform: scaleY(1);
        }

        .detail-label {
            font-weight: 600;
            color: #4a5568;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .detail-label i {
            color: #667eea;
            font-size: 12px;
        }

        .detail-value {
            color: #2d3748;
            font-size: 16px;
            font-weight: 500;
            word-wrap: break-word;
            line-height: 1.5;
        }

        .status-badge {
            padding: 8px 16px;
            border-radius: 25px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .status-pending {
            background: linear-gradient(135deg, #ffeaa7, #fdcb6e);
            color: #d63031;
        }

        .status-approved {
            background: linear-gradient(135deg, #00b894, #00cec9);
            color: white;
        }

        .status-rejected {
            background: linear-gradient(135deg, #e17055, #d63031);
            color: white;
        }

        .images-section {
            background: #f7fafc;
            border-radius: 15px;
            padding: 30px;
            margin: 30px 0;
        }

        .images-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
        }

        .image-item {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
        }

        .image-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .image-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .image-label i {
            color: #667eea;
        }

        .image-container {
            text-align: center;
            position: relative;
        }

        .detail-image {
            max-width: 100%;
            max-height: 200px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .detail-image:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .no-image {
            padding: 40px;
            color: #a0aec0;
            font-style: italic;
            background: #f7fafc;
            border: 2px dashed #e2e8f0;
            border-radius: 8px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
        }

        .no-image i {
            font-size: 24px;
            opacity: 0.5;
        }

        .action-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 2px solid #e8f4fd;
        }

        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 50px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-approve {
            background: linear-gradient(135deg, #00b894, #00cec9);
            color: white;
        }

        .btn-approve:hover {
            background: linear-gradient(135deg, #00a085, #00b7b8);
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(0, 184, 148, 0.3);
        }

        .btn-reject {
            background: linear-gradient(135deg, #e17055, #d63031);
            color: white;
        }

        .btn-reject:hover {
            background: linear-gradient(135deg, #d63031, #c0392b);
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(214, 48, 49, 0.3);
        }

        .btn-back {
            background: linear-gradient(135deg, #636e72, #2d3436);
            color: white;
        }

        .btn-back:hover {
            background: linear-gradient(135deg, #2d3436, #636e72);
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(45, 52, 54, 0.3);
        }

        /* Updated Modal Styles - Perfect Centering */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.6);
                backdrop-filter: blur(5px);
                /* Use flexbox for perfect centering */
                align-items: center;
                justify-content: center;
            }

            .modal.show {
                display: flex !important;
            }

            .modal-content {
                background: white;
                padding: 30px;
                border-radius: 20px;
                width: 90%;
                max-width: 400px;
                text-align: center;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                animation: modalSlideIn 0.3s ease;
                /* Remove margin since flexbox handles centering */
                margin: 0;
            }

            .image-modal-content {
                background: white;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                animation: modalSlideIn 0.3s ease;
                /* Responsive sizing */
                width: 90vw;
                max-width: 800px;
                max-height: 90vh;
                margin: 0;
                display: flex;
                flex-direction: column;
            }

            .modal-image {
                width: 100%;
                height: auto;
                max-height: calc(90vh - 100px); /* Account for footer */
                object-fit: contain;
                display: block;
            }

            .image-modal-footer {
                padding: 20px;
                text-align: center;
                background: #f8fafc;
                flex-shrink: 0;
            }

            @keyframes modalSlideIn {
                from {
                    opacity: 0;
                    transform: scale(0.9) translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: scale(1) translateY(0);
                }
            }

            /* Mobile responsive */
            @media (max-width: 768px) {
                .image-modal-content {
                    width: 95vw;
                    max-height: 95vh;
                    border-radius: 10px;
                }

                .modal-image {
                    max-height: calc(95vh - 80px);
                }

                .image-modal-footer {
                    padding: 15px;
                }

                .modal-content {
                    width: 95%;
                    max-width: 350px;
                    padding: 20px;
                }
            }

        @media (max-width: 768px) {
            .detail-container {
                margin: 10px;
                border-radius: 15px;
            }

            .detail-header {
                padding: 20px;
            }

            .detail-title {
                font-size: 24px;
            }

            .detail-content {
                padding: 20px;
            }

            .detail-grid,
            .images-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .action-buttons {
                flex-direction: column;
                align-items: center;
            }

            .btn {
                width: 100%;
                max-width: 300px;
                justify-content: center;
            }
        }

        .loading {
            opacity: 0.7;
            pointer-events: none;
        }

        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="parent">
        <div class="div1">
            <jsp:include page="/Layout/operator/SideBar.jsp"></jsp:include>
        </div>
        <div class="div2">
            <jsp:include page="/Layout/operator/Header.jsp"></jsp:include>
        </div>
        <div class="div3">
            <div class="detail-container fade-in">
                <div class="detail-header">
                    <h1 class="detail-title">
                        <i class="fas fa-warehouse"></i>
                        Chi tiết đơn vị kho bãi
                    </h1>
                </div>

                <div class="detail-content">
                    <!-- Thông tin cơ bản -->
                    <div class="info-section">
                        <h2 class="section-title">
                            <i class="fas fa-info-circle"></i>
                            Thông tin cơ bản
                        </h2>
                        <div class="detail-grid">
                            <div class="detail-item">
                                <span class="detail-label">
                                    <i class="fas fa-hashtag"></i>
                                    Mã đơn vị
                                </span>
                                <span class="detail-value">${unit.storageUnitId}</span>
                            </div>

                            <div class="detail-item">
                                <span class="detail-label">
                                    <i class="fas fa-user"></i>
                                    Tên người dùng
                                </span>
                                <span class="detail-value">${unit.username}</span>
                            </div>

                            <div class="detail-item">
                                <span class="detail-label">
                                    <i class="fas fa-envelope"></i>
                                    Email
                                </span>
                                <span class="detail-value">${unit.email}</span>
                            </div>

                            <div class="detail-item">
                                <span class="detail-label">
                                    <i class="fas fa-warehouse"></i>
                                    Tên kho
                                </span>
                                <span class="detail-value">${unit.warehouseName}</span>
                            </div>

                            <div class="detail-item">
                                <span class="detail-label">
                                    <i class="fas fa-map-marker-alt"></i>
                                    Địa điểm
                                </span>
                                <span class="detail-value">${unit.location}</span>
                            </div>

                            <div class="detail-item">
                                <span class="detail-label">
                                    <i class="fas fa-expand-arrows-alt"></i>
                                    Diện tích
                                </span>
                                <span class="detail-value">${unit.area} m²</span>
                            </div>

                            <div class="detail-item">
                                <span class="detail-label">
                                    <i class="fas fa-users"></i>
                                    Số nhân viên
                                </span>
                                <span class="detail-value">${unit.employee}</span>
                            </div>

                            <div class="detail-item">
                                <span class="detail-label">
                                    <i class="fas fa-clipboard-check"></i>
                                    Trạng thái đăng ký
                                </span>
                                <span class="detail-value">
                                    <span class="status-badge 
                                        <c:choose>
                                            <c:when test='${unit.registrationStatus == "pending"}'>status-pending</c:when>
                                            <c:when test='${unit.registrationStatus == "approved"}'>status-approved</c:when>
                                            <c:when test='${unit.registrationStatus == "rejected"}'>status-rejected</c:when>
                                        </c:choose>">
                                        <c:choose>
                                            <c:when test='${unit.registrationStatus == "pending"}'>
                                                <i class="fas fa-clock"></i> Chờ duyệt
                                            </c:when>
                                            <c:when test='${unit.registrationStatus == "approved"}'>
                                                <i class="fas fa-check"></i> Đã duyệt
                                            </c:when>
                                            <c:when test='${unit.registrationStatus == "rejected"}'>
                                                <i class="fas fa-times"></i> Từ chối
                                            </c:when>
                                        </c:choose>
                                    </span>
                                </span>
                            </div>

                            <div class="detail-item">
                                <span class="detail-label">
                                    <i class="fas fa-calendar-plus"></i>
                                    Ngày tạo
                                </span>
                                <span class="detail-value">
                                    <fmt:formatDate value="${unit.createdAt}" pattern="HH:mm - dd/MM/yyyy "/>
                                </span>
                            </div>

                            <div class="detail-item">
                                <span class="detail-label">
                                    <i class="fas fa-calendar-edit"></i>
                                    Cập nhật lần cuối
                                </span>
                                <span class="detail-value">
                                    <fmt:formatDate value="${unit.updatedAt}" pattern="HH:mm - dd/MM/yyyy"/>
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Hình ảnh tài liệu -->
                    <div class="info-section">
                        <h2 class="section-title">
                            <i class="fas fa-images"></i>
                            Tài liệu hình ảnh
                        </h2>
                        <div class="images-section">
                            <div class="images-grid">
                                <div class="image-item">
                                    <div class="image-label">
                                        <i class="fas fa-certificate"></i>
                                        Giấy phép kinh doanh
                                    </div>
                                    <div class="image-container">
                                        <c:if test="${not empty unit.businessCertificate}">
                                            <img src="${unit.businessCertificate}" 
                                                 alt="Giấy phép kinh doanh"
                                                 class="detail-image" 
                                                 onclick="openImageModal(this.src, 'Giấy phép kinh doanh')">
                                        </c:if>
                                        <c:if test="${empty unit.businessCertificate}">
                                            <div class="no-image">
                                                <i class="fas fa-image"></i>
                                                <span>Chưa có hình ảnh</span>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>

                                <div class="image-item">
                                    <div class="image-label">
                                        <i class="fas fa-shield-alt"></i>
                                        Bảo hiểm
                                    </div>
                                    <div class="image-container">
                                        <c:if test="${not empty unit.insurance}">
                                            <img src="${unit.insurance}" 
                                                 alt="Bảo hiểm"
                                                 class="detail-image" 
                                                 onclick="openImageModal(this.src, 'Bảo hiểm')">
                                        </c:if>
                                        <c:if test="${empty unit.insurance}">
                                            <div class="no-image">
                                                <i class="fas fa-image"></i>
                                                <span>Chưa có hình ảnh</span>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>

                                <div class="image-item">
                                    <div class="image-label">
                                        <i class="fas fa-map"></i>
                                        Sơ đồ mặt bằng
                                    </div>
                                    <div class="image-container">
                                        <c:if test="${not empty unit.floorPlan}">
                                            <img src="${unit.floorPlan}" 
                                                 alt="Sơ đồ mặt bằng"
                                                 class="detail-image" 
                                                 onclick="openImageModal(this.src, 'Sơ đồ mặt bằng')">
                                        </c:if>
                                        <c:if test="${empty unit.floorPlan}">
                                            <div class="no-image">
                                                <i class="fas fa-image"></i>
                                                <span>Chưa có hình ảnh</span>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Nút hành động -->
                    <div class="action-buttons">
                        <c:if test='${unit.registrationStatus == "pending"}'>
                            <button class="btn btn-approve" onclick="showConfirmModal('approve')">
                                <i class="fas fa-check"></i>
                                Đồng ý
                            </button>
                            <button class="btn btn-reject" onclick="showConfirmModal('reject')">
                                <i class="fas fa-times"></i>
                                Từ chối
                            </button>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/operator/listApplication" class="btn btn-back">
                            <i class="fas fa-arrow-left"></i>
                            Quay lại
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal xác nhận -->
    <div id="confirmModal" class="modal">
        <div class="modal-content">
            <h3 id="modalTitle" class="modal-title">
                <i class="fas fa-question-circle"></i>
                Xác nhận
            </h3>
            <p id="modalMessage" class="modal-message">
                Bạn có chắc chắn muốn thực hiện hành động này?
            </p>
            <div class="modal-buttons">
                <button class="btn btn-approve" onclick="confirmAction()">
                    <i class="fas fa-check"></i>
                    Xác nhận
                </button>
                <button class="btn btn-back" onclick="closeModal()">
                    <i class="fas fa-times"></i>
                    Hủy
                </button>
            </div>
        </div>
    </div>

   <!-- Modal hiển thị hình ảnh -->
        <div id="imageModal" class="modal image-modal">
            <div class="image-modal-content">
                <img id="modalImage" alt="Hình ảnh chi tiết" class="modal-image">
                <div class="image-modal-footer">
                    <h3 id="imageTitle">Hình ảnh</h3>
                    <button class="btn btn-back" onclick="closeImageModal()">Đóng</button>
                </div>
            </div>
        </div>

            <script>
            let currentAction = '';
            let isProcessing = false;
            
            function showConfirmModal(action) {
                currentAction = action;
                const modal = document.getElementById('confirmModal');
                const title = document.getElementById('modalTitle');
                const message = document.getElementById('modalMessage');

                if (action === 'approve') {
                    title.innerHTML = '<i class="fas fa-check-circle"></i> Xác nhận duyệt';
                    message.textContent = 'Bạn có chắc chắn muốn duyệt đơn vị kho bãi này?';
                } else {
                    title.innerHTML = '<i class="fas fa-times-circle"></i> Xác nhận từ chối';
                    message.textContent = 'Bạn có chắc chắn muốn từ chối đơn vị kho bãi này?';
                }

                // Use class instead of style.display
                modal.classList.add('show');
                document.body.style.overflow = 'hidden';
            }
            
            function confirmAction() {
                if (isProcessing) return;
                
                isProcessing = true;
                const confirmBtn = document.getElementById('confirmBtn');
                const loadingSpinner = document.getElementById('loadingSpinner');
                const confirmText = document.getElementById('confirmText');
                
                // Show loading state
                loadingSpinner.style.display = 'inline-block';
                confirmText.textContent = 'Đang xử lý...';
                confirmBtn.disabled = true;
                
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'update-storage-status';
                
                const storageIdInput = document.createElement('input');
                storageIdInput.type = 'hidden';
                storageIdInput.name = 'storage_unit_id';
                storageIdInput.value = '${storageUnit.storage_unit_id}';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = currentAction;
                
                form.appendChild(storageIdInput);
                form.appendChild(actionInput);
                document.body.appendChild(form);
                form.submit();
            }
            
            function closeModal() {
                const modal = document.getElementById('confirmModal');
                modal.classList.remove('show');
                document.body.style.overflow = 'auto';
            }
            
            function openImageModal(src, title) {
                const modal = document.getElementById('imageModal');
                document.getElementById('modalImage').src = src;
                document.getElementById('imageTitle').textContent = title;
                modal.style.display = 'flex'; // Thay đổi từ 'block' thành 'flex'
                document.body.style.overflow = 'hidden';
            }
            
            function closeImageModal() {
                document.getElementById('imageModal').style.display = 'none';
                document.body.style.overflow = 'auto';
            }
            
            // Đóng modal khi click bên ngoài
            window.onclick = function(event) {
                const confirmModal = document.getElementById('confirmModal');
                const imageModal = document.getElementById('imageModal');
                if (event.target === confirmModal) {
                    closeModal();
                }
                if (event.target === imageModal) {
                    closeImageModal();
                }
            }

            // Keyboard navigation
            document.addEventListener('keydown', function(event) {
                if (event.key === 'Escape') {
                    closeModal();
                    closeImageModal();
                }
            });
        </script>
</body>
</html>


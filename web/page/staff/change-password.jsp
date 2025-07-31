<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đổi mật khẩu</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <style>
            :root {
                --primary-color: #4361ee;
                --secondary-color: #3f37c9;
                --success-color: #4cc9f0;
                --danger-color: #f72585;
                --light-color: #f8f9fa;
                --dark-color: #212529;
                --border-radius: 8px;
                --box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                --transition: all 0.3s ease;
            }

            .password-container {
                max-width: 500px;
                margin: 0 auto;
                background: white;
                padding: 2.5rem;
                border-radius: var(--border-radius);
                box-shadow: var(--box-shadow);
                transition: var(--transition);
            }

            .password-container:hover {
                box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
            }

            .password-title {
                color: var(--primary-color);
                text-align: center;
                margin-bottom: 1.5rem;
                font-size: 1.8rem;
                font-weight: 600;
                border-bottom: 1px solid #eee;
                padding-bottom: 0.75rem;
            }

            .form-group {
                margin-bottom: 1.5rem;
                position: relative;
            }

            .form-group label {
                display: block;
                margin-bottom: 0.5rem;
                font-weight: 500;
                color: var(--dark-color);
                font-size: 0.95rem;
            }

            .form-group input {
                width: 100%;
                padding: 0.75rem 1rem;
                border: 1px solid #ddd;
                border-radius: var(--border-radius);
                font-size: 0.95rem;
                transition: var(--transition);
                background-color: var(--light-color);
            }

            .form-group input:focus {
                outline: none;
                border-color: var(--primary-color);
                box-shadow: 0 0 0 2px rgba(67, 97, 238, 0.2);
                background-color: white;
            }

            .password-actions {
                display: flex;
                gap: 1rem;
                margin-top: 2rem;
justify-content: flex-end;
            }

            .password-btn {
                padding: 0.75rem 1.5rem;
                border: none;
                border-radius: var(--border-radius);
                cursor: pointer;
                font-weight: 600;
                font-size: 0.95rem;
                transition: var(--transition);
                text-align: center;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }

            .password-btn i {
                margin-right: 0.5rem;
            }

            .btn-primary {
                background-color: var(--primary-color);
                color: white;
            }

            .btn-primary:hover {
                background-color: var(--secondary-color);
                transform: translateY(-2px);
            }

            .btn-secondary {
                background-color: white;
                color: var(--primary-color);
                border: 1px solid var(--primary-color);
            }

            .btn-secondary:hover {
                background-color: #f0f2f5;
                transform: translateY(-2px);
            }

            .password-strength {
                margin-top: 0.5rem;
                height: 6px;
                background-color: #e9ecef;
                border-radius: 3px;
                overflow: hidden;
            }

            .strength-meter {
                height: 100%;
                width: 0;
                transition: width 0.3s ease;
            }

            .password-requirements {
                margin-top: 1rem;
                font-size: 0.85rem;
                color: #6c757d;
            }

            .password-requirements ul {
                padding-left: 1.25rem;
                margin-bottom: 0;
            }

            .password-requirements li {
                margin-bottom: 0.25rem;
            }

            .requirement-met {
                color: #28a745;
            }

            .requirement-not-met {
                color: #dc3545;
            }

            .empty-field-error {
                color: #dc3545;
                font-size: 0.85rem;
                margin-top: 0.25rem;
                display: none;
            }

            .toast {
                transition: opacity 0.5s ease;
            }
            .toast.show {
                display: block;
                opacity: 1;
            }

            @media (max-width: 768px) {
                .password-container {
                    padding: 1.5rem;
                }

                .password-actions {
                    flex-direction: column;
                }

                .password-btn {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="parent">
            <div class="div1">
<jsp:include page="../../Layout/staff/SideBar.jsp"></jsp:include>
                </div>
                <div class="div2">
                <jsp:include page="../../Layout/staff/Header.jsp"></jsp:include>
                </div>
                <div class="div3 p-4">
                    <div class="password-container">
                        <h1 class="password-title">
                            <i class="bi bi-shield-lock"></i> Đổi mật khẩu
                        </h1>

                        <form action="${pageContext.request.contextPath}/profile" method="post" id="passwordForm">
                        <input type="hidden" name="action" value="updatePassword">

                        <div class="form-group">
                            <label for="oldPassword">
                                <i class="bi bi-key-fill"></i> Mật khẩu hiện tại
                            </label>
                            <input type="password" id="oldPassword" name="oldPassword" required>
                            <div class="empty-field-error" id="oldPasswordError">Vui lòng nhập mật khẩu hiện tại</div>
                        </div>

                        <div class="form-group">
                            <label for="newPassword">
                                <i class="bi bi-key"></i> Mật khẩu mới
                            </label>
                            <input type="password" id="newPassword" name="newPassword" required>
                            <div class="empty-field-error" id="newPasswordError">Vui lòng nhập mật khẩu mới</div>
                            <div class="password-strength">
                                <div class="strength-meter" id="passwordMeter"></div>
                            </div>
                            <div class="password-requirements">
                                <p>Mật khẩu phải đáp ứng các yêu cầu sau:</p>
                                <ul>
                                    <li id="req-length" class="requirement-not-met">Ít nhất 8 ký tự</li>
                                    <li id="req-uppercase" class="requirement-not-met">Ít nhất 1 chữ hoa</li>
                                    <li id="req-number" class="requirement-not-met">Ít nhất 1 số</li>
                                    <li id="req-special" class="requirement-not-met">Ít nhất 1 ký tự đặc biệt</li>
                                </ul>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">
                                <i class="bi bi-key-fill"></i> Xác nhận mật khẩu mới
                            </label>
                            <input type="password" id="confirmPassword" name="confirmPassword" required>
                            <div class="empty-field-error" id="confirmPasswordError">Vui lòng xác nhận mật khẩu mới</div>
<div id="passwordMatch" style="margin-top: 0.5rem; font-size: 0.85rem;"></div>
                        </div>

                        <div class="password-actions">
                            <a href="${pageContext.request.contextPath}/profile" class="password-btn btn-secondary">
                                <i class="bi bi-x-circle"></i> Hủy bỏ
                            </a>
                            <button type="submit" class="password-btn btn-primary" id="submitBtn" disabled>
                                <i class="bi bi-check-circle"></i> Đổi mật khẩu
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            const newPassword = document.getElementById('newPassword');
            const confirmPassword = document.getElementById('confirmPassword');
            const passwordMeter = document.getElementById('passwordMeter');
            const submitBtn = document.getElementById('submitBtn');

            const reqLength = document.getElementById('req-length');
            const reqUppercase = document.getElementById('req-uppercase');
            const reqNumber = document.getElementById('req-number');
            const reqSpecial = document.getElementById('req-special');
            const passwordMatch = document.getElementById('passwordMatch');

            newPassword.addEventListener('input', function () {
                const password = this.value;

                const hasLength = password.length >= 8;
                const hasUppercase = /[A-Z]/.test(password);
                const hasNumber = /\d/.test(password);
                const hasSpecial = /[^A-Za-z0-9]/.test(password);

                reqLength.className = hasLength ? 'requirement-met' : 'requirement-not-met';
                reqUppercase.className = hasUppercase ? 'requirement-met' : 'requirement-not-met';
                reqNumber.className = hasNumber ? 'requirement-met' : 'requirement-not-met';
                reqSpecial.className = hasSpecial ? 'requirement-met' : 'requirement-not-met';

                let strength = 0;
                if (password.length > 0)
                    strength += 20;
                if (hasLength)
                    strength += 30;
                if (hasUppercase)
                    strength += 20;
                if (hasNumber)
                    strength += 20;
                if (hasSpecial)
                    strength += 10;

                passwordMeter.style.width = strength + '%';

                if (strength < 50) {
                    passwordMeter.style.backgroundColor = '#ef233c';
                } else if (strength < 80) {
                    passwordMeter.style.backgroundColor = '#ffbe0b';
                } else {
passwordMeter.style.backgroundColor = '#06d6a0';
                }

                checkPasswordsMatch();
            });

            confirmPassword.addEventListener('input', checkPasswordsMatch);

            function checkPasswordsMatch() {
                const password = newPassword.value;
                const confirm = confirmPassword.value;

                if (password && confirm) {
                    if (password === confirm) {
                        passwordMatch.innerHTML = '<span style="color:#28a745;"><i class="bi bi-check-circle-fill"></i> Mật khẩu khớp</span>';
                        submitBtn.disabled = false;
                    } else {
                        passwordMatch.innerHTML = '<span style="color:#dc3545;"><i class="bi bi-exclamation-circle-fill"></i> Mật khẩu không khớp</span>';
                        submitBtn.disabled = true;
                    }
                } else {
                    passwordMatch.innerHTML = '';
                    submitBtn.disabled = true;
                }
            }

            document.getElementById('submitBtn').addEventListener('click', function (e) {
                const oldPassword = document.getElementById('oldPassword').value;
                const newPass = document.getElementById('newPassword').value;
                const confirmPass = document.getElementById('confirmPassword').value;
                let isValid = true;

                if (!oldPassword) {
                    document.getElementById('oldPasswordError').style.display = 'block';
                    isValid = false;
                }

                if (!newPass) {
                    document.getElementById('newPasswordError').style.display = 'block';
                    isValid = false;
                }

                if (!confirmPass) {
                    document.getElementById('confirmPasswordError').style.display = 'block';
                    isValid = false;
                }

                if (!isValid) {
                    e.preventDefault();

                    const toastHTML = `
                        <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
                            <div class="toast show" role="alert" aria-live="assertive" aria-atomic="true">
                                <div class="toast-header bg-danger text-white">
                                    <strong class="me-auto">Lỗi</strong>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
                                </div>
                                <div class="toast-body">
                                    <i class="bi bi-exclamation-triangle-fill me-2"></i>Vui lòng nhập đầy đủ thông tin mật khẩu
                                </div>
                            </div>
                        </div>
                    `;
document.body.insertAdjacentHTML('beforeend', toastHTML);

                    setTimeout(() => {
                        const toast = document.querySelector('.toast');
                        if (toast) {
                            toast.classList.remove('show');
                            setTimeout(() => toast.remove(), 500);
                        }
                    }, 3000);

                    if (!oldPassword) {
                        document.getElementById('oldPassword').focus();
                    } else if (!newPass) {
                        document.getElementById('newPassword').focus();
                    } else if (!confirmPass) {
                        document.getElementById('confirmPassword').focus();
                    }
                }
            });

            document.getElementById('oldPassword').addEventListener('input', function () {
                if (this.value) {
                    document.getElementById('oldPasswordError').style.display = 'none';
                }
            });

            document.getElementById('newPassword').addEventListener('input', function () {
                if (this.value) {
                    document.getElementById('newPasswordError').style.display = 'none';
                }
            });

            document.getElementById('confirmPassword').addEventListener('input', function () {
                if (this.value) {
                    document.getElementById('confirmPasswordError').style.display = 'none';
                }
            });
        </script>
    </body>
</html>

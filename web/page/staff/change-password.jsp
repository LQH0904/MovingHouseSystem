<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đổi mật khẩu</title>
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

            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f0f2f5;
                color: var(--dark-color);
                line-height: 1.6;
                padding: 0;
                margin: 0;
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .form-container {
                width: 100%;
                max-width: 480px;
                background: white;
                padding: 2.5rem;
                border-radius: var(--border-radius);
                box-shadow: var(--box-shadow);
                transition: var(--transition);
                margin: 1rem;
            }

            .form-container:hover {
                box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
            }

            h1 {
                color: var(--primary-color);
                text-align: center;
                margin-bottom: 1.5rem;
                font-size: 1.8rem;
                font-weight: 600;
            }

            .form-group {
                margin-bottom: 1.25rem;
                position: relative;
            }

            label {
                display: block;
                margin-bottom: 0.5rem;
                font-weight: 500;
                color: var(--dark-color);
                font-size: 0.9rem;
            }

            input {
                width: 100%;
                padding: 0.75rem 1rem;
                border: 1px solid #ddd;
                border-radius: var(--border-radius);
                font-size: 0.95rem;
                transition: var(--transition);
                background-color: var(--light-color);
            }

            input:focus {
                outline: none;
                border-color: var(--primary-color);
                box-shadow: 0 0 0 2px rgba(67, 97, 238, 0.2);
                background-color: white;
            }

            .btn-group {
                display: flex;
                gap: 1rem;
                margin-top: 1.5rem;
            }

            .btn {
                padding: 0.75rem 1.5rem;
                border: none;
                border-radius: var(--border-radius);
                cursor: pointer;
                font-weight: 600;
                font-size: 0.95rem;
                transition: var(--transition);
                flex: 1;
                text-align: center;
                text-decoration: none;
                display: inline-block;
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
                height: 4px;
                background-color: #e9ecef;
                border-radius: 2px;
                overflow: hidden;
            }

            .strength-meter {
                height: 100%;
                width: 0;
                transition: width 0.3s ease;
            }

            @media (max-width: 576px) {
                .form-container {
                    padding: 1.5rem;
                }

                .btn-group {
                    flex-direction: column;
                }
            }
        </style>
    </head>
    <body>
        <div class="form-container">
            <h1>Đổi mật khẩu</h1>

            <form action="http://localhost:9999/HouseMovingSystem/profile" method="post">
                <input type="hidden" name="action" value="updatePassword">

                <div class="form-group">
                    <label for="oldPassword">Mật khẩu hiện tại</label>
                    <input type="password" id="oldPassword" name="oldPassword" required>
                </div>

                <div class="form-group">
                    <label for="newPassword">Mật khẩu mới</label>
                    <input type="password" id="newPassword" name="newPassword" required>
                    <div class="password-strength">
                        <div class="strength-meter" id="passwordMeter"></div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Xác nhận mật khẩu mới</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">Đổi mật khẩu</button>
                    <a href="http://localhost:9999/HouseMovingSystem/profile" class="btn btn-secondary">Hủy bỏ</a>
                </div>
            </form>
        </div>

        <script>
            // Simple password strength indicator
            document.getElementById('newPassword').addEventListener('input', function (e) {
                const password = e.target.value;
                const meter = document.getElementById('passwordMeter');
                let strength = 0;

                if (password.length > 0)
                    strength += 20;
                if (password.length >= 8)
                    strength += 30;
                if (/[A-Z]/.test(password))
                    strength += 20;
                if (/\d/.test(password))
                    strength += 20;
                if (/[^A-Za-z0-9]/.test(password))
                    strength += 10;

                meter.style.width = strength + '%';

                if (strength < 50) {
                    meter.style.backgroundColor = '#ef233c';
                } else if (strength < 80) {
                    meter.style.backgroundColor = '#ffbe0b';
                } else {
                    meter.style.backgroundColor = '#06d6a0';
                }
            });
        </script>
    </body>
</html>
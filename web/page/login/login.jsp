<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../../Layout/Login/head.jsp" />

<!DOCTYPE html>
<html lang="en">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
        <style>
            .left-section {
                flex: 1;
                background: url('img/bgr.jpg') center center / cover no-repeat;
                position: relative;
                color: white;
                padding: 30px;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .overlay {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.4);
                z-index: 1;
                border-radius: 30px 0 0 30px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <!-- Left Section -->
            <div class="left-section">
                <div class="left-header">
                    <span>Work for Day</span>
                    <div class="buttons">
                        <button onclick="location.href = 'login'">Sign In</button>
                        <button onclick="location.href = 'home.jsp'">Home</button>
                    </div>
                </div>
            </div>

            <!-- Right Section -->
            <div class="right-section">
                <p class="logo">Welcome to Website</p>

                <% String mess = (String) request.getAttribute("mess"); %>
                <% if (mess != null) { %>
                <p style="color: red; font-weight: bold;"><%= mess %></p>
                <% } %>


                <form action="login" method="post">
                    <div class="form-group">
                        <input type="text" name="email" required />
                        <label>Email</label>
                    </div>
                    <div class="form-group">
                        <input type="password" name="password" required />
                        <label>Password</label>
                    </div>

                    <a href="forgot" class="forgot-password">Forgot password?</a>
                    <div class="or-divider">— or —</div>

                    <button type="button" class="google-login"
                            onclick="window.location.href = 'https://accounts.google.com/o/oauth2/auth?scope=email profile openid&redirect_uri=http://localhost:8080/HouseMovingSystem/LoginGoogleServlet&response_type=code&client_id=820713583757-asdgtkcasbf9maf6uvu91kpc67k5d418.apps.googleusercontent.com&approval_prompt=force'">
                        <img src="https://developers.google.com/identity/images/g-logo.png" alt="Google Logo" />
                        Login with Google
                    </button>

                    <button type="submit" class="login-btn">Login</button>
                </form>
            </div>
        </div>
    </body>
</html>

<script>
    document.querySelector("form").addEventListener("submit", function (e) {
        const email = this.querySelector("input[name='email']").value;
        const password = this.querySelector("input[name='password']").value;

        if (email.trim() === "" || password.trim() === "") {
            e.preventDefault();
            this.classList.add("shake");
            setTimeout(() => this.classList.remove("shake"), 500);
        }
    });
</script>
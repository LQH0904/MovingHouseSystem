<%-- 
    Document   : newpassword
    Created on : May 31, 2025, 1:30:04 AM
    Author     : admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="layout/pass.jsp"/>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>New Password</title>
        <style>
            i#iconsee:hover {
                color: rgba(0, 0, 0, 0.5);
                cursor: pointer;
            }
            h2{
                color: #111
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Choose a new password</h2>
            <p id="rule">A strong password is a combination of letters and punctuation marks. It must be at least 6 characters long.</p>

            <form id="f1" action="confirmpass" method="post">
                <input type="hidden" name="email" value="${resetUsername}" />

                <div class="input-group">
                    <input id="pass1" type="password" name="password" placeholder="New password" required minlength="6" />
                    <i class="fa-solid fa-eye-slash" onclick="togglePasswordVisibility('pass1', this)"></i>
                </div>

                <div class="input-group">
                    <input id="pass2" type="password" name="cfpassword" placeholder="Confirm new password" required minlength="6" />
                    <i class="fa-solid fa-eye-slash" onclick="togglePasswordVisibility('pass2', this)"></i>
                </div>

                <c:if test="${not empty error}">
                    <p style="background-color: #e74c3c; color: #ffffff; font-weight: bold; padding: 12px 20px; border-radius: 8px; margin: 10px 0; text-align: center; box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);">
                        ${error}
                    </p>
                </c:if>

                <c:if test="${not empty successfully}">
                    <p class="message success">${successfully}</p>
                </c:if>

                <button type="submit">Continue</button>
            </form>
        </div>

        <script>
            function togglePasswordVisibility(inputId, iconElement) {
                const input = document.getElementById(inputId);
                const isPassword = input.type === 'password';
                input.type = isPassword ? 'text' : 'password';
                iconElement.classList.toggle('fa-eye');
                iconElement.classList.toggle('fa-eye-slash');
            }
        </script>
    </body>
</html>


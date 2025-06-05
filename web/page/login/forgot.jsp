<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../../Layout/Login/pass.jsp"/>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>Forgot Password</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
    </head>
    <body>
        <a href="login" class="btn btn-secondary back-button">← Back to Login</a>

        <div class="container mt-5">
            <h2 style="color: darkred;">Forgot Password</h2>

            <!-- Step 1: Enter email -->
            <c:if test="${empty requestScope.step || requestScope.step == 'enterEmail'}">
                <p>Please enter your email to recover your password</p>
                <form action="forgot" method="post">
                    <div class="form-group">
                        <input type="email" name="email" placeholder="Email Address" required
                               value="${requestScope.email != null ? requestScope.email : ''}" class="form-control" />
                    </div>
                    <button type="submit" class="btn btn-primary">Send Reset Code</button>
                </form>
                <c:if test="${not empty requestScope.message}">
                    <p class="message mt-3" style="color: red; font-size: 1.25rem; font-weight: bold; padding: 10px 15px; border-radius: 5px;">
                        ${requestScope.message}
                    </p>
                </c:if>
            </c:if>

            <!-- Step 2: Enter code -->
            <c:if test="${requestScope.step == 'enterCode'}">
                <p>A reset code has been sent to your email:</p>
                <p><strong>${requestScope.email}</strong></p>
                <form action="confirmresetcode" method="post">
                    <input type="hidden" name="email" value="${requestScope.email}" />
                    <div class="form-group">
                        <input type="text" name="resetcode" placeholder="Enter reset code" required
                               value="${requestScope.code != null ? requestScope.code : ''}" class="form-control" />
                    </div>
                    <button type="submit" class="btn btn-success">Confirm Reset Code</button>
                </form>
                <c:if test="${not empty requestScope.message}">
                    <p class="message mt-3" style="color: red; font-size: 1.25rem; font-weight: bold; padding: 10px 15px; border-radius: 5px;">
                        ${requestScope.message}
                    </p>
                </c:if>
            </c:if>


        </div>
    </body>
</html>

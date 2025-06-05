
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<head>
    <meta charset="utf-8" />
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="keywords" content="" />
    <meta name="description" content="" />
    <meta property="og:title" content="" />
    <meta property="og:description" content="" />
    <meta property="og:site_name" content="" />
    <meta property="og:type" content="website" />
    <meta property="og:locale" content="vi_VN" />
    <link href="assets/css/changepass.css" rel="stylesheet" type="text/css" />

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        @media not all and (min-resolution:.001dpcm)
        {
            @supports (-webkit-appearance:none) {

                .safari_only {

                    color:#0000FF;
                    background-color:#CCCCCC;

                }
            }
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
        <c:if test="${alert != null}">
            toastr.${alert}('${message}.', 'Thông báo', {timeOut: 5000})
        </c:if>
        });
    </script>
</head>

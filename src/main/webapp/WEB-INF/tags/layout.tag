<%@ tag description="Main layout wrapper" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="activeMenu" required="false" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title} | TutorHub</title>
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/layout/header.jsp">
        <jsp:param name="activeMenu" value="${activeMenu}"/>
    </jsp:include>
    
    <main class="main-content">
        <jsp:doBody/>
    </main>
    
    <jsp:include page="/includes/footer.jsp"/>
    
    <script src="<c:url value='/js/main.js'/>"></script>
</body>
</html>

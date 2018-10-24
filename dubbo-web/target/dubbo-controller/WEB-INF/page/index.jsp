<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>ceshi</title>
</head>
<body>
<table border="1">
    <tr>
        <td>id</td>
        <td>姓名</td>
        <td>密码</td>
        <td>性别</td>
        <td>昵称</td>
    </tr>
    <c:forEach items="${userList}" var="user">
        <tr>
            <td> ${user.id}</td>
            <td> ${user.userName}</td>
            <td> ${user.passWord}</td>
            <td> ${user.userSex}</td>
            <td> ${user.nickName}</td>
        </tr>
    </c:forEach>
</table>


</html>

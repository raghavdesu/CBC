<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="configurations" required="true" type="java.util.ArrayList" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:forEach var="configuration" items="${configurations}">
    ${configuration.configurationValue}
</c:forEach>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ attribute name="inputValue" required="false" type="java.lang.String" %>
<%@ attribute name="inputDatePattern" required="false" type="java.lang.String" %>
<%@ attribute name="outputDatePattern" required="false" type="java.lang.String" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:parseDate value="${inputValue}" type="date" pattern="${inputDatePattern}" var="dateValue" parseLocale="true" />
<fmt:formatDate value="${dateValue}" type="date" pattern="${outputDatePattern}" />
<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="rawValue" required="false" type="java.lang.String" %>
<%@ attribute name="targetFormatKey" required="false" type="java.lang.String" %>
<%@ attribute name="valueKeyPrefix" required="false" type="java.lang.String" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="formatter" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/format" %>

<spring:htmlEscape defaultHtmlEscape="true"/>

<%--
 Tag to render a value in specific format provided or fallback to raw value in case of unsupported format
--%>
<spring:theme code="${targetFormatKey}" var="targetFormat"/>
<c:choose>
    <c:when test="${targetFormat eq 'currency'}">
        <fmt:formatNumber value="${rawValue}" type="currency" currencySymbol="${fn:escapeXml(currentCurrency.symbol)}"/>
    </c:when>
    <c:when test="${targetFormat eq 'number'}">
        <fmt:formatNumber value="${rawValue}" type="number" minFractionDigits="2"/>
    </c:when>
    <c:when test="${targetFormat eq 'date'}">
        <formatter:stringToDate inputValue="${rawValue}" inputDatePattern="yyyy-MM-dd" outputDatePattern="dd-MM-yyyy"/>
    </c:when>
    <c:otherwise>
        <spring:theme code="${valueKeyPrefix}.${rawValue}" text="${rawValue}"/>
    </c:otherwise>
</c:choose>
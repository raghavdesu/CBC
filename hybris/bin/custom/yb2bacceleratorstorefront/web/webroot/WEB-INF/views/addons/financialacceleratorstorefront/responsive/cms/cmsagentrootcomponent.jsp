<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="agent" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/agent"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true"/>

<c:choose>
	<c:when test="${isActiveCategory}">
		<c:set var="activeClass" value="active"/>
		<c:set var="openedClass" value="opened"/>
	</c:when>
	<c:otherwise>
		<c:set var="activeClass" value=""/>
		<c:set var="openedClass" value=""/>
	</c:otherwise>
</c:choose>
<h2 class="category__caption js-category-caption ${activeClass}">
	<span class="category__image"><img class="images__size" src="${fn:escapeXml(category.image.url)}" alt=""></span>${fn:escapeXml(category.name)}
</h2>
<div class="category__content js-category-content ${openedClass}">
	<c:forEach items="${agents}" var="person">
		<agent:agentInfo agent="${person}"/>
	</c:forEach>
</div>

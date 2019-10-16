<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<div id="converageConntent">

	<c:if test="${isSessionExpires eq 'true'}">
		<div id="isSessionExpires">${fn:escapeXml(isSessionExpires)}</div>
	</c:if>
	
	<cms:component component="${component}" evaluateRestriction="true"/>
	
</div>
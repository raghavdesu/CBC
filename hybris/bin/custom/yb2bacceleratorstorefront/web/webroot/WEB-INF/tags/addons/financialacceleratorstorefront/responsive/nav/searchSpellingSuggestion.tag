<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="spellingSuggestion" required="true" type="de.hybris.platform.commerceservices.search.facetdata.SpellingSuggestionData" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true"/>

<c:if test="${not empty spellingSuggestion}">
	<div class="searchSpellingSuggestionPrompt">
		<c:url value="${spellingSuggestion.query.url}" var="spellingSuggestionQueryUrl"/>
		<spring:theme code="search.spellingSuggestion.prompt" />&nbsp;<a class="mean-link" href="${fn:escapeXml(spellingSuggestionQueryUrl)}">${fn:escapeXml(spellingSuggestion.suggestion)}?</a>
	</div>
</c:if>

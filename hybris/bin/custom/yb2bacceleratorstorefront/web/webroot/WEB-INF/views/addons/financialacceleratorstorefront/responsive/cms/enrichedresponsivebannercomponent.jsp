<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>

<c:forEach items="${medias}" var="media">
	<c:choose>
		<c:when test="${empty imagerData}">
			<c:set var="imagerData">"${media.width}":"${media.url}"</c:set>
		</c:when>
		<c:otherwise>
			<c:set var="imagerData">${imagerData},"${media.width}":"${media.url}"</c:set>
		</c:otherwise>
	</c:choose>
	<c:if test="${empty altText}">
		<c:set var="altText" value="${fn:escapeXml(media.altText)}"/>
	</c:if>
</c:forEach>

<c:url value="${fn:escapeXml(urlLink)}" var="encodedUrl" />

<div class="enriched-banner">
	<c:if test="${not empty medias}">
		<div class="image-wrapper">
			<img class="responsive-image js-responsive-image"  data-media='{${imagerData}}' alt='${altText}' title='${altText}' style="">
		</div>
	</c:if>
	<div class="enriched-banner__text">
		<c:if test="${not empty headingText}">
			<span class="enriched-banner__title">${ycommerce:sanitizeHTML(headingText)}</span>
		</c:if>
		<c:if test="${not empty styledText}">
			<span class="enriched-banner__details">
				<a class="enriched-banner__styled-text" href="${encodedUrl}">${ycommerce:sanitizeHTML(styledText)}</a>
			</span>
		</c:if>
	</div>
</div>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:htmlEscape defaultHtmlEscape="true"/>

<div class="homepage-banner">
	<div class="homepage-banner__headline">${title}</div>
	<jsp:useBean id="random" class="java.util.Random" scope="application"/>
	<c:set var="randomNumber" value="${random.nextInt(fn:length(banners))}"/>
	<c:set var="banner" value="${banners[randomNumber]}"/>
	<c:if test="${ycommerce:evaluateRestrictions(banner)}">
		<c:url value="${banner.urlLink}" var="encodedUrl"/>
		<div class="homepage-banner__item">
			<c:if test="${not empty banner.urlLink}"> <a href="${banner.urlLink}"> </c:if>
				<img src="${banner.media.url}"
					 alt="${not empty banner.media.altText ? banner.media.altText : banner.media.headline}"
					 title="${not empty banner.media.altText ? banner.media.altText : banner.headline}"/>

				<div class="homepage-banner__item-title">
					<span class="title">
						<strong>${fn:escapeXml(banner.headline)}</strong>
					 </span>
					<span class="details">
							${ycommerce:sanitizeHTML(banner.content)}
					</span>
				</div>
			<c:if test="${not empty banner.urlLink}"> </a> </c:if>
		</div>
	</c:if>
</div>

<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:choose>
	<c:when test="${not empty component.url}">
		<spring:url var="productUrl" value="${component.url}" htmlEscape="false" />
	</c:when>
	<c:otherwise>
		<spring:url var="productUrl" value="${product.url}" htmlEscape="false" />
	</c:otherwise>
</c:choose>

<div class="product product-feature__wrapper product-feature__${fn:toLowerCase(fn:escapeXml(product.code))}">
	<h3 class="product-feature__title section-header__heading">${not empty component.title ? fn:escapeXml(component.title) : fn:escapeXml(product.name)}</h3>
	<div class="product-feature__image">
		<c:if test="${not empty component.media.url}">
			<a href="${productUrl}">
				<img title="${not empty component.title ? fn:escapeXml(component.title) : fn:escapeXml(product.name)}" alt="${not empty component.title ?fn:escapeXml(component.title) : fn:escapeXml(product.name)}" src="${component.media.url}">
			</a>
		</c:if>
		<c:if test="${empty component.media.url}">
			<c:if test="${not empty ycommerce:productImage(product, '96Wx96H')}">
				<a href="${productUrl}">
					<product:productPrimaryImage product="${product}" format="96Wx96H"/>
				</a>
			</c:if>
		</c:if>
	</div>
	<ul class="product-feature__details">${ycommerce:sanitizeHTML(product.summary)}</ul>
</div>

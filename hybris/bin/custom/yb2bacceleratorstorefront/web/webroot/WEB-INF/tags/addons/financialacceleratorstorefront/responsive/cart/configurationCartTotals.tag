<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="priceData" type="de.hybris.platform.commercefacades.product.data.PriceData" %>
<%@ attribute name="configuredProducts" type="java.util.List<de.hybris.platform.commercefacades.product.data.ProductData>" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<div id="orderTotals" class="short-overview__item short-overview__item--highlighted">
    <span class="short-overview__item-name col-xs-6">
        <c:if test="${not empty configuredProducts}">
        	<c:set var="categoryCode" value="${configuredProducts[0].defaultCategory.code}"/>
        	<spring:theme code="basket.page.totals.total.${fn:toLowerCase(cmsSite.channel)}" var="defaultTotalText"/>
        	<spring:theme code="basket.page.totals.total.${fn:toLowerCase(cmsSite.channel)}.${categoryCode}" text="${defaultTotalText}"/>&nbsp;
        </c:if>
    </span>
    <span class="short-overview__item-price col-xs-6">
        <ycommerce:testId code="cart_totalPrice_label">
            <format:price priceData="${priceData}"/>
        </ycommerce:testId>
    </span>
</div>
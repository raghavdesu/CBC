<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="configuredProducts" type="java.util.List<de.hybris.platform.commercefacades.product.data.ProductData>" %>
<%@ attribute name="cartTitle" type="java.lang.String" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="financialCart" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/cart" %>
<%@ taglib prefix="formatter" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/format" %>

<spring:htmlEscape defaultHtmlEscape="true"/>

<c:choose>
    <c:when test="${not empty configuredProducts}">
        <div class="short-overview__heading">
            <spring:theme code="checkout.multi.quoteReview.title.${fn:toLowerCase(cmsSite.channel)}" text="Title {0}" arguments="${configuredProducts[0].defaultCategory.name}"/>
        </div>
        <div id="desktop-spinner" class="spinner spinner--desktop js-spinner"></div>
        <div class="short-overview__items">
                <!-- Product Configuration Values -->
                <c:if test="${not empty configurationDetails}">
                    <c:forEach items="${configurationDetails}" var="configDetail">
                        <div class="short-overview__item">
                            <span class="short-overview__item-name col-xs-7">
                                <spring:theme code="checkout.text.configuration.label.${configDetail.key}" text="${configDetail.key}"/>
                            </span>
                            <span class="short-overview__item-price col-xs-5">
                                <formatter:propertyValueFormatter targetFormatKey="checkout.text.configuration.format.${configDetail.key}" valueKeyPrefix="checkout.text.configuration.value.${configDetail.key}" rawValue="${configDetail.value}"/>
                            </span>
                        </div>
                    </c:forEach>
                </c:if>
                <!-- END - Product Configuration Values -->

                <c:forEach items="${configuredProducts}" var="product" varStatus="status">
                    <div class="short-overview__item">
                        <span class="short-overview__item-name col-xs-7">
                            ${fn:escapeXml(product.name)}:
                        </span>
                        <span class="short-overview__item-price col-xs-5">
                            <c:if test="${not empty product.price.oneTimeChargeEntries}">
                                <c:set var="payNow" value="${product.price.oneTimeChargeEntries[0].price}"/>
                            </c:if>
                            <c:if test="${status.first}">
                                <format:price priceData="${payNow}" displayFreeForZero="false"/>
                            </c:if>
                            <c:if test="${!status.first}">
                                <formatter:priceAndFrequency priceData="${payNow}" productData="${product}" displayFreeForZero="false" displayFrequency="false"/>
                            </c:if>
                        </span>
                    </div>
                </c:forEach>
            </div>
    </c:when>
    <c:otherwise>
        <div class="short-overview__heading">
            <spring:theme code="checkout.multi.quoteReview.title.${fn:toLowerCase(cmsSite.channel)}" text="Application/Quote {0}" arguments="${cartTitle}"/>
        </div>
        <div id="desktop-spinner" class="spinner spinner--desktop js-spinner"></div>
        <div class="short-overview__items">

                <div class="short-overview__item">
                    <span class="short-overview__item-name col-xs-12"><spring:theme code="checkout.cart.empty.text" text="Configure the product"/></span>
                </div>
            </div>
    </c:otherwise>
</c:choose>
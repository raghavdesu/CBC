<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="orderData" required="true" type="de.hybris.platform.commercefacades.order.data.OrderData" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="financialCart" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/cart" %>
<%@ attribute name="displayChangeOptionLink" required="false" type="java.lang.Boolean" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<div id="checkoutOrderDetails" class="short-overview short-overview--right">
    <div class="short-overview__content">
        <div class="section-header__heading">
            <spring:theme code="checkout.orderConfirmation.my.quote" text="My Quote"/>
        </div>
        <div class="short-overview__items">
            <div class="short-overview__item">
                <span class="short-overview__item-name col-xs-7"><spring:theme code="checkout.orderConfirmation.my.quote.number" text="My Quote Number"/>:</span>
                <span class="short-overview__item-price col-xs-5">
                    ${fn:escapeXml(orderData.insuranceQuote.quoteId)}
                </span>
            </div>
            <div class="short-overview__item">
                <span class="short-overview__item-name col-xs-7"> <spring:theme code="checkout.orderConfirmation.payment.frequency"/>:</span>
                <span class="short-overview__item-price col-xs-5">${orderData.insuranceQuote.paymentFrequency}</span>
            </div>
            <div class="short-overview__item">
                <span class="short-overview__item-name col-xs-7"><spring:theme code="checkout.orderConfirmation.policy.start.date"/>: </span>
                <span class="short-overview__item-price col-xs-5"> ${fn:escapeXml(orderData.insuranceQuote.formattedStartDate)}</span>
            </div>
            <c:if test="${orderData.insuranceQuote.quoteType eq 'TRAVEL' }">
                <c:if test="${not empty orderData.insuranceQuote.tripEndDate}">
                    <div class="short-overview__item">
                        <span class="short-overview__item-name col-xs-7"><spring:theme code="checkout.cart.end.date"/>:</span>
                        <span class="short-overview__item-price col-xs-5">
                                ${fn:escapeXml(orderData.insuranceQuote.tripEndDate)}
                        </span>
                    </div>
                </c:if>
                <div class="short-overview__item">
                    <span class="short-overview__item-name col-xs-7"><spring:theme code="text.cmstripdetailssubmitcomponent.number.of.travellers"/>: </span>
                    <span class="short-overview__item-price col-xs-5">
                            ${fn:escapeXml(orderData.insuranceQuote.tripNoOfTravellers)}
                    </span>
                </div>
                <div class="short-overview__item">
                    <span class="short-overview__item-name col-xs-7"><spring:theme code="text.cmstripdetailssubmitcomponent.ages.of.travellers"/>:</span>
                    <span class="short-overview__item-price col-xs-5">
                <c:forEach var="travellerAge" items="${orderData.insuranceQuote.tripTravellersAge}" varStatus="status">
                    <c:if test="${status.index ne 0 }">,&nbsp;</c:if>${fn:escapeXml(travellerAge)}
                </c:forEach>
            </span>
                </div>
            </c:if>
            <c:forEach items="${orderData.entries}" var="entry" varStatus="status">
                <c:if test="${status.first}">
                    <div class="short-overview__item">
                <span class="short-overview__item-name col-xs-7">
                    <ycommerce:testId code="cart_product_name">
                        ${fn:escapeXml(entry.product.name)}:
                    </ycommerce:testId>
                </span>
                        <span class="short-overview__item-price col-xs-5">
                    <ycommerce:testId code="cart_totalProductPrice_label">
                        <format:price priceData="${entry.totalPrice}" displayFreeForZero="true"/>
                    </ycommerce:testId>
                </span>
                    </div>
                </c:if>
            </c:forEach>

            <c:forEach items="${orderData.entries}" var="entry" varStatus="status">
                <c:if test="${not status.first}">
                    <div class="short-overview__item">
                        <span class="short-overview__item-name col-xs-7">
                            <ycommerce:testId code="cart_product_name">
                                ${fn:escapeXml(entry.product.name)}:
                            </ycommerce:testId>
                        </span>
                        <span class="short-overview__item-price col-xs-5">
                            <ycommerce:testId code="cart_totalProductPrice_label">
                                <format:price priceData="${entry.totalPrice}" displayFreeForZero="true"/>
                            </ycommerce:testId>
                        </span>
                    </div>
                </c:if>
            </c:forEach>
        </div>
        <div id="orderTotals" class="short-overview__item short-overview__item--highlighted">
            <span class="short-overview__item-name col-xs-6"><spring:theme code="basket.page.totals.total"/>&nbsp;</span>
            <span class="short-overview__item-price col-xs-6">
            <ycommerce:testId code="cart_totalPrice_label">
                <c:choose>
                    <c:when test="${showTax}">1
                        <format:price priceData="${orderData.totalPriceWithTax}"/>
                    </c:when>
                    <c:otherwise>
                        <format:price priceData="${orderData.totalPrice}"/>
                    </c:otherwise>
                </c:choose>
            </ycommerce:testId>
            </span>
        </div>
    </div>
    <div class="short-overview__button">
	    <a href="${request.contextPath}" class="primary-button primary-button__default primary-button__single-checkout"><spring:theme code="checkout.orderConfirmation.continueShopping" /></a>
    </div>
</div>

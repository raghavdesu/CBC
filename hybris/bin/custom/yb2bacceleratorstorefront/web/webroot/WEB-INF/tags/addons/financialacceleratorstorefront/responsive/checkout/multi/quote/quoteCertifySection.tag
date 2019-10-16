<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ attribute name="cartData" required="true" type="de.hybris.platform.commercefacades.order.data.CartData" %>
<%@ attribute name="checkoutUrl" required="true" type="java.lang.String" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<c:set value="false" var="isBinded"/>
<c:if test="${not empty cartData.insuranceQuote && cartData.insuranceQuote.state eq 'BIND'}">
    <c:set value="true" var="isBinded"/>
</c:if>

<div class="col-md-6 col-sm-6 col-xs-12">
    <form class="accordion__form-button js-certifyForm" action="${checkoutUrl}">
        <c:if test="${isValidQuote}">
            <ycommerce:testId code="multicheckout_next_button">
                <c:if test="${isBinded}">
                    <c:set var="show_processing_message" value="show_processing_message"/>
                </c:if>
                <c:choose>
                    <c:when test="${isBinded}">
                        <button type="submit" name="js-checkoutBtn" value="<spring:theme code="checkout.multi.quoteReview.checkout" text="Checkout Now"/>" class="primary-button primary-button__default primary-button__checkout js-checkoutBtn ${show_processing_message}"><spring:theme code="checkout.multi.quoteReview.checkout" text="Checkout Now"/></button>
                    </c:when>
                    <c:otherwise>
                        <button type="submit" name="js-checkoutBtn" value="<spring:theme code="checkout.multi.quoteReview.continue" text="Continue"/>" class="primary-button primary-button__default primary-button__checkout js-checkoutBtn ${show_processing_message}"><spring:theme code="checkout.multi.quoteReview.continue" text="Continue"/></button>
                    </c:otherwise>
                </c:choose>
            </ycommerce:testId>
        </c:if>
    </form>
</div>

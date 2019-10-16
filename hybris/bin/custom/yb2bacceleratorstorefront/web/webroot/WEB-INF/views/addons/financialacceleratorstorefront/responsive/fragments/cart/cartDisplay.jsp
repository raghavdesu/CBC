<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="financialCart" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/cart" %>
<spring:htmlEscape defaultHtmlEscape="true"/>

<div class="short-overview short-overview--right">
    <div class="short-overview__content">

        <c:choose>
            <c:when test="${error}">
                <financialCart:cartEmpty messageKey=""/>
            </c:when>

            <c:when test="${not empty cartData}">
                <financialCart:cartItems cartData="${cartData}" displayChangeOptionLink="false"/>
                <financialCart:cartTotals cartData="${cartData}" showTaxEstimate="${taxEstimationEnabled}"/>
            </c:when>

            <c:otherwise>
                <financialCart:configurationCartItems configuredProducts="${configuredProducts}"/>
                <financialCart:configurationCartTotals priceData="${totalPrice}"/>
            </c:otherwise>
        </c:choose>
    </div>
</div>
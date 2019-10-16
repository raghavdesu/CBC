<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="checkout" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout" %>
<%@ taglib prefix="multi-checkout" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout/multi" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/responsive/common" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="insuranceCheckout" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<spring:htmlEscape defaultHtmlEscape="true" />

<spring:url value="/checkout/multi/summary/placeOrder" var="placeOrderUrl" htmlEscape="false" />
<spring:url value="/checkout/multi/termsAndConditions" var="getTermsAndConditionsUrl" htmlEscape="false" />

<template:page pageTitle="${pageTitle}">
    <div class="boxed-content-wrapper">
        <multi-checkout:checkoutProgressBar steps="${checkoutSteps}" progressBarId="${progressBarId}"/>

        <div class="col-xs-12 col-md-8">
            <div class="final-review final-review__wrapper">
                <h3 class="section-header__heading"><spring:theme code="checkout.summary.reviewYourOrder" /></h3>
                <multi-checkout:summaryFlow deliveryAddress="${cartData.deliveryAddress}" deliveryMode="${deliveryMode}" paymentInfo="${paymentInfo}" requestSecurityCode="${requestSecurityCode}" cartData="${cartData}"/>
            </div>
            <div class="final-review__buttons">
                <form:form action="${placeOrderUrl}" id="placeOrderForm1" modelAttribute="placeOrderForm">
                    <div class="row">
                        <div class="final-review__checkbox checkbox col-xs-12 col-sm-8">
                            <label class="final-review__label"> <form:checkbox id="Terms1" path="termsCheck" />
                                <spring:theme code="checkout.summary.placeOrder.readTermsAndConditions" arguments="${getTermsAndConditionsUrl}" htmlEscape="false"/>
                            </label>
                        </div>
                        <div class="col-xs-12 col-sm-4">
                            <button id="placeOrder" type="submit" class="primary-button primary-button__default primary-button__single-checkout">
                                <spring:theme code="checkout.summary.placeOrder" text="Apply"/>
                            </button>
                        </div>
                    </div>
                </form:form>
            </div>
        </div>

        <multi-checkout:checkoutOrderDetails cartData="${cartData}" showShipDeliveryEntries="true" showPickupDeliveryEntries="true" showTax="true"/>

        <div class="col-xs-12 col-md-4">
            <br class="hidden-lg">
            <cms:pageSlot position="SideContent" var="feature" element="div" class="checkout-help">
                <cms:component component="${feature}"/>
            </cms:pageSlot>
        </div>
    </div>

</template:page>

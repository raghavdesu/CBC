<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="multi-checkout" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout/multi" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<template:page pageTitle="${pageTitle}">
    <div class="boxed-content-wrapper">
        <c:url value="${nextStepUrl}" var="nextStep"/>
        <c:url value="${previousStepUrl}" var="previousStep"/>

        <multi-checkout:checkoutProgressBar steps="${checkoutSteps}" progressBarId="${progressBarId}"/>
        <div class="col-md-8">
            <div id="checkoutContentPanel" class="xform-container">
                <div class="required"><spring:theme code="form.required" text="Fields marked * are required"/></div>
                <div class="xform-container__description"><spring:theme code="checkout.multi.description.quoteForm"/></div>
                <div class="xform-container__form">
                    <h3 class="section-header__heading"><spring:theme code="checkout.cart.personal.details"/></h3>
                    <c:forEach var="formHtml" items="${embeddedFormHtmls}">
                        ${formHtml}
                    </c:forEach>
                </div>
                <div id="form_button_panel" class="xform-container__buttons">
                    <ycommerce:testId code="multicheckout_cancel_button">
                        <div class="col-xs-12 col-sm-6">
                            <a id="backBtn" class="secondary-button secondary-button__default secondary-button__checkout" href="${fn:escapeXml(previousStep)}">
                                <spring:theme code="checkout.multi.quoteForm.back" text="Back"/>
                            </a>
                        </div>
                    </ycommerce:testId>
                    <ycommerce:testId code="multicheckout_saveForm_button">
                        <div class="col-xs-12 col-sm-6">
                            <a id="continueBtn" class="primary-button primary-button__default primary-button__checkout" href="${fn:escapeXml(nextStep)}">
                                <spring:theme code="checkout.multi.quoteForm.continue" text="Continue"/>
                            </a>
                        </div>
                    </ycommerce:testId>
                </div>
            </div>
        </div>
        <multi-checkout:checkoutOrderDetails cartData="${cartData}" showShipDeliveryEntries="true" showPickupDeliveryEntries="true" showTax="false"/>
    </div>
</template:page>

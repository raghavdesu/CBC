<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="order" tagdir="/WEB-INF/tags/responsive/order" %>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/responsive/common" %>
<%@ taglib prefix="user" tagdir="/WEB-INF/tags/responsive/user" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="insuranceCheckout" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout" %>
<%@ taglib prefix="insurancOrder" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/order" %>
<%@ taglib prefix="policy" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout/policy" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<template:page pageTitle="${pageTitle}">
    <div class="full-width-content-wrapper">
        <cms:pageSlot position="TopContent" var="feature">
            <cms:component component="${feature}" element="div" class="confirmation-hero-banner" />
        </cms:pageSlot>

        <div class="checkout-confirmation checkout-confirmation__wrapper">
            <div class="checkout-confirmation__message"><spring:theme code="checkout.orderConfirmation.application.message" /></div>
            <div class="checkout-confirmation__app-id"><spring:theme code="checkout.orderConfirmation.application.id" arguments="${fn:escapeXml(orderData.code)}"/></div>
        </div>
    </div>
</template:page>

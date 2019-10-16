<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="checkout" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout" %>
<%@ taglib prefix="multi-checkout" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout/multi" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement" %>
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/responsive/common" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="insuranceCheckout" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true"/>

<spring:url value="/checkout/multi/termsAndConditions" var="getTermsAndConditionsUrl" htmlEscape="false"/>
<spring:url value="/checkout/legal-information/termsCheck" var="termsCheckUrl" htmlEscape="false"/>

<template:page pageTitle="${pageTitle}">
    <div class="boxed-content-wrapper">
        <multi-checkout:checkoutProgressBar steps="${checkoutSteps}" progressBarId="${progressBarId}"/>

        <c:url value="${nextStepUrl}" var="nextStep"/>
        <c:url value="${previousStepUrl}" var="previousStep"/>

        <form:form modelAttribute="checkTermsForm" action="${termsCheckUrl}">
            <div class="col-xs-12">
                <div class="row section-header__wrapper">
                    <h3 class="section-header__heading"><spring:theme code="checkout.banking.multi.legalDocument.heading"/></h3>
                    <div class="legal__body">
                        <cms:pageSlot position="TopContent" var="feature">
                            <cms:component component="${feature}"/>
                        </cms:pageSlot>
                        <div class="legal__conditions-features">
                            <div class="legal__conditions">
                                <ul class="legal__list">
                                    <c:forEach items="${pdfDocuments}" var="item">
                                        <li class="legal__list-item">
                                            <a href="${item.downloadUrl}" class="legal__list-item--document">${fn:escapeXml(item.altText)}</a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                            <cms:pageSlot position="MiddleContent" var="feature">
                                <cms:component component="${feature}"/>
                            </cms:pageSlot>
                        </div>
                        <div class="legal__checkbox-wrapper">
                            <label class="legal__checkbox-label">
                                <form:checkbox id="Terms1" path="term1checked" tabindex="10"/>
                                <span class="legal__checkbox-text">
                                            <spring:theme code="checkout.banking.multi.legalDocument.checkboxFirst"/>
                                        </span>
                            </label>
                            <label class="legal__checkbox-label">
                                <form:checkbox id="Terms2" path="term2checked" tabindex="11"/>
                                <span class="legal__checkbox-text">
                                            <spring:theme code="checkout.banking.multi.legalDocument.checkboxSecond"/>
                                        </span>
                            </label>
                            <label class="legal__checkbox-label">
                                <form:checkbox id="Terms3" path="term3checked" tabindex="12"/>
                                <span class="legal__checkbox-text">
                                            <spring:theme code="checkout.banking.multi.legalDocument.checkboxThird"/>
                                        </span>
                            </label>
                            <label class="legal__checkbox-label">
                                <form:checkbox id="Terms4" path="term4checked" tabindex="13"/>
                                <span class="legal__checkbox-text">
                                            <spring:theme code="checkout.banking.multi.legalDocument.checkboxFourth"/>
                                        </span>
                            </label>
                        </div>
                    </div>
                </div>
                <div class="row identification--margin-top">
                    <div class="col-sm-6">
                        <a class="secondary-button secondary-button__default secondary-button__checkout" href="${fn:escapeXml(previousStep)}">
                            <spring:theme code="checkout.multi.quoteForm.back"/>
                        </a>
                    </div>
                    <div class="col-sm-6">
                        <button type="submit" class="primary-button primary-button__default primary-button__checkout">
                            <spring:theme code="checkout.multi.quoteForm.continue"/>
                        </button>
                    </div>
                </div>
            </div>
        </form:form>
    </div>
</template:page>

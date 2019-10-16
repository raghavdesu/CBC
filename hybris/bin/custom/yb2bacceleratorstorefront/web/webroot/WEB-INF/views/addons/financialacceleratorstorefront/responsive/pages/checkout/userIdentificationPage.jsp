<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="checkout" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout" %>
<%@ taglib prefix="multi-checkout" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout/multi" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/responsive/common" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="insuranceCheckout" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<spring:htmlEscape defaultHtmlEscape="true" />

<spring:url value="/checkout/multi/summary/placeOrder" var="placeOrderUrl" htmlEscape="false" />
<spring:url value="/checkout/multi/termsAndConditions" var="getTermsAndConditionsUrl" htmlEscape="false" />

<spring:url value="/checkout/user-identification/identifyUser" var="identifyUserUrl" htmlEscape="false"/>

<c:url value="${nextStepUrl}" var="nextStep"/>
<c:url value="${previousStepUrl}" var="previousStep"/>

<template:page pageTitle="${pageTitle}">
    <div class="boxed-content-wrapper">
        <multi-checkout:checkoutProgressBar steps="${checkoutSteps}" progressBarId="${progressBarId}"/>
        <div class="col-md-12">
            <cms:pageSlot position="TopContent" var="feature">
                <cms:component component="${feature}"/>
            </cms:pageSlot>
        </div>

	<div class="col-md-12">
		<form:form action="${identifyUserUrl}" id="placeOrderForm1" modelAttribute="placeOrderForm">
		<div class="identification section-header__wrapper">
			<h3 class="section-header__heading">${fn:escapeXml(categoryName)}</h3>
			<div class="identification__content">
                <cms:pageSlot position="MiddleContent" var="feature">
                    <cms:component component="${feature}"/>
                </cms:pageSlot>
				<div class="row identification--margin-top">
					<div class="col-sm-4 identification__cards">
						<input id="user-identification-r1" type="radio" name="user-identification" class="identification__radio" value="nearestBranch">
						<label class="identification__card" for="user-identification-r1">
							<span class="identification__icon identification__icon--first"></span>
							<span class="identification__title">
								<spring:theme code="checkout.identification.type.nearestBranch" text="At the nearest Branch"/>
							</span>
						</label>
					</div>
					<div class="col-sm-4 identification__cards">
						<input id="user-identification-r2" type="radio" name="user-identification" class="identification__radio" value="legalIdentification">
						<label class="identification__card" for="user-identification-r2">
							<span class="identification__icon identification__icon--second"></span>
							<span class="identification__title">
								<spring:theme code="checkout.identification.type.legalIdentification" text="Legal Identification"/>
							</span>
						</label>
					</div>
					<div class="col-sm-4 identification__cards">
						<input id="user-identification-r3" type="radio" name="user-identification" class="identification__radio" value="videoIdentification">
						<label class="identification__card" for="user-identification-r3">
							<span class="identification__icon identification__icon--third"></span>
							<span class="identification__title">
								<spring:theme code="checkout.identification.type.videoIdentification" text="Video Identification"/>
							</span>
								</label>
							</div>
						</div>
					</div>
				</div>
				<div class="row identification--margin-top">
					<div class="col-sm-6">
						<a class="secondary-button secondary-button__default secondary-button__checkout" href="${fn:escapeXml(previousStep)}">
							<spring:theme code="checkout.multi.quoteForm.back" />
						</a>
					</div>
					<div class="col-sm-6">
						<form:checkbox id="Terms1" path="termsCheck" cssClass="hidden" value="true"/>
						<button id="placeOrder" type="submit" class="primary-button primary-button__default primary-button__checkout">
							<spring:theme code="checkout.multi.quoteForm.continue"/>
						</button>
					</div>
				</div>
			</form:form>
		</div>
	</div>
</template:page>

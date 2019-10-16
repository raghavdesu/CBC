<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="multi-checkout" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout/multi" %>
<%@ taglib prefix="quote" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout/multi/quote" %>
<%@ taglib prefix="insuranceCheckout" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<template:page pageTitle="${pageTitle}">
	<div class="boxed-content-wrapper">
		<multi-checkout:checkoutProgressBar steps="${checkoutSteps}" progressBarId="${progressBarId}"/>
		<div class="col-md-8">
			<div id="checkoutContentPanel" class="accordion">
				<c:url value="${nextStepUrl}" var="nextStep"/>
				<c:url value="/checkout/multi/quote/back" var="backStep"/>
				<div class="col-md-12 col-sm-12 col-xs-12 accordion-header section-header__heading">
					<quote:quoteHeader insuranceQuoteReviews="${insuranceQuoteReviews}"/>
				</div>
				<div class="clearfix"></div>
				<div class="accordion-item clearfix">
					<c:set var="openWhatsIncludedSection" value="true"/>
					<c:choose>
						<c:when test="${fn:toLowerCase(fn:escapeXml(cmsSite.channel)) eq 'insurance'}"> <c:set var="personalDetailsStepOrder" value="3"/></c:when>
						<c:otherwise><c:set var="personalDetailsStepOrder" value="2"/></c:otherwise>
					</c:choose>
					<c:if test="${cartData.insuranceQuote.quoteType ne 'EVENT'}">
						<c:set var="openWhatsIncludedSection" value="false"/>
						<div class="col-md-12 col-sm-12 col-xs-12 accordion-item__wrapper js-quotePlanInfoSection">
							<quote:quotePlanInfoSection insuranceQuoteReviews="${insuranceQuoteReviews}" isValidStep="${insuranceQuoteReviews[0].validation['0']}"/>
						</div>
					</c:if>
					<c:if test="${not empty insuranceQuoteReviews and fn:length(insuranceQuoteReviews[0].mainProduct.benefits) > 0}">
						<div class="col-md-12 col-sm-12 col-xs-12 accordion-item__wrapper">
							<quote:quoteIncluded insuranceQuoteReviews="${insuranceQuoteReviews}" isValidStep="${insuranceQuoteReviews[0].validation['0']}" openSection="${openWhatsIncludedSection}"/>
						</div>
					</c:if>
					<div class="col-md-12 col-sm-12 col-xs-12 accordion-item__wrapper">
						<quote:quoteExtras insuranceQuoteReviews="${insuranceQuoteReviews}" isValidStep="${insuranceQuoteReviews[0].validation['1']}"/>
					</div>

					<c:if test="${not empty insuranceQuoteReviews and fn:length(insuranceQuoteReviews[0].mainProduct.coverageProduct.investments) > 0}">
						<div class="col-md-12 col-sm-12 col-xs-12 accordion-item__wrapper">
							<quote:quoteInvestments insuranceQuoteReviews="${insuranceQuoteReviews}" isValidStep="${insuranceQuoteReviews[0].validation['0']}" />
						</div>
					</c:if>

					<div class="col-md-12 col-sm-12 col-xs-12 accordion-item__wrapper">
						<quote:quoteReviewDetails insuranceQuoteReviews="${insuranceQuoteReviews}" isValidStep="${insuranceQuoteReviews[0].validation[personalDetailsStepOrder]}"/>
					</div>
				</div>
				<div class="row">
					<div class="col-md-6 col-sm-6 col-xs-12">
						<c:if test="${cartData.insuranceQuote.state eq 'UNBIND'}">
							<form:form method="post" modelAttribute="quoteReviewForm" class="accordion__form-button accordion__form-button--bottom">
								<ycommerce:testId code="multicheckout_back_button">
									<a class="secondary-button secondary-button__default secondary-button__checkout js-checkQuoteStatus" href="${fn:escapeXml(backStep)}">
										<spring:theme code="checkout.multi.quoteReview.back" text="Back"/>
									</a>
								</ycommerce:testId>
							</form:form>
						</c:if>
					</div>
					<quote:quoteCertifySection checkoutUrl="${nextStep}" cartData="${cartData}"/>
				</div>
			</div>
		</div>
		<multi-checkout:checkoutOrderDetails cartData="${cartData}" showShipDeliveryEntries="true" showPickupDeliveryEntries="true" showTax="true"/>
		<insuranceCheckout:confirmQuoteBindActionPopup/>
		<insuranceCheckout:referredQuotePopup/>
	</div>
</template:page>

<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/responsive/common" %>
<%@ taglib prefix="multi-checkout" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout/multi" %>
<%@ taglib prefix="address" tagdir="/WEB-INF/tags/responsive/address" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<template:page pageTitle="${pageTitle}">
	<div class="boxed-content-wrapper">
		<multi-checkout:checkoutProgressBar steps="${checkoutSteps}" progressBarId="${progressBarId}"/>

		<c:if test="${not empty paymentFormUrl}">
			<div class="col-sm-12 col-md-8">
				<div class="payment-details payment-details__wrapper">
					<h3 class="section-header section-header__heading"><spring:theme code="checkout.cart.payment.details"/></h3>
					<div id="checkoutContentPanel" class="payment-details__body">
						<ycommerce:testId code="paymentDetailsForm">
						<form:form id="silentOrderPostForm" name="silentOrderPostForm" modelAttribute="sopPaymentDetailsForm" class="create_update_payment_form" action="${paymentFormUrl}" method="POST">
						<input type="hidden" name="orderPage_receiptResponseURL" value="${silentOrderPageData.parameters['orderPage_receiptResponseURL']}"/>
						<input type="hidden" name="orderPage_declineResponseURL" value="${silentOrderPageData.parameters['orderPage_declineResponseURL']}"/>
						<input type="hidden" name="orderPage_cancelResponseURL" value="${silentOrderPageData.parameters['orderPage_cancelResponseURL']}"/>
						<c:forEach items="${sopPaymentDetailsForm.signatureParams}" var="entry" varStatus="status">
							<input type="hidden" id="${entry.key}" name="${entry.key}" value="${entry.value}"/>
						</c:forEach>
						<c:forEach items="${sopPaymentDetailsForm.subscriptionSignatureParams}" var="entry" varStatus="status">
							<input type="hidden" id="${entry.key}" name="${entry.key}" value="${entry.value}"/>
						</c:forEach>

						<div class="payment-details__headline">
							<h3><spring:theme code="checkout.multi.paymentMethod.addPaymentDetails.paymentCard"/></h3>
						</div>
						<spring:theme code="form.required" text="Fields marked * are required"/>
						<div class="payment-details__description"><spring:theme code="checkout.multi.paymentMethod.addPaymentDetails.enterYourCardDetails"/></div>

						<c:if test="${not empty paymentInfos}">
							<div class="row">
								<div class="col-md-4 col-sm-4 col-xs-12">
									<button id="viewSavedPayments" type="button" class="secondary-button secondary-button__default secondary-button__saved-payments js-view-payments">
										<spring:theme code="checkout.multi.paymentMethod.viewSavedPayments" text="View Saved Payments"/>
									</button>
								</div>
							</div>
						</c:if>

						<div class="card-form card-form__wrapper">
							<div class="row">
								<div class="col-md-6 col-sm-12 col-xs-12"><formElement:formSelectBox idKey="card_cardType" labelKey="payment.cardType" path="card_cardType" mandatory="true" skipBlank="false" skipBlankMessageKey="payment.cardType.pleaseSelect" items="${sopCardTypes}" tabindex="1"/></div>
								<div class="col-md-6 col-sm-12 col-xs-12"><formElement:formInputBox idKey="card_nameOnCard" labelKey="payment.nameOnCard" path="card_nameOnCard" inputCSS="text" tabindex="2" mandatory="false"/></div>
								<div class="card-form__clear"></div>
								<div class="col-md-6 col-sm-12 col-xs-12 "><formElement:formInputBox idKey="card_accountNumber" labelKey="payment.cardNumber" path="card_accountNumber" inputCSS="text" mandatory="true" tabindex="3" autocomplete="off"/></div>
								<div class="col-md-6 col-sm-12 col-xs-12"><formElement:formInputBox idKey="card_cvNumber" labelKey="payment.cvn" path="card_cvNumber" inputCSS="text" mandatory="true" tabindex="4"/></div>
							</div>
							<div class="row">
								<fieldset id="startDate" class="col-md-6 col-sm-12 col-xs-12 card-form__card-date card-form__card-date--display">
									<div class="row">
										<legend class="card-form__legend"><spring:theme code="payment.startDate"/></legend>
										<div class="col-md-6 col-sm-12 col-xs-12"><formElement:formSelectBox idKey="StartMonth" labelKey="payment.month" path="card_startMonth" mandatory="true" skipBlank="false" skipBlankMessageKey="payment.month" items="${months}" tabindex="5"/></div>
										<div class="col-md-6 col-sm-12 col-xs-12"><formElement:formSelectBox idKey="StartYear" labelKey="payment.year" path="card_startYear" mandatory="true" skipBlank="false" skipBlankMessageKey="payment.year" items="${startYears}" tabindex="6"/></div>
									</div>
								</fieldset>
								<fieldset class="col-md-6 col-sm-12 col-xs-12 card-form__card-date">
									<div class="row">
										<legend class="card-form__legend"><spring:theme code="payment.expiryDate"/></legend>
										<div class="col-md-6 col-sm-12 col-xs-12"><formElement:formSelectBox idKey="ExpiryMonth" labelKey="payment.month" path="card_expirationMonth" mandatory="true" skipBlank="false" skipBlankMessageKey="payment.month" items="${months}" tabindex="7"/></div>
										<div class="col-md-6 col-sm-12 col-xs-12"><formElement:formSelectBox idKey="ExpiryYear" labelKey="payment.year" path="card_expirationYear" mandatory="true" skipBlank="false" skipBlankMessageKey="payment.year" items="${expiryYears}" tabindex="8"/></div>
									</div>
								</fieldset>
							</div>
							<div id="issueNum" class="card-form__issue-number">
								<div class="row">
									<div class="col-md-6 col-sm-12 col-xs-12"><formElement:formInputBox idKey="card_issueNumber" labelKey="payment.issueNumber" path="card_issueNumber" inputCSS="text" mandatory="false" tabindex="9"/></div>
								</div>
							</div>
						</div>


						<div class="card-form__save-payment-info">
							<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
								<formElement:formCheckbox idKey="savePaymentInfo1" labelKey="checkout.multi.sop.savePaymentInfo" path="savePaymentInfo"
														  inputCSS="" labelCSS="" mandatory="false"/>
							</sec:authorize>
						</div>

						<div class="payment-details__headline">
							<h3 class="payment-details__headline--margin"><spring:theme code="checkout.multi.paymentMethod.addPaymentDetails.billingAddress"/></h3>
						</div>
						<input type="hidden" value="${silentOrderPageData.parameters['billTo_email']}" class="text" name="billTo_email" id="billTo_email">
						<address:billAddressFormSelector supportedCountries="${countries}" regions="${regions}" tabindex="12"/>
					</div>
					</form:form>
					</ycommerce:testId>
				</div>

				<c:url value="${previousStepUrl}" var="previousStep"/>
				<div class="row payment-details__buttons">
					<div class="col-md-6 col-sm-6 col-xs-12">
						<a class="secondary-button secondary-button__default secondary-button__checkout" href="${fn:escapeXml(previousStep)}"><spring:theme code="checkout.multi.quoteForm.back" text="Back"/></a>
					</div>
					<div class="col-md-6 col-sm-6 col-xs-12">
						<button class="primary-button primary-button__default primary-button__checkout submit_silentOrderPostForm" tabindex="20">
							<spring:theme code="checkout.multi.paymentMethod.continue" text="Continue"/>
						</button>
					</div>
				</div>

				<c:if test="${not empty paymentInfos}">
					<div id="savedPaymentListHolder" class="saved-payment-list saved-payment-list--display">
						<div id="savedPaymentList" class="saved-payment-list__wrapper">
							<div class="saved-payment-list__headline">
								<h3 class="saved-payment-list__heading"><spring:theme code="checkout.summary.paymentMethod.savedCards.header"/></h3>
							</div>
							<div class="saved-payment-list__description"><spring:theme code="checkout.summary.paymentMethod.savedCards.selectSavedCardOrEnterNew"/></div>

							<div class="saved-payment-list__list">
								<c:forEach items="${paymentInfos}" var="paymentInfo" varStatus="status">
									<div class="saved-payment-list__list-entry">
										<form action="${request.contextPath}/checkout/multi/payment-method/choose" method="GET">
											<input type="hidden" name="selectedPaymentMethodId" value="${paymentInfo.id}"/>

												<div class="saved-payment-list__list-items">
													<ul>
														<li>${fn:escapeXml(paymentInfo.cardType)}</li>
														<li>${fn:escapeXml(paymentInfo.cardNumber)}</li>
														<li><spring:theme code="checkout.multi.paymentMethod.paymentDetails.expires" arguments="${paymentInfo.expiryMonth},${paymentInfo.expiryYear}"/></li>
														<li>${fn:escapeXml(paymentInfo.billingAddress.firstName)}&nbsp; ${fn:escapeXml(paymentInfo.billingAddress.lastName)}</li>
														<li>${fn:escapeXml(paymentInfo.billingAddress.line1)}
															<c:if test="${not empty paymentInfo.billingAddress.region.isocodeShort}">
																<br>${fn:escapeXml(paymentInfo.billingAddress.region.isocodeShort)}
															</c:if>
															<br>${fn:escapeXml(paymentInfo.billingAddress.town)}
															<br>${fn:escapeXml(paymentInfo.billingAddress.postalCode)}</li>
													</ul>
												</div>

											<div class="col-xs-12 col-sm-6 pull-right">
												<button type="submit" class="primary-button primary-button__default primary-button__popup" tabindex="${status.count + 21}">
													<spring:theme code="checkout.multi.sop.useThisPaymentInfo" text="Use this Payment Info"/>
												</button>
											</div>
										</form>
										<form:form action="${request.contextPath}/checkout/multi/payment-method/remove" method="POST">
											<input type="hidden" name="paymentInfoId" value="${paymentInfo.id}"/>
											<div class="col-xs-12 col-sm-6">
												<button type="submit" class="secondary-button secondary-button__default secondary-button__popup" tabindex="${status.count + 22}">
													<spring:theme code="checkout.multi.sop.remove" text="Remove"/>
												</button>
											</div>
										</form:form>
									</div>
								</c:forEach>
							</div>
						</div>
					</div>
				</c:if>
			</div>
			<multi-checkout:checkoutOrderDetails cartData="${cartData}" showShipDeliveryEntries="true" showPickupDeliveryEntries="true" showTax="true"/>
			</div>
		</c:if>
	</div>
</template:page>

<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="order" tagdir="/WEB-INF/tags/responsive/order" %>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/responsive/common" %>
<%@ taglib prefix="user" tagdir="/WEB-INF/tags/responsive/user" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="insuranceCheckout" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout" %>
<%@ taglib prefix="insurancOrder" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/order" %>
<%@ taglib prefix="policy" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout/policy" %>
<%@ taglib prefix="quote" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout/multi/quote" %>

<template:page pageTitle="${pageTitle}">
    <div class="boxed-content-wrapper">
        <div class="col-md-12 checkout-confirmation">
            <c:choose>
                <c:when test ="${orderData.status.code eq 'CANCELLED' or orderData.status.code eq 'CHECKED_INVALID'}">
                    <div class="checkout-confirmation__covered"><spring:theme code="checkout.orderConfirmation.quoteRejected" /></div>
                </c:when>
                <c:otherwise>
                    <div class="checkout-confirmation__covered"><spring:theme code="checkout.orderConfirmation.quoteSubmitted" /></div>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="col-md-8 checkout-confirmation checkout-confirmation__wrapper accordion">
            <div class="col-md-12 accordion-header section-header__heading section-header__heading--lean">
                <div class="row">
                    <c:set var="images" value="${orderData.entries[0].product.images}"></c:set>
                    <insuranceCheckout:policySummaryLine images="${images}" />
                </div>
            </div>
            <div class="clearfix"></div>
            <div id="checkoutContentPanel" class="accordion">
                <c:forEach items="${insuranceQuoteReviews}" var="quoteReview">
                    <div class="accordion-item clearfix">
                        <c:set var="openWhatsIncludedSection" value="true"/>
                        <c:if test="${orderData.insuranceQuote.quoteType ne 'EVENT'}">
                            <c:set var="openWhatsIncludedSection" value="false"/>
                            <div class="col-md-12 col-sm-12 col-xs-12 accordion-item__wrapper js-quotePlanInfoSection">
                                <policy:policyPlanInfoSection orderData="${orderData}"/>
                            </div>
                        </c:if>
                        <c:if test="${not empty insuranceQuoteReviews and fn:length(insuranceQuoteReviews[0].mainProduct.benefits) > 0}">
                            <div class="col-md-12 col-sm-12 col-xs-12 accordion-item__wrapper">
                                <quote:quoteIncluded insuranceQuoteReviews="${insuranceQuoteReviews}"
                                                     openSection="${openWhatsIncludedSection}"/>
                            </div>
                        </c:if>
                        <div class="col-md-12 col-sm-12 col-xs-12 accordion-item__wrapper">
                            <quote:quoteExtras insuranceQuoteReviews="${insuranceQuoteReviews}"/>
                        </div>
                        <c:if test="${not empty insuranceQuoteReviews and fn:length(insuranceQuoteReviews[0].mainProduct.coverageProduct.investments) > 0}">
                            <div class="col-md-12 col-sm-12 col-xs-12 accordion-item__wrapper">
                                <quote:quoteInvestments insuranceQuoteReviews="${insuranceQuoteReviews}"/>
                            </div>
                        </c:if>
                        <div class="col-md-12 col-sm-12 col-xs-12 accordion-item__wrapper">
                            <quote:quoteReviewDetails insuranceQuoteReviews="${insuranceQuoteReviews}"
                                                      isValidStep="${insuranceQuoteReviews[0].validation[personalDetailsStepOrder]}"/>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${not empty orderData.insurancePolicy[0].responsibleAgent}">
                    <div class="col-md-12 col-sm-12 col-xs-12 accordion-item__wrapper">
                        <policy:policyMyAgentSection policyData="${orderData.insurancePolicy[0]}"/>
                    </div>
                </c:if>
            </div>
        </div>
        <div class="col-md-4">
            <insurancOrder:orderDetailsItem orderData="${orderData}"/>
            <cms:pageSlot position="SideContent" var="feature" element="div" class="span-24 side-content-slot cms_disp-img_slot">
                <cms:component component="${feature}"/>
            </cms:pageSlot>
        </div>
    </div>
</template:page>

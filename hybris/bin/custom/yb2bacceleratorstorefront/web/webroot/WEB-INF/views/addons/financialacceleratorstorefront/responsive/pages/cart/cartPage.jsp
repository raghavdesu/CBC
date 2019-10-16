<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="financialCart" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/cart" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="formatter" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/format" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<spring:theme text="Your Shopping Cart" var="title" code="cart.page.title"/>
<c:url value="/cart/checkout" var="checkoutUrl"/>

<template:page pageTitle="${pageTitle}">
    <div class="boxed-content-wrapper">
        <cart:cartRestoration/>
        <cart:cartValidation/>
        <cart:cartPickupValidation/>

        <div class="col-md-12 clearfix">
            <cms:pageSlot position="TopContent" var="feature" element="div">
                <cms:component component="${feature}"/>
            </cms:pageSlot>
        </div>
        <div class="col-sm-12 col-md-8">
            <div class="cart-items-list cart-items-list__wrapper js-cartItemsList">
                <div class="row">
                    <h3 class="section-header__heading"><spring:theme code="cart.product.options"/></h3>
                </div>
                <div class="row">
                    <div class="col-md-12 col-sm-12 cart-items-list__items-list">
                        <c:set var="bundleNoTemp" value="${cartData.entries[0].entryNumber}"/>
                        <c:forEach items="${cartData.entries}" var="entry" varStatus="status">
                            <c:if test="${not status.first}">
                                <hr class="cart-items-list__divider">
                                <financialCart:cartPotentialItem orderEntryData="${entry}" planProductData="${planProductData}"/>
                            </c:if>
                        </c:forEach>
		                <c:if test="${not empty cartData.entries[0].product.classifications}">
		                	<hr class="cart-items-list__divider">
		                	<div class="col-md-12 cart-items-list__item">
			                	<div class="row flex">
								    <div class="cart-items-list__thumb">
										<span class="glyphicon glyphicon-info-sign"></span>
								    </div>
								    <h3 class="cart-items-list__info ellipsis"><spring:theme code="cart.covered.riders"/>${fn:escapeXml(cartData.entries[0].product.name)}</h3>
								    <div class="cart-items-list__details ellipsis">
					                    <c:forEach items="${cartData.entries[0].product.classifications}" var="classification" varStatus="status">       
					                        <c:if test="${not empty classification.features}">
					                            <c:forEach items="${classification.features}" var="feature" varStatus="status">
					                            	<div class="short-overview__item col-xs-12">
						                            	<span class="short-overview__item-name ellipsis col-xs-7">${feature.name}:</span>
						                                <c:if test="${not empty feature.featureValues[0] && feature.featureValues[0].value.matches('[0-9]+')}">
						                                    <span class="short-overview__item-price col-xs-5"><formatter:propertyValueFormatter rawValue="${feature.featureValues[0].value}" targetFormatKey="currency" /></span>
						                                </c:if>
					                                </div>
					                            </c:forEach>
					                        </c:if>
					                    </c:forEach>
								    </div>
							    </div>
						    </div>
		                </c:if>
                    </div>
                </div>
            </div>
            <div class="col-xs-12 col-sm-3 cart-items-list__button-row">
                <c:if test="${not empty cartData.entries}">
                    <button id="checkoutButtonBottom" class="primary-button primary-button__default primary-button__single-checkout js-continue-checkout-button" type="button" data-checkout-url="${checkoutUrl}">
                        <spring:theme code="checkout.next"/>
                    </button>
                </c:if>
            </div>
        </div>
        <div class="col-md-4">
            <div class="short-overview short-overview--right">
                <div class="short-overview__content">
                    <financialCart:cartItems cartData="${cartData}" displayChangeOptionLink="false"/>
                    <financialCart:cartTotals cartData="${cartData}" showTaxEstimate="${taxEstimationEnabled}"/>
                </div>
                <financialCart:cartModifyPlan cartData="${cartData}" flowStartUrl="${flowStartUrl}"/>
            </div>
        </div>
    </div>
</template:page>

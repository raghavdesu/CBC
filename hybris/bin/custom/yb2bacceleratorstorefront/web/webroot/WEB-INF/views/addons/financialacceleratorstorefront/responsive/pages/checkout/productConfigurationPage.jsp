<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/template" %>
<%@ taglib prefix="multi-checkout" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout/multi" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/product" %>
<%@ taglib prefix="financialCart" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/cart" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true"/>

<c:set value="/cart/addBundle" var="addBundleUrl"/>
<spring:url var="changePlanUrl" value="/cart/changePlan" htmlEscape="false">
    <spring:param name="redirectUrl" value="${addBundleUrl}" />
</spring:url>
<spring:url var="addToCartUrl" value="${addBundleUrl}" htmlEscape="false"/>

<template:page pageTitle="${pageTitle}">

    <spring:url var="updateConfigurationUrl" value="/updateConfiguration/YFORM" htmlEscape="false"/>
    <div id="mobile-spinner" class="spinner spinner--mobile js-spinner"></div>

    <div class="boxed-content-wrapper">

        <cms:pageSlot position="Section1" var="feature">
            <cms:component component="${feature}" element="div" class="col-md-12"/>
        </cms:pageSlot>

            <%-- Configurator --%>
        <div class="col-md-8">
            <div class="section-header__wrapper">
                <h3 class="section-header__heading">
                    <spring:theme code="checkout.configure.product.headline"/>
                </h3>
                <product:productConfigurator configurations="${configurations}"/>
            </div>

            <div class="col-xs-12 col-sm-4 cart-items-list__button-row">
                <form class="js-updateConfigurationForm" action="${changePlanUrl}" data-updateconfigurationpath=${updateConfigurationUrl} data-handlerpath="${addToCartUrl}" method="post">

                    <input type="hidden" name="CSRFToken" value="${CSRFToken.token}"/>
                    <input type="hidden" name="bundleTemplateIds" value="${product.bundleTemplates[0].id}"/>
                    <input type="hidden" name="productCodes" value="${product.code}">
                    <c:if test="${not empty entryNumber}">
                        <input type="hidden" name="entryNumber" value="${entryNumber}"/>
                    </c:if>

                    <a id="yFormSaveBtn" class="primary-button primary-button__default primary-button__single-checkout" href="#">
                        <spring:theme code="basket.add.to.basket.continue" text="Continue"/>
                    </a>

                </form>
            </div>
        </div>

        <%-- Mini-cart --%>
        <div id="js-dynamic-cart" class="col-md-4">
            <div class="short-overview short-overview--right">
                <div class="short-overview__content">
                    <c:choose>
                        <c:when test="${currentProductInTheCart}">
                            <financialCart:cartItems cartData="${cartData}" displayChangeOptionLink="false"/>
                            <financialCart:cartTotals cartData="${cartData}" showTaxEstimate="${taxEstimationEnabled}"/>
                        </c:when>
                        <c:otherwise>
                            <financialCart:configurationCartItems cartTitle="${categoryName}" configuredProducts="${configuredProducts}"/>
                            <financialCart:configurationCartTotals priceData="${totalPrice}" configuredProducts="${configuredProducts}"/>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

    </div>

    <financialCart:changePlanConfirmPopup confirmActionButtonId="addNewPlanConfirmButton"/>

</template:page>
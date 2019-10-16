<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="orderEntryData" required="true" type="de.hybris.platform.commercefacades.order.data.OrderEntryData" %>
<%@ attribute name="planProductData" required="true" type="de.hybris.platform.commercefacades.product.data.ProductData" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="formatter" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/format" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<div class="cart-items-list__item">
    <div class="row">
        <c:if test="${not empty orderEntryData.product.description}">
            <div class="holder-add-options holder__wrapper">
                <div class="holder__tooltip js-tooltip">i</div>
                <span class="holder__tip js-tip">
				        <span class="holder__close-tip js-close-tip">&#215;</span>
				        <span class="holder__content-tip">
							${fn:escapeXml(orderEntryData.product.description)}
			                <c:if test="${not empty orderEntryData.product.classifications}">
			                	<hr>
			                    <c:forEach items="${orderEntryData.product.classifications}" var="classification" varStatus="status">
			                        <c:if test="${not empty classification.features}">
			                            <c:forEach items="${classification.features}" var="feature" varStatus="status">
			                            	<div class="row">
				                            	<span class="short-overview__item-name ellipsis col-xs-6">${feature.name}:</span>
				                                <c:if test="${not empty feature.featureValues[0] && feature.featureValues[0].value.matches('[0-9]+')}">
				                                    <span class="short-overview__item-price col-xs-6"><formatter:propertyValueFormatter rawValue="${feature.featureValues[0].value}" targetFormatKey="currency" /></span>
				                                </c:if>
			                                </div>
			                            </c:forEach>
			                        </c:if>
			                    </c:forEach>
			                </c:if>
                        </span>
				    </span>
            </div>
        </c:if>
        <div class="col-xs-12 col-sm-2 cart-items-list__thumb">
            <product:productPrimaryImage product="${orderEntryData.product}" format="96Wx96H"/>
        </div>
        <div class="col-xs-12 col-sm-7">
            <ycommerce:testId code="entry_product_productName">
                <h3 class="cart-items-list__product-name ellipsis">${fn:escapeXml(orderEntryData.product.name)}</h3>
            </ycommerce:testId>
        </div>
        <c:choose>
            <c:when test="${not orderEntryData.removeable and not orderEntryData.addable}">
                <div class="col-xs-12 col-sm-7 disabled-option"></div>
            </c:when>
        </c:choose>
        <div class="col-xs-12 col-sm-3 cart-items-list__button">
            <c:choose>
                <c:when test="${not orderEntryData.removeable and not orderEntryData.addable}">
                    <button class="secondary-button secondary-button__default secondary-button__add-remove secondary-button__default--opacity-disabled" ${not orderEntryData.removeable and not orderEntryData.addable ? "disabled": ""}>
                        <c:choose>
                            <c:when test="${fn:length(orderEntryData.product.bundleTemplates) == 3}">
                                <spring:theme code="text.product.mandated"/>
                            </c:when>
                            <c:otherwise>
                                <spring:theme code="checkout.notAvailable"/>
                            </c:otherwise>
                        </c:choose>
                    </button>
                </c:when>
                <c:when test="${not orderEntryData.removeable and orderEntryData.addable}">
                    <spring:url var="cartUrl" value="/cart/addSingleProduct"/>

                    <form:form id="addPotentialProduct${orderEntryData.product.code}" action="${cartUrl}" method="post">
                        <c:choose>
                            <c:when test="${fn:length(orderEntryData.product.bundleTemplates) == 3}">
                                <input type="hidden" name="bundleTemplateId" value="${orderEntryData.product.bundleTemplates[2].id}">
                            </c:when>
                            <c:otherwise>
                                <input type="hidden" name="bundleTemplateId" value="${orderEntryData.product.bundleTemplates[1].id}">
                            </c:otherwise>
                        </c:choose>

                        <input type="hidden" name="productCodePost" value="${orderEntryData.product.code}">
                        <input type="hidden" name="bundleNo" value="${orderEntryData.entryNumber}">
                    </form:form>
                    <ycommerce:testId code="cart_product_addProduct">
                        <button id="AddProduct-${orderEntryData.product.code}" class="secondary-button secondary-button__default secondary-button__add-remove js-submit js-addPotentialProductToCartForm">
                            <spring:theme code="checkout.add"/></button>
                    </ycommerce:testId>
                </c:when>
            </c:choose>

            <c:if test="${orderEntryData.removeable}">
                <spring:url value="/cart/update" var="cartUpdateFormAction"/>
                <form:form id="updateCartForm${orderEntryData.entryNumber}" action="${cartUpdateFormAction}" method="post"
                           modelAttribute="updateQuantityForm${orderEntryData.entryNumber}">
                    <input type="hidden" name="entryNumber" value="${orderEntryData.entryNumber}"/>
                    <input type="hidden" name="productCode" value="${orderEntryData.product.code}"/>
                    <input type="hidden" name="initialQuantity" value="${orderEntryData.quantity}"/>
                    <input type="hidden" name="quantity" value="0"/>
                </form:form>
                <ycommerce:testId code="cart_product_removeProduct">
                    <spring:theme code="text.iconCartRemove" var="iconCartRemove"/>
                    <button id="RemoveProduct_${orderEntryData.entryNumber}" class="secondary-button secondary-button__default secondary-button__add-remove secondary-button__default--opacity js-remove-entry-button">${iconCartRemove}</button>
                </ycommerce:testId>
            </c:if>
        </div>
    </div>
</div>

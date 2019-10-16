<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="cartData" required="true" type="de.hybris.platform.commercefacades.order.data.CartData" %>
<%@ attribute name="displayChangeOptionLink" required="false" type="java.lang.Boolean" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="financialCart" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/cart" %>
<%@ taglib prefix="formatter" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/format" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:forEach items="${cartData.entries}" var="entry" varStatus="status">
    <c:if test="${status.first}">
            <div class="short-overview__heading">
                <spring:theme code="checkout.multi.quoteReview.title.${fn:toLowerCase(cmsSite.channel)}" text="Title {0}" arguments="${entry.product.defaultCategory.name}"/>
            </div>
            <div id="desktop-spinner" class="spinner spinner--desktop js-spinner"></div>
            <div class="short-overview__items">
                <c:if test="${cartData.insuranceQuote.state eq 'BIND' }">
                    <div class="short-overview__item">
                        <span class="short-overview__item-name col-xs-7"><spring:theme code="checkout.cart.quote.id" text="ID" />: </span>
                        <span class="short-overview__item-price col-xs-5">${cartData.insuranceQuote.quoteId}</span>
                    </div>
                    <div class="short-overview__item">
                        <span class="short-overview__item-name col-xs-7"><spring:theme code="checkout.cart.expiry.date" text="Expiry Date" />: </span>
                        <span class="short-overview__item-price col-xs-5">${cartData.insuranceQuote.formattedExpiryDate}</span>
                    </div>
                </c:if>
                <financialCart:cartItemInsurance cartData="${cartData}" cartEntry="${entry}"/>

                <!-- Product Configuration Values -->
                <c:if test="${not empty cartData.insuranceQuote.configurationDetails}">
                    <c:set var="configurationDetailsList" value="${cartData.insuranceQuote.configurationDetails}"/>
                    <c:forEach items="${configurationDetailsList}" var="configDetail">
                        <div class="short-overview__item">
                            <span class="short-overview__item-name col-xs-7">
                                <spring:theme code="checkout.text.configuration.label.${configDetail.key}" text="${configDetail.key}"/>
                            </span>
                            <span class="short-overview__item-price col-xs-5">
                                <formatter:propertyValueFormatter targetFormatKey="checkout.text.configuration.format.${configDetail.key}" valueKeyPrefix="checkout.text.configuration.value.${configDetail.key}" rawValue="${configDetail.value}"/>
                            </span>
                        </div>
                    </c:forEach>
                </c:if>
                <!-- END - Product Configuration Values -->

                <div class="short-overview__item">
                    <span class="short-overview__item-name col-xs-7">
                        <c:choose>
                            <c:when test="${not empty cartData.insuranceQuote.propertyCoverRequired }">
                                <spring:theme code="checkout.property.cover.required.${cartData.insuranceQuote.propertyCoverRequired}" text="Cover Required" />
                            </c:when>
                            <c:otherwise>
                                ${fn:escapeXml(entry.product.name)}:
                            </c:otherwise>
                        </c:choose>
                        </span>
                    <span class="short-overview__item-price col-xs-5">
                    	<format:price priceData="${entry.totalPrice}" displayFreeForZero="true"/>
                    </span>
                </div>
                <!-- Charge Entries & Billing events (Comparison Table items) -->
                <c:if test="${not empty entry.product.price.oneTimeChargeEntries and not hideCartBillingEvents}">
                    <c:forEach items="${entry.product.price.oneTimeChargeEntries}" var="oneTimeChargeEntry" begin="1">
                        <div class="short-overview__item-price">
                            <c:set var="priceText">
                                <format:price priceData="${oneTimeChargeEntry.price}"/>
                            </c:set>
                            <p><spring:theme code="text.price.up.to"/>${priceText}
                                &nbsp;&nbsp;${fn:escapeXml(oneTimeChargeEntry.billingTime.name)}</p>
                        </div>
                    </c:forEach>
                </c:if>

                    <%-- Optional products/components --%>
                <c:forEach items="${cartData.entries}" var="entry" varStatus="status">
                    <c:if test="${not status.first and not entry.removeable and not entry.addable and fn:length(entry.product.bundleTemplates) == 3}">
                        <div class="short-overview__item">
			                <span class="short-overview__item-name col-xs-7">
			                    <ycommerce:testId code="cart_product_name">
                                    ${fn:escapeXml(entry.product.name)}:
                                </ycommerce:testId>
			                </span>
                            <span class="short-overview__item-price col-xs-5">
			                    <ycommerce:testId code="cart_totalProductPrice_label">
                                    <formatter:priceAndFrequency priceData="${entry.totalPrice}" productData="${entry.product}" displayFreeForZero="true" displayFrequency="false"/>
                                </ycommerce:testId>
                			</span>
                        </div>
                    </c:if>
                    <c:if test="${not status.first and entry.removeable}">
                        <div class="short-overview__item">
                            <span class="short-overview__item-name col-xs-7">
			                    <ycommerce:testId code="cart_product_name">
                                    ${fn:escapeXml(entry.product.name)}:
                                </ycommerce:testId>
                			</span>
                            <span class="short-overview__item-price col-xs-5">
			                    <ycommerce:testId code="cart_totalProductPrice_label">
                                    <format:price priceData="${entry.totalPrice}" displayFreeForZero="true"/>
                                </ycommerce:testId>
			                </span>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
    </c:if>
</c:forEach>

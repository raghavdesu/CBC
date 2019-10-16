<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="product" required="true" type="de.hybris.platform.commercefacades.product.data.ProductData" %>
<%@ attribute name="comparisonTable" required="false" type="de.hybris.platform.financialacceleratorstorefront.comparison.ComparisonTable" %>
<%@ attribute name="addToCartBtn_label_key" required="false" type="java.lang.String"%>
<%@ attribute name="comparisonTableColumn" required="true" type="de.hybris.platform.financialacceleratorstorefront.comparison.ComparisonTableColumn" %>
<%@ attribute name="showOptionalProducts" required="false" type="java.lang.Boolean" %>
<%@ attribute name="initialRowsCount" required="false" type="java.lang.Integer" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="formatter" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/format" %>


<spring:htmlEscape defaultHtmlEscape="true" />

<spring:theme code="text.addToCart" var="addToCartText"/>
<c:set value="/cart/addBundle" var="addBundleUrl"/>
<spring:url var="changePlanUrl" value="/cart/changePlan" htmlEscape="false">
    <spring:param name="redirectUrl" value="${addBundleUrl}" />
</spring:url>
<spring:url var="addToCartUrl" value="${addBundleUrl}" htmlEscape="false"/>

<c:set value="${not empty product.potentialPromotions}" var="hasPromotion"/>
<c:set value="${product.bundleTemplates[0]}" var="productPackage"/>
<c:set value="${product.bundleTemplates[1]}" var="productComponent"/>
<c:set value="false" var="hasRecurringCharge"/>
<c:set value="recurringAnnualPrice" var="recurringAnnualPricekey"/>
<c:set value="annualSavingPrice" var="annualSavingPricekey"/>

<c:set var="detailsCss" value="products-details js-details"/>
<c:if test="${showOptionalProducts eq false}">
    <c:set var="detailsCss" value="products-details js-details"/>
</c:if>

<c:if test="${not empty comparisonTable.columns}">
    <c:forEach items="${comparisonTable.columns}" var="columnTable">
        <c:if test="${columnTable.key eq recurringAnnualPricekey}">
            <c:set value="true" var="hasRecurringCharge"/>
        </c:if>
    </c:forEach>
</c:if>

<ycommerce:testId code="product_wholeProduct">
    <div class="js-product-grid-item ${hasPromotion ? 'productGridItemPromotion' : ''}">
        <div class="${detailsCss}">
            <ycommerce:testId code="product_productName">
                <h3 class="products-details__name js-product-name">
                    <formatter:propertyValueFormatter valueKeyPrefix="checkout.comparison.item.title" rawValue="${fn:toLowerCase(fn:escapeXml(product.code))}"/>
                </h3>

            </ycommerce:testId>
            <ycommerce:testId code="product_payOnCheckout">
                <c:choose>
                    <c:when test="${hasRecurringCharge eq true and not empty product.price.recurringChargeEntries}">
                        <c:set var="payOnCheckout" value="${product.price.recurringChargeEntries[0]}"/>
                        <div class="js-pay-on-checkout">
                            <c:set var="priceText">
                                <format:price priceData="${payOnCheckout.price}"/>
                            </c:set>
                            <h4 class="products-details__main-price">${fn:escapeXml(priceText)}</h4>
                            <span class="products-details__pay-on-checkout"><spring:theme code="text.annual.price" text="Annual price: "/>${fn:escapeXml(comparisonTable.columns[recurringAnnualPricekey].items[0])}</span>
                            <c:if test="${not empty mandatoryOptionProducts.results}">
                                <c:forEach items="${mandatoryOptionProducts.results}" var="mandatoryOptionProduct">
                                    <c:if test="${mandatoryOptionProduct.code eq product.code}">
                                        <div class="products-details__mandatory-products">
                                            <input id="mandatoryBundleProduct" class="products-details__mandatory-products--checkbox-margin" data-code="${mandatoryOptionProduct.code}" type="checkbox" name="Add Telemetry"> <spring:theme code="text.mandatory.bundle.check.label" text="Tick this checkbox to enable monthly plan"/>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:if test="${not empty product.price.oneTimeChargeEntries}">
                            <c:set var="payOnCheckout" value="${product.price.oneTimeChargeEntries[0]}"/>
                            <c:choose>
                                <c:when test="${payOnCheckout.billingTime.code eq 'paynow'}">
                                    <div class="js-pay-on-checkout">
                                        <c:set var="priceText">
                                            <format:price priceData="${payOnCheckout.price}"/>
                                        </c:set>
                                        <c:choose>
                                            <c:when test="${not empty product.dynamicAttributes and not empty product.dynamicAttributes['monthlyAnnuity']}">
                                                <h4 class="products-details__main-price">
                                                    <format:price priceData="${product.dynamicAttributes['monthlyAnnuity']}"/>
                                                </h4>
                                            </c:when>
                                            <c:otherwise>
                                                <h4 class="products-details__main-price">${fn:escapeXml(priceText)}</h4>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${hasRecurringCharge eq true }">
                                            <span class="products-details__pay-on-checkout products-details__pay-on-checkout-monthly"><spring:theme code="text.saving.against.monthly" text="Saving against Monthly: "/>${fn:escapeXml(comparisonTable.columns[annualSavingPricekey].items[0])}</span>
                                        </c:if>
                                    </div>
                                </c:when>
                            </c:choose>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </ycommerce:testId>
            <c:choose>
                <c:when test="${product.configurable}">
                    <%-- Case 1: Display a link to product configuration page in case a product needs to be configured first --%>
                    <spring:url var="configureProductUrl" value="/p/${product.code}/configuratorPage/YFORM" htmlEscape="false"/>

                    <a class="primary-button__default primary-button__single-checkout" href="${configureProductUrl}">
                        <spring:message code="text.product.chooseProduct" text="Choose"/>
                    </a>
                </c:when>
                <c:otherwise>
                    <%-- Case 2: If product is not eligible for configuration, display an add to cart form --%>
                    <form class="js-addToCartForm" action="${changePlanUrl}" data-handlerpath="${addToCartUrl}" method="post">
                        <input type="hidden" name="bundleTemplateIds" value="${fn:escapeXml(productPackage.id)}"/>
                        <input type="hidden" name="productCodes" value="${fn:escapeXml(product.code)}">
                        <c:if test="${showOptionalProducts eq true}">
                            <input type="hidden" name="clearOptionalProducts" value="true">
                            <div class="products-details__optional-products js-optional-products">
                                <c:forEach var="optionalProduct" items="${productComponent.products}">
                                    <c:if test="${not optionalProduct.addToCartDisabled }">
                                        <c:if test="${not empty optionalProduct.price.oneTimeChargeEntries}">
                                            <c:set var="optionalProductPriceText">
                                                <format:price priceData="${optionalProduct.price.oneTimeChargeEntries[0].price}"/>
                                            </c:set>
                                        </c:if>
                                        <p class="products-details__optional-products--margin">
                                            <input class="products-details__optional-products--checkbox-margin" type="checkbox" name="productCodes" value="${fn:escapeXml(optionalProduct.code)}">${fn:escapeXml(optionalProductPriceText)}
                                            <span class="products-details__optional-products-name">${fn:escapeXml(optionalProduct.name)}</span>
                                        </p>
                                        <input type="hidden" name="bundleTemplateIds" value="${fn:escapeXml(productComponent.id)}">
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:if>
                        <c:choose>
                            <c:when test="${not empty addToCartBtn_label_key}">
                                <button id="${fn:escapeXml(product.code)}" class="primary-button primary-button__default primary-button__event js-submit" type="submit" value="<spring:theme code='${addToCartBtn_label_key}'/>"><spring:message code='basket.add.to.basket.select'/></button>
                            </c:when>
                            <c:otherwise>
                                <button id="${fn:escapeXml(product.code)}" class="primary-button primary-button__default primary-button__event js-submit" type="submit" value="<spring:message code='basket.add.to.basket'/>"><spring:message code='basket.add.to.basket'/></button>
                            </c:otherwise>
                        </c:choose>
                    </form>
                </c:otherwise>
            </c:choose>

        </div>
        <div class="products-prices">
            <c:forEach items="${product.dynamicAttributes}" var="dynamicAttribute" begin="1">
                <div class="products-prices__price-wrapper js-price">
                    <p class="products-prices__price-line">
                        <format:price priceData="${dynamicAttribute.value}"/>
                    </p>
                </div>
            </c:forEach>
            <ycommerce:testId code="product_productPrice">
                <c:forEach items="${comparisonTableColumn.items}" var="oneTimeChargeEntry" varStatus="rowIndex">

                    <%-- In case initialRowsCount is higher than the current row, mark it to be initially hidden from the user --%>
                    <c:if test="${initialRowsCount > 0 and rowIndex.count > initialRowsCount}">
                        <c:set var="hiddenRowClass" value="no-show"/>
                    </c:if>

                    <div class="products-prices__price-wrapper js-price ${hiddenRowClass}">
                        <c:choose>
                            <%-- Case 1: oneTimeChargeEntry does not exist or value is No for the product - display a 'x' mark --%>
                            <c:when test="${empty oneTimeChargeEntry || oneTimeChargeEntry.chargeInformation == 'No'}">
                                <span class="glyphicon glyphicon-remove"></span>
                            </c:when>

                            <%-- Case 2: chargeInformation value is populated - use it for display --%>
                            <c:when test="${not empty oneTimeChargeEntry.chargeInformation}">
                                <p class="products-prices__price-line">
                                        ${fn:escapeXml(oneTimeChargeEntry.chargeInformation)}
                                </p>
                            </c:when>

                            <%-- Case 3: chargeInformation value is empty, the price is 0 - display a Checkmark --%>
                            <c:when test="${empty oneTimeChargeEntry.chargeInformation and oneTimeChargeEntry.price.value <= 0}">
                                <span class="glyphicon glyphicon-ok"></span>
                            </c:when>

                            <%-- Case 4: chargeInformation value is empty, the price has a value - use it for display --%>
                            <c:otherwise>
                                <c:set var="priceText">
                                    <format:price priceData="${oneTimeChargeEntry.price}" />
                                </c:set>
                                <p class="products-prices__price-line">${ycommerce:sanitizeHTML(priceText)}</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>
            </ycommerce:testId>
            <c:forEach items="${product.investments}" var="investmentData" varStatus="investmentRow">
                <spring:url var="factSheetUrl" context="/" value="${investmentData.investmentType.factSheetDocument.downloadUrl}" htmlEscape="false"/>
                <div class="products-prices__price-wrapper js-price-extended">
                    <p class="bold">${investmentData.distributionPercentage}%</p>
                    <a href="${factSheetUrl}" class="highlighted highlighted--bold">${fn:escapeXml(investmentData.investmentType.fundName)}</a>
                    <p class="products-prices__price-line"><spring:theme code="checkout.multi.quoteReview.investments.ISIN" text="ISIN:" />${fn:escapeXml(investmentData.investmentType.isin)}</p>
                    <p class="products-prices__price-line"><spring:theme code="checkout.multi.quoteReview.investments.performance" text="5 Years Performance:" />${investmentData.investmentType.fiveYearPerformance}%</p>
                    <p class="products-prices__price-line"><spring:theme code="checkout.multi.quoteReview.investments.risk.returning" text="Riks & returning rate:" />${fn:escapeXml(investmentData.investmentType.riskReturningRating)}</p>
                </div>
            </c:forEach>
        </div>
            <%-- If rows are hidden display horizontal line instead --%>
        <c:if test="${fn:length(hiddenRowClass) > 0}">
            <div class="separator"></div>
        </c:if>
            <%-- More Info Button --%>
        <spring:url var="moreInfoUrl" value="${product.defaultCategory.parentCategory.url}" htmlEscape="false"/>
        <a class="secondary-button__default secondary-button__single-checkout" href="${moreInfoUrl}">
            <spring:message code="text.product.moreInfo" text="More Info"/>
        </a>

        <c:choose>
            <c:when test="${product.stock.stockLevelStatus.code eq 'outOfStock' }">
                <spring:theme code="text.addToCart.outOfStock" var="addToCartText"/>
                <span class='listProductLowStock listProductOutOfStock mlist-stock'>${addToCartText}</span>
            </c:when>
        </c:choose>

        <c:set var="product" value="${product}" scope="request"/>
        <c:set var="addToCartText" value="${addToCartText}" scope="request"/>
        <c:set var="addToCartUrl" value="${addToCartUrl}" scope="request"/>

    </div>
</ycommerce:testId>

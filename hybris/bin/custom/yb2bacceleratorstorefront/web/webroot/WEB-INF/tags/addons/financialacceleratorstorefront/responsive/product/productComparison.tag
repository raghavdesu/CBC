<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="columns" required="true" type="java.lang.Integer" %>
<%@ attribute name="initialRowsCount" required="false" type="java.lang.Integer" %>
<%@ attribute name="addToCartBtn_label_key" required="false" type="java.lang.String" %>
<%@ attribute name="searchPageData" required="true" type="de.hybris.platform.commerceservices.search.pagedata.SearchPageData" %>
<%@ attribute name="showOptionalProducts" required="false" type="java.lang.Boolean" %>
<%@ attribute name="imageComponent" required="false" type="de.hybris.platform.cms2.model.contents.components.CMSImageComponentModel" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="financialtags" uri="http://hybris.com/tld/financialtags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/product" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<financialtags:comparisonTable searchPageData="${searchPageData}" tableFactory="insuranceComparisonTableFactory" var="comparisonTable"/>
<c:if test="${empty comparisonTable }">
    <script>
        window.location.replace("${request.contextPath}");
    </script>
</c:if>

<c:set value="label" var="labelcolumnkey"/>
<c:set var="detailsCss" value="products-details js-details"/>
<c:if test="${showOptionalProducts eq false}">
    <c:set var="detailsCss" value="products-details js-details"/>
</c:if>
<%-- Label column at the left hand side.--%>
<div class="products products__wrapper">
    <div class="products__labels">
        <div class="js-product-grid-item">
          	<div class="${detailsCss}">
	          	<div class="category-image">
		            <c:if test="${not empty imageComponent.media}">
		            	<img src="${imageComponent.media.url}" id="categoryImage" />
		            </c:if>
	            </div>
                <div class="products-prices__label-name">
                    <c:forEach items="${comparisonTable.columns}" var="column" end="1">
                        <c:if test="${column.key.getClass().name =='de.hybris.platform.commercefacades.product.data.ProductData' and not empty column.key.dynamicAttributes}">
                            <c:forEach items="${column.key.dynamicAttributes}" var="dynamicAttribute" end="0">
                                <spring:theme code="text.dynamicAttribute.label.${dynamicAttribute.key}"/>
                            </c:forEach>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
            <div class="products-prices">
                <c:forEach items="${searchPageData.results.get(0).dynamicAttributes}" var="dynamicAttribute" begin="1">
                    <div class="products-prices__price-wrapper js-price">
                        <div class="products-prices__label-name"><spring:theme code="text.dynamicAttribute.label.${dynamicAttribute.key}" text="Dynamic Attribute"/></div>
                        <div class="holder holder__wrapper">
                            <div class="holder__tooltip js-tooltip">i</div>
                            <span class="holder__tip js-tip">
                                <span class="holder__close-tip js-close-tip">&#215;</span>
                                <span class="holder__content-tip"><spring:theme code="text.dynamicAttribute.tooltip.${dynamicAttribute.key}" text="Dynamic Attribute"/></span>
                            </span>
                        </div>
                    </div>
                </c:forEach>

                <c:forEach var="label" items="${comparisonTable.columns[labelcolumnkey].items}" varStatus="rowIndex">

                    <%-- In case initialRowsCount is higher than the current row, mark it to be initially hidden from the user --%>
                    <c:if test="${initialRowsCount > 0 and rowIndex.count > initialRowsCount}">
                        <c:set var="hiddenRowClass" value="no-show"/>
                    </c:if>

                    <div class="products-prices__price-wrapper js-price ${hiddenRowClass}">
                        <c:choose>
                            <c:when test="${not empty label.helpContent}">
                                <div class="products-prices__label-name-link">${fn:escapeXml(label.name)}</div>
                            </c:when>
                            <c:otherwise>
                                <div class="products-prices__label-name">${fn:escapeXml(label.name)}</div>
                            </c:otherwise>
                        </c:choose>
                        <c:if test="${not empty label.helpContent}">
                            <div class="holder holder__wrapper">
                                <div class="holder__tooltip js-tooltip">i</div>
                                <span class="holder__tip js-tip">
                                <span class="holder__close-tip js-close-tip">&#215;</span>
                                <span class="holder__content-tip">${fn:escapeXml(label.helpContent)}</span>
                            </span>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
	            <%-- If rows are hidden display more features button --%>
	            <c:if test="${fn:length(hiddenRowClass) > 0}">
	            	<a class="secondary-button__default secondary-button__single-checkout js-more-features" data-real-title="<spring:message code='text.product.moreFeatures' text='More Features'/>" data-opposite-title="<spring:message code='text.product.lessFeatures' text='Less Features'/>" href="#"></a>
                </c:if>

                <c:if test="${not empty searchPageData.results.get(0).investments}">
                    <div class="products-prices__price-wrapper js-price">
                        <div class="products-prices__label-name"><spring:theme code="text.investments.label" text="Investments"/></div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    <div class="products__grid table-responsive">
        <%--Product details in columns for comparison--%>
        <div class="products__items">
            <c:if test="${not empty comparisonTable.columns}">
                <c:forEach items="${comparisonTable.columns}" var="columnTable">

                    <c:if test="${columnTable.key.getClass().name =='de.hybris.platform.commercefacades.product.data.ProductData'}">
                        <div class="products__item">
                            <product:productComparisonItem comparisonTable="${comparisonTable}"
                                                           comparisonTableColumn="${columnTable.value}"
                                                           product="${columnTable.key}"
                                                           showOptionalProducts="${showOptionalProducts}"
                                                           addToCartBtn_label_key="${addToCartBtn_label_key}"
                                                           initialRowsCount="${initialRowsCount}"/>
                        </div>
                    </c:if>
                </c:forEach>
            </c:if>
        </div>
    </div>
</div>

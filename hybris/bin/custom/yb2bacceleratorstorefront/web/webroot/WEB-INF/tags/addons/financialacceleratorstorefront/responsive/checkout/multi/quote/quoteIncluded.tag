<%@ attribute name="insuranceQuoteReviews" required="true" type="java.util.List<de.hybris.platform.commercefacades.insurance.data.InsuranceQuoteReviewData>" %>
<%@ attribute name="openSection" required="false" type="java.lang.Boolean" %>
<%@ attribute name="isValidStep" required="false" type="java.lang.Boolean" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="financialCart" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/cart" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<c:if test="${openSection}">
    <c:set var="activeClass" value="active" />
    <c:set var="openedClass" value="opened" />
</c:if>

<c:if test="${not empty insuranceQuoteReviews}">
    <c:forEach items="${insuranceQuoteReviews}" var="quoteReview">
        <c:if test="${not empty quoteReview.mainProduct.benefits}">
            <c:choose>
                <c:when test="${isValidStep == 'true'}"> <c:set var="isValidClass" value="accordion-item__heading accordion-item--valid js-toggle"/></c:when>
                <c:otherwise><c:set var="isValidClass" value="accordion-item__heading accordion-item--invalid js-toggle"/></c:otherwise>
            </c:choose>
            <h2 class="${isValidClass} ${activeClass}">
                <spring:theme code="checkout.multi.quoteReview.included" text="Whats Included" />
                <c:if test="${isValidStep == 'true'}">
                    <span class="accordion-item__open" data-open="whatsIncludedPanel"></span>
                </c:if>
            </h2>

            <c:if test="${isValidStep == 'true'}">
                <div id="whatsIncludedPanel" class="accordion-item__body ${openedClass}">
                    <div class="col-md-9 col-sm-9 col-xs-12">
                        <c:if test="${empty quoteReview.mainProduct.benefits}">
                            <p class="accordion-item__text">
                                <spring:theme code="checkout.multi.quoteReview.included.empty" text="-" />
                            </p>
                        </c:if>
                        <ul class="accordion-item__list accordion-item__list--style-type">
                            <c:forEach var="includedItem" items="${quoteReview.mainProduct.benefits}">
                                <li class="accordion-item__list-item">
                                    <div class="col-xs-6">${fn:escapeXml(includedItem.name)}:</div>
                                    <c:choose>
                                        <c:when test="${not empty fn:escapeXml(includedItem.coverageValue) and fn:escapeXml(includedItem.coverageValue).matches('.*[1-9].*')}">
                                            <div class="col-xs-6">${fn:escapeXml(includedItem.coverageValue)}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="col-xs-6">
                                                <span class="glyphicon glyphicon-ok"></span>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                    <c:set var="singleConfigurableProduct" value="${quoteReview.mainProduct.coverageProduct.bundleTemplates[0].products.size() == 1 and cartData.insuranceQuote.configurable}" />
                    <c:if test="${cartData.insuranceQuote.state eq 'UNBIND'and !singleConfigurableProduct}">
                        <spring:url var="editInformationUrl" value="/c/${quoteReview.mainProduct.coverageProduct.defaultCategory.code}" htmlEscape="false">
                            <spring:param value="view" name="viewStatus"/>
                        </spring:url>
                        <div class="col-md-3 col-sm-3 col-xs-12 accordion-item__button">
                            <a class="secondary-button secondary-button__default secondary-button__edit" href="${editInformationUrl}"><spring:theme code="text.cmsformsubmitcomponent.edit" text="Edit"/></a>
                        </div>
                    </c:if>
                </div>
            </c:if>
        </c:if>
    </c:forEach>
</c:if>

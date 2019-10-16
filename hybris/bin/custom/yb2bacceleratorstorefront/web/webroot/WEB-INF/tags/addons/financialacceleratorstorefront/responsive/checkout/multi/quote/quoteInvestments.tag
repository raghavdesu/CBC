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
        <c:if test="${not empty quoteReview.mainProduct.coverageProduct.investments}">
            <c:choose>
                <c:when test="${isValidStep == 'true'}"> <c:set var="isValidClass" value="accordion-item__heading accordion-item--valid js-toggle"/></c:when>
                <c:otherwise><c:set var="isValidClass" value="accordion-item__heading accordion-item--invalid js-toggle"/></c:otherwise>
            </c:choose>
            <h2 class="${isValidClass} ${activeClass}">
                <spring:theme code="checkout.multi.quoteReview.investments" text="Investment Details" />
                <c:if test="${isValidStep == 'true'}">
                    <span class="accordion-item__open" data-open="investmentsPanel"></span>
                </c:if>
            </h2>

            <c:if test="${isValidStep == 'true'}">
                <div id="whatsIncludedPanel" class="accordion-item__body ${openedClass}">
                    <div class="col-md-9 col-sm-9 col-xs-12">
                        <c:if test="${empty quoteReview.mainProduct.coverageProduct.investments}">
                            <p class="accordion-item__text">
                                <spring:theme code="checkout.multi.quoteReview.included.empty" text="-" />
                            </p>
                        </c:if>
                        <ul class="accordion-item__list">
                            <c:forEach var="investment" items="${quoteReview.mainProduct.coverageProduct.investments}">
                                <li class="accordion-item__list-item margin-b-20">
                                    <div class="row">
                                        <div class="col-xs-6">
                                                ${fn:escapeXml(investment.investmentType.fundName)}:
                                        </div>
                                        <div class="col-xs-6">
                                            <spring:theme code="checkout.multi.quoteReview.investments.fund.percentage" arguments="${investment.distributionPercentage}"/>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-6">
                                            <spring:theme code="checkout.multi.quoteReview.investments.ISIN" text="ISIN:" />
                                        </div>
                                        <div class="col-xs-6">
                                                ${fn:escapeXml(investment.investmentType.isin)}
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-6">
                                            <spring:theme code="checkout.multi.quoteReview.investments.performance" text="5 Years Performance:" />
                                        </div>
                                        <div class="col-xs-6">
                                            <spring:theme code="checkout.multi.quoteReview.investments.performance.value" arguments="${investment.investmentType.fiveYearPerformance}"/>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-6">
                                            <spring:theme code="checkout.multi.quoteReview.investments.risk.returning" text="Riks returning rate:" />
                                        </div>
                                        <div class="col-xs-6">
                                                ${fn:escapeXml(investment.investmentType.riskReturningRating)}
                                        </div>
                                    </div>
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

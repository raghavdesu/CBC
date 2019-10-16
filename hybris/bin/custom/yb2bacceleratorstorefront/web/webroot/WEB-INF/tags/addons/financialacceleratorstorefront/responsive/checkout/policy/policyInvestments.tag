<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="policyData" required="true" type="de.hybris.platform.commercefacades.insurance.data.InsurancePolicyData" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<spring:htmlEscape defaultHtmlEscape="true" />

<h2 class="accordion-item__heading accordion-item--valid js-toggle">
    <spring:theme code="checkout.orderConfirmation.investments" text="Investment Details"/>
    <span class="accordion-item__open" data-open="investmentsPanel"></span>
</h2>

<c:if test="${not empty policyData.mainProduct.coverageProduct.investments}">
    <div id="optionalExtras" class="accordion-item__body">
        <div class="col-md-9 col-sm-9 col-xs-12">
            <ul class="accordion-item__list">
                <c:forEach var="investment" items="${policyData.mainProduct.coverageProduct.investments}">
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
    </div>
</c:if>


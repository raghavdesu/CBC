<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="formatter" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/format" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="agent" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/agent" %>
<%@ taglib prefix="account" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/account" %>
<spring:htmlEscape defaultHtmlEscape="true"/>

<h2 class="policy-spec account-section-content__headline"><%-- Very important to attach "active" class to the first block so it loads as opened. This should be kept in mind when looping through policies--%>
    <span class="images images__wrapper">
    <c:if test="${not empty policy.mainProduct}">
        <c:if test="${not empty policy.mainProduct.coverageProduct}">
            <c:forEach items="${policy.mainProduct.coverageProduct.images}" var="image">
                <c:if test="${image.format == '40Wx40H_policy_responsive'}">
                    <c:set var="thumbnail_img" value="${image}"/>
                </c:if>
            </c:forEach>
            <c:if test="${not empty thumbnail_img}"><img class="images__size" src="${thumbnail_img.url}" alt=""/></c:if>
        </c:if>
    </c:if>
	</span>
    <span class="account-section-content__headline--title">
        <c:if test="${not empty policy.categoryData}">
            ${fn:escapeXml(policy.categoryData.name)}&nbsp;<spring:theme code="policy.details.document"/> <br>
            ${fn:escapeXml(policy.mainProduct.coverageProduct.name)}
        </c:if>
    </span>
    <span class="account-section-content__headline--number">
        ${fn:escapeXml(policy.policyNumber)}
    </span>
    <a href="<spring:url value="/my-account/my-policies" htmlEscape="false"/>"
       class="account-section-content__headline--back"></a>
</h2>
<c:set var="insuredObject" value="${policy.insuredObjects[0]}"/>
<c:set var="insuredObjectType" value=""/>
<c:if test="${not empty insuredObject}">
    <c:set var="insuredObjectType" value="${fn:toLowerCase(insuredObject.insuredObjectType)}"/>
    <c:if test="${not empty insuredObject.childInsuredObjects}">
        <c:set var="childInsuredObject" value="${insuredObject.childInsuredObjects[0]}"/>
        <c:set var="childInsuredObjectType" value="${fn:toLowerCase(insuredObject.childInsuredObjects[0].insuredObjectType)}"/>
    </c:if>
</c:if>
<div class="accordion">
    <div class="accordion-item accordion-item--margin-t-30 clearfix">
        <div class="accordion-item__wrapper">
            <h2 class="accordion-item__heading accordion-item__heading--gradient js-toggle active">
                <span class="accordion-item__open"></span>
                <spring:theme code="policy.details.title.summary"/></h2>
            <div class="accordion-item__body opened">
                <ul class="accordion-item__list accordion-item__list--enhanced">
                    <li class="accordion-item__list-item ">
                        <div class="col-xs-6 col-sm-3 accordion-item__title bold">
                            <spring:theme code="text.account.myPolicies.policy.contractID" text="Contract ID"/>
                        </div>
                        <div class="col-xs-6 col-sm-3 accordion-item__value notice notice--dark">
                            ${fn:escapeXml(policy.contractNumber)}
                        </div>
                        <div class="col-xs-12 col-sm-6"></div>
                    </li>
                    <li class="accordion-item__list-item ">
                        <div class="col-xs-6 col-sm-3 accordion-item__title bold">
                            <spring:theme code="text.account.myPolicies.policy.product" text="Product"/>
                        </div>
                        <div class="col-xs-6 col-sm-3 accordion-item__value notice notice--dark">
                            ${fn:escapeXml(policy.mainProduct.coverageProduct.name)}
                        </div>
                        <div class="col-xs-12 col-sm-6"></div>
                    </li>
                    <li class="accordion-item__list-item">
                        <c:choose>
                            <c:when test="${policy.mainProduct.investmentInfo.size() gt 0}">
                                <div class="col-xs-6 col-sm-3 accordion-item__title bold">
                                    <spring:theme code="policy.payment.contribution"/>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="col-xs-6 col-sm-3 accordion-item__title bold">
                                    <spring:theme code="policy.payment.premium"/>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="col-xs-6 col-sm-3 accordion-item__value notice notice--dark">
                            <c:if test="${not empty policy.recurringPrice}">
                                <format:price priceData="${policy.recurringPrice}"/>
                            </c:if>
                        </div>
                        <div class="col-xs-12 col-sm-6"></div>
                    </li>
                    <li class="accordion-item__list-item  ">
                        <div class="col-xs-6 col-sm-3 accordion-item__title bold"><spring:theme
                                code="policy.payment.frequency"/></div>
                        <div class="col-xs-6 col-sm-3 accordion-item__value notice notice--dark">
                            <c:if test="${not empty policy.paymentFrequency}">
                                ${fn:escapeXml(policy.paymentFrequency)}
                            </c:if>
                        </div>
                        <div class="col-xs-12 col-sm-6"></div>
                    </li>
                    <li class="accordion-item__list-item ">
                        <div class="col-xs-6 col-sm-3 accordion-item__title bold"><spring:theme
                                code="policy.payment.method"/></div>
                        <div class="col-xs-6 col-sm-3 accordion-item__value notice notice--dark">
                            <c:choose>
                                <c:when test="${not empty policy.paymentMethod}">
                                    <spring:theme code="policy.payment.method.${policy.paymentMethod.paymentOption}"/>
                                </c:when>
                                <c:otherwise>
                                    <spring:theme code="text.not.available" text="N/A"/>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="col-xs-12 col-sm-6"></div>
                    </li>
                    <li class="accordion-item__list-item ">
                        <div class="col-xs-6 col-sm-3 accordion-item__title bold"><spring:theme
                                code="policy.payment.period"/></div>
                        <div class="col-xs-6 col-sm-3 accordion-item__value notice notice--dark">
                            <span class="accordion-item__date">
                                <formatter:stringToDate inputValue="${policy.policyStartDate}" inputDatePattern="dd-MM-yyyy" outputDatePattern="dd MMM yyyy"/>-
                                <formatter:stringToDate inputValue="${policy.policyEndDate}" inputDatePattern="dd-MM-yyyy" outputDatePattern="dd MMM yyyy"/>
                            </span>
                        </div>
                        <div class="col-xs-12 col-sm-6 "></div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <div class="accordion-item accordion-item--margin-t-30 clearfix">
        <div class="accordion-item__wrapper">
            <h2 class="accordion-item__heading accordion-item__heading--gradient js-toggle">
                <span class="accordion-item__open"></span>
                <spring:theme code="policy.details.title.insured.object"/>
            </h2>
            <div class="accordion-item__body">
                <h4 class="bold">
                    <spring:theme code="policy.details.${fn:toLowerCase(insuredObject.insuredObjectType)}.title"/>
                </h4>
                <account:insuredObjectDetails insuredObjects="${insuredObject.insuredObjectItems}"
                                              insuredObjectType="${insuredObjectType}"/>
                <c:if test="${not empty childInsuredObject}">
                    <h4 class="bold">
                        <spring:theme code="policy.details.driver.title"/>
                    </h4>
                    <account:insuredObjectDetails insuredObjects="${childInsuredObject.insuredObjectItems}"
                                                  insuredObjectType="${childInsuredObjectType}"/>
                    <div class="col-xs-6 col-sm-3 accordion-item__title bold">
                        <spring:theme code="policy.details.numberOfAdditionalDrivers"/>
                    </div>
                    <div class="col-xs-6 col-sm-3 accordion-item__value notice notice--dark">
                            ${insuredObject.childInsuredObjects.size() - 1}
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    <div class="accordion-item accordion-item--margin-t-30 clearfix">
        <div class="accordion-item__wrapper">
            <h2 class="accordion-item__heading accordion-item__heading--gradient js-toggle">
                <span class="accordion-item__open"></span>
                <spring:theme code="policy.details.title.included"/>
            </h2>
            <div class="accordion-item__body">
                <ul class="accordion-item__list accordion-item__list--enhanced">
                    <c:if test="${not empty policy.mainProduct}">
                        <c:forEach items="${policy.mainProduct.benefits}" var="benefit">
                            <li class="accordion-item__list-item ">
                                <div class="col-xs-6 col-sm-3 accordion-item__title bold">
                                        ${fn:escapeXml(benefit.name)}
                                </div>
                                <div class="col-xs-6 col-sm-3 accordion-item__value notice notice--dark">
                                    <c:if test="${not empty benefit.coverageValue}">
                                        <spring:theme
                                                code="policy.details.title.coverage.limit"/> ${fn:escapeXml(benefit.coverageValue)}
                                    </c:if>
                                    <c:if test="${not empty benefit.coverageInformation}">
                                        ${fn:escapeXml(benefit.coverageInformation)}
                                    </c:if>
                                </div>
                                <div class="col-xs-12 col-sm-6"></div>
                            </li>
                        </c:forEach>
                    </c:if>
                </ul>
            </div>
        </div>
    </div>
    <div class="accordion-item accordion-item--margin-t-30 clearfix">
        <div class="accordion-item__wrapper">
            <h2 class="accordion-item__heading accordion-item__heading--gradient js-toggle">
                <span class="accordion-item__open"></span>
                <spring:theme code="policy.details.title.optional.extras"/>
            </h2>
            <div class="accordion-item__body">
                <ul class="accordion-item__list accordion-item__list--enhanced">
                    <c:forEach items="${policy.optionalProducts}" var="optionalCoverage">
                        <li class="accordion-item__list-item">
                            <div class="col-xs-6 col-sm-3 accordion-item__title bold">
                                    ${fn:escapeXml(optionalCoverage.coverageProduct.name)}
                            </div>
                            <div class="col-xs-6 col-sm-3 accordion-item__value notice notice--dark">
                                <c:choose>
                                    <c:when test="${optionalCoverage.coverageIsIncluded}">
                                        <spring:theme code="policy.details.coverage.included"/>
                                    </c:when>
                                    <c:otherwise>
                                        <spring:theme code="policy.details.coverage.excluded"/>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="col-xs-12 col-sm-6"></div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>
    <c:if test="${not empty policy.mainProduct.investmentInfo}">
        <div class="accordion-item accordion-item--margin-t-30 clearfix">
            <div class="accordion-item__wrapper">
                <h2 class="accordion-item__heading accordion-item__heading--gradient js-toggle">
                    <span class="accordion-item__open"></span>
                    <spring:theme code="policy.details.title.investments"/>
                </h2>
                <div class="accordion-item__body">
                    <ul class="accordion-item__list accordion-item__list--enhanced">
                        <c:forEach items="${policy.mainProduct.investmentInfo}" var="investmentInfoItem">
                            <li class="accordion-item__list-item">
                                <div>
                                    <div class="col-xs-6 col-sm-3 accordion-item__title bold">
                                            ${fn:escapeXml(investmentInfoItem.investmentType.fundName)}
                                    </div>
                                    <div class="col-xs-6 col-sm-3 accordion-item__value notice notice--dark">
                                            ${investmentInfoItem.distributionPercentage}&#37;
                                    </div>
                                </div>
                            </li>
                            <li class="accordion-item__list-item">
                                <div>
                                    <div class="col-xs-6 col-sm-3 accordion-item__title bold">
                                        <spring:theme code="policy.details.investments.isin"/>
                                    </div>
                                    <div class="col-xs-6 col-sm-3 accordion-item__value notice notice--dark">
                                            ${fn:escapeXml(investmentInfoItem.investmentType.isin)}
                                    </div>
                                </div>
                            </li>
                            <li class="accordion-item__list-item">
                                <div>
                                    <div class="col-xs-6 col-sm-3 accordion-item__title bold">
                                        <spring:theme code="policy.details.investments.year.performance"/>
                                    </div>
                                    <div class="col-xs-6 col-sm-3 accordion-item__value notice notice--dark">
                                            ${investmentInfoItem.investmentType.fiveYearPerformance}&#37;
                                    </div>
                                </div>
                            </li>
                            <li class="accordion-item__list-item">
                                <div>
                                    <div class="col-xs-6 col-sm-3 accordion-item__title bold">
                                        <spring:theme code="policy.details.investments.risk.returning"/>
                                    </div>
                                    <div class="col-xs-6 col-sm-3 accordion-item__value notice notice--dark">
                                            ${fn:escapeXml(investmentInfoItem.investmentType.riskReturningRating)}
                                    </div>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
    </c:if>

    <div class="accordion-item accordion-item--margin-t-30 clearfix">
        <div class="accordion-item__wrapper">
            <h2 class="accordion-item__heading accordion-item__heading--gradient  js-toggle">
                <span class="accordion-item__open"></span>
                <spring:theme code="policy.details.title.cost"/>
            </h2>
            <div class="accordion-item__body">
                <ul class="accordion-item__list accordion-item__list--enhanced">
                    <li class="accordion-item__list-item">
                        <c:choose>
                            <c:when test="${policy.mainProduct.investmentInfo.size() gt 0}">
                                <div class="col-xs-6 col-sm-3 accordion-item__title bold">
                                    <spring:theme code="policy.payment.contribution"/>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="col-xs-6 col-sm-3 accordion-item__title bold">
                                    <spring:theme code="policy.payment.premium"/>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="col-xs-6 col-sm-3 accordion-item__value notice notice--dark">
                            <c:if test="${not empty policy.recurringPrice}">
                                <format:price priceData="${policy.recurringPrice}"/>
                            </c:if>
                        </div>
                        <div class="col-xs-12 col-sm-6 "></div>
                    </li>
                    <li class="accordion-item__list-item ">
                        <div class="col-xs-6 col-sm-3 accordion-item__title bold">
                            <spring:theme code="policy.payment.frequency"/>
                        </div>
                        <div class="col-xs-6 col-sm-3 accordion-item__value notice notice--dark">
                            <c:if test="${not empty policy.paymentFrequency}">
                                ${fn:escapeXml(policy.paymentFrequency)}
                            </c:if>
                        </div>
                        <div class="col-xs-12 col-sm-6 "></div>
                    </li>
                    <li class="accordion-item__list-item">
                        <div class="col-xs-6 col-sm-3 accordion-item__title bold">
                            <spring:theme code="policy.payment.method"/>
                        </div>
                        <div class="col-xs-6 col-sm-3 accordion-item__value notice notice--dark">
                            <c:choose>
                                <c:when test="${not empty policy.paymentMethod}">
                                    <spring:theme code="policy.payment.method.${policy.paymentMethod.paymentOption}"/>
                                </c:when>
                                <c:otherwise>
                                    <spring:theme code="text.not.available" text="N/A"/>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="col-xs-12 col-sm-6"></div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <div class="accordion-item accordion-item--margin-t-30 clearfix">
        <div class="accordion-item__wrapper">
            <h2 class="accordion-item__heading accordion-item__heading--gradient  js-toggle">
                <span class="accordion-item__open"></span>
                <spring:theme code="policy.details.title.documents"/>
            </h2>
            <div class="accordion-item__body">
                <ul class="accordion-item__list accordion-item__list--enhanced">
                    <li class="accordion-item__list-item">
                        <div class="col-xs-6 col-sm-3 accordion-item__title bold">
                            <spring:theme code="policy.details.document"/>
                        </div>
                        <div class="col-xs-6 col-sm-3 accordion-item__value notice notice--dark">
                            <formatter:stringToDate inputValue="${policy.policyStartDate}" inputDatePattern="dd-MM-yyyy" outputDatePattern="dd MMM yyyy"/>
                        </div>
                        <div class="col-xs-12 col-sm-6 accordion-item__download">
                            <a href="${request.contextPath}/my-account/pdf/print/${ycommerce:encodeUrl(policy.policyNumber)}&#47;${ycommerce:encodeUrl(policy.contractNumber)}" target="_blank"  class="accordion-item__image accordion-item__image--policy"></a>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <c:if test="${not empty policy.responsibleAgent}">
        <div class="accordion-item accordion-item--margin-t-30 clearfix">
            <div class="accordion-item__wrapper">
                <h2 class="accordion-item__heading accordion-item__heading--gradient  js-toggle">
                    <span class="accordion-item__open"></span>
                    <spring:theme code="policy.details.agent"/>
                </h2>
                <div class="accordion-item__body">
                    <agent:agentInfo agent="${policy.responsibleAgent}"/>
                </div>
            </div>
        </div>
    </c:if>
</div>

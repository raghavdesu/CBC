<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="formatter" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/format" %>
<spring:htmlEscape defaultHtmlEscape="true"/>

<spring:url value="/my-account/policy/" var="policyDetailsUrl" htmlEscape="false"/>
<spring:url value="/claims/" var="claimsUrl" htmlEscape="false"/>

<h2 class="heading-headline">
    <spring:theme code="text.account.policyDetails" text="Policy Details"/>
</h2>

<c:choose>
    <c:when test="${empty policies}">
        <p>
            <spring:theme code="text.account.myPolicies.noPolicies" text="You have no valid policies"/>
        </p>
    </c:when>
    <c:otherwise>
        <div class="row">
            <c:forEach items="${policies}" var="policy">
                <c:set var="insuredObject" value="${policy.insuredObjects[0]}"/>
                <div class="col-xs-12 col-sm-6 col-md-4 cards">
                    <div class="cards__wrapper cards__wrapper--border-primary">
                        <div class="cards__title cards__title--border-primary">
                            <span class="images images__wrapper">
                                <c:if test="${not empty policy.mainProduct.coverageProduct}">
                                    <c:forEach items="${policy.mainProduct.coverageProduct.images}" var="image">
                                        <c:if test="${image.format == '40Wx40H_policy_responsive'}">
                                            <c:set var="thumbnail_img" value="${image}"/>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
	                    		<c:if test="${not empty thumbnail_img}">
                                    <img class="images__size" src="${thumbnail_img.url}" alt=""/>
                                </c:if>
                    		</span>
                            <h4 class="cards__caption cards__caption--color-primary">
                                <c:if test="${not empty policy.categoryData}">
                                    ${fn:escapeXml(policy.categoryData.name)}&nbsp;<spring:theme code="policy.details.document"/>
                                </c:if>
                            </h4>
                            <div class="cards__info cards__info--color-primary">
                                    ${fn:escapeXml(policy.policyNumber)}
                            </div>
                        </div>
                        <div class="cards__details-wrapper">
                            <div class="cards__data">
                                <span class="title">
                                        <spring:theme code="text.account.myPolicies.policy.product" text="Product"/>
                                </span>
                                <span class="value">
                                        ${fn:escapeXml(policy.mainProduct.coverageProduct.name)}
                                </span>
                            </div>
                            <div class="cards__data">
                                <c:if test="${not empty insuredObject}">
                                    <c:if test="${not empty insuredObject.insuredObjectItems[0]}">
	                                    <span class="title">
                                                ${fn:escapeXml(insuredObject.insuredObjectItems[0].value)}
                                        </span>
                                    </c:if>

                                    <c:if test="${not empty insuredObject.insuredObjectItems[1]}">
                                    	<span class="value">
                                                ${fn:escapeXml(insuredObject.insuredObjectItems[1].value)}
                                        </span>
                                    </c:if>
                                </c:if>
                            </div>
                            <div class="cards__data">
                            	<span class="title">
	                                <c:if test="${not empty policy.recurringPrice}"> <format:price priceData="${policy.recurringPrice}"/>
                                        / ${fn:escapeXml(policy.paymentFrequency)}
                                    </c:if>
                                </span>
                                <span class="value">
	                                <c:choose>
                                        <c:when test="${not empty policy.paymentMethod}">
                                            <spring:theme code="policy.payment.method.${policy.paymentMethod.paymentOption}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <spring:theme code="policy.payment.method.notAvailable" text="n/a"/>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="cards__data">
	                            <span class="title">
	                                <formatter:stringToDate inputValue="${policy.policyStartDate}" inputDatePattern="dd-MM-yyyy" outputDatePattern="dd MMM yyyy"/> -
	                                <formatter:stringToDate inputValue="${policy.policyEndDate}" inputDatePattern="dd-MM-yyyy" outputDatePattern="dd MMM yyyy"/>
	                            </span>
                            </div>
                        </div>
                        <div class="cards-button-wrapper cards-button-wrapper--border-primary">
                            <div class="cards__button">
                                <a class="secondary-button secondary-button__default secondary-button__account-policies" href="${policyDetailsUrl}${ycommerce:encodeUrl(policy.policyNumber)}&#47;${ycommerce:encodeUrl(policy.contractNumber)}">
                                    <spring:theme code="text.account.myPolicies.policy.view" text="View Policy"/>
                                </a>
                                <c:choose>
                                    <c:when test="${not empty policy.categoryData.allowedFSRequestTypes}">
                                        <c:forEach items="${policy.categoryData.allowedFSRequestTypes}" var="allowedFSRequestType">
                                            <c:if test="${allowedFSRequestType.requestType.code == 'FSCLAIM'}">
                                                <a class="primary-button primary-button__default primary-button__account-policies"
                                                   href="${claimsUrl}${ycommerce:encodeUrl(policy.categoryData.code)}">
                                                    <spring:theme code="text.account.myPolicies.policy.makeClaim" text="Make a Claim"/>
                                                </a>
                                            </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="primary-button primary-button__default primary-button__account-policies" disabled="true">
                                            <spring:theme code="text.not.available" text="N/A"/>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>

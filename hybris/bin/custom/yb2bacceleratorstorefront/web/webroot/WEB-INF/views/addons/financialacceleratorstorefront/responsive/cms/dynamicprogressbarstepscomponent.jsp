<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="financialtags" uri="http://hybris.com/tld/financialtags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<c:url value="${requestScope['javax.servlet.forward.servlet_path']}?${requestScope['javax.servlet.forward.query_string']}" var="currentUrl"/>
<c:url value="${requestScope['javax.servlet.forward.servlet_path']}" var="categoryUrl"/>
<c:set var="queryStringEdit" value="?viewStatus=edit"/>

<c:set var="queryString" value="${requestScope['javax.servlet.forward.query_string']}"/>
<financialtags:progressStepsBar var="progressBar" progressStepMapKey="${progressStepMapKey}" currentUrl="${currentUrl}"/>
<div class="checkout-progress ${styleClass}">
    <c:if test="${not empty categoryName}">
        <h2 class="checkout-progress__heading"><spring:theme code="checkout.progress.bar.insurance.label.${fn:toLowerCase(cmsSite.channel)}" text="Your Insurance Quote is in progress" arguments="${categoryName}"/></h2>
    </c:if>
    <ul data-role="navbar" id="checkoutProgress" class="checkout-progress__body steps-${fn:length(components)}">
        <c:set var="adjacentStepsStatusCss" value="visited"/>
        <c:set var="nextActiveStep" value="false"/>
        <c:forEach items="${progressBar}" var="progressEntry" varStatus="entryStatus">

            <c:set value="${progressEntry.value}" var="checkoutStep"/>
            <c:set var="isActive" value="false"/>
            <c:set var="isEnabled" value="${checkoutStep.isEnabled}"/>

            <c:choose>
                <c:when test="${!currentProductInCart and cartData.entries[0].product.defaultCategory.name ne categoryName and !entryStatus.first and !(entryStatus.index==1 and fn:contains(currentUrl, 'viewStatus=view'))}">
                    <c:set var="currentStepIndicator" value="unset" />
                    <c:set var="adjacentStepsStatusCss" value="disabled"/>
                    <c:set var="nextActiveStep" value="false"/>
                </c:when>
                <c:otherwise>
                    <c:choose>
                        <c:when test="${checkoutStep.currentStatus eq 'unset'}">
                            <c:set var="currentStepIndicator" value="unset" />
                        </c:when>
                        <c:when test="${checkoutStep.currentStatus eq 'invalid'}">
                            <c:set var="currentStepIndicator" value="invalid" />
                        </c:when>
                        <c:otherwise>
                            <c:set var="currentStepIndicator" value="valid" />
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${not empty checkoutStep.activeStep}">
                            <spring:url var="stepUrl" value="${checkoutStep.activeStep}" htmlEscape="false"/>
                            <c:choose>
                                <c:when test="${checkoutStep.progressBarId eq 'change-plan' and fn:contains(categoryUrl, '/c/')}">
                                    <spring:url var="linkUrl" value="${categoryUrl}${queryStringEdit}" htmlEscape="false"/>
                                </c:when>
                                <c:when test="${checkoutStep.progressBarId eq 'configure-product' and fn:contains(categoryUrl, '/p/')}">
                                    <spring:url var="linkUrl" value="${categoryUrl}${queryStringEdit}" htmlEscape="false"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set value="${stepUrl}" var="linkUrl"/>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <c:set value="" var="linkUrl"/>
                        </c:otherwise>
                    </c:choose>

                    <c:if test="${not empty checkoutStep.alternativeActiveStep}">
                        <c:set value="${checkoutStep.alternativeActiveStep}" var="activeUrl"/>
                        <c:if test="${fn:contains(currentUrl, activeUrl)}">
                            <c:set var="isActive" value="true"/>
                        </c:if>
                    </c:if>

                    <c:if test="${not empty stepUrl and fn:contains(currentUrl, stepUrl)}">
                        <c:set var="isActive" value="true"/>
                    </c:if>

                    <c:if test="${checkoutStep.progressBarId eq 'change-plan' and fn:contains(queryString, 'viewStatus=view')}">
                        <c:set var="isActive" value="false"/>
                    </c:if>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${(currentUrl eq stepUrl) or isActive == 'true'}">
                    <c:set var="adjacentStepsStatusCss" value="disabled"/>

                    <c:if test="${checkoutStep.progressBarId eq 'change-optional'}">
                        <c:set var="nextActiveStep" value="true"/>
                    </c:if>
                    <li class="checkout-progress__step js-step active ${currentStepIndicator}">
                        <a>
                            <spring:theme code="checkout.multi.${checkoutStep.progressBarId}"/>
                        </a>
                    </li>
                </c:when>
                <c:otherwise>
                    <li class="${currentStepIndicator} checkout-progress__step js-step ${adjacentStepsStatusCss}">
                        <c:choose>
                            <c:when test="${currentStepIndicator eq 'valid' and checkoutStep.progressBarId ne 'change-optional' or  nextActiveStep eq 'true'}">
                                <c:set var="nextActiveStep" value="false"/>
                                <a <c:if test="${isEnabled == true}">href="${linkUrl}"</c:if>>
                                    <spring:theme code="checkout.multi.${checkoutStep.progressBarId}"/>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <spring:theme code="checkout.multi.${checkoutStep.progressBarId}"/>
                            </c:otherwise>
                        </c:choose>

                    </li>
                </c:otherwise>
            </c:choose>
            <c:if test="${not empty checkoutStep.checkoutFlow}">
                <c:set var="flowStartUrl" scope="request">${stepUrl}</c:set>
            </c:if>
        </c:forEach>
    </ul>
</div>

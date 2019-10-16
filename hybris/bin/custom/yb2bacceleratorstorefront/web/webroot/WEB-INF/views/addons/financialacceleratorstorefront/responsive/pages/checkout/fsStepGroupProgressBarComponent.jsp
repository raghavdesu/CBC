<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<spring:htmlEscape defaultHtmlEscape="true"/>

<c:url value="${requestScope['javax.servlet.forward.servlet_path']}" var="currentUrl"/>

<div>
    <h2 class="checkout-progress__heading"><spring:theme code="claim.checkout.title" text="Make a claim online"/></h2>
</div>

<div class="col-md-12">
    <ul data-role="navbar" id="checkoutProgress" class="checkout-progress__body js-fsStep">
        <c:forEach items="${requestData.configurationSteps}" var="step">
            <c:set var="stepClass" value=""/>
            <c:set var="activeStep" value=""/>
            <spring:url var="currentStepUrl" value="/fsStepGroup/${requestData.requestId}/step/${step.sequenceNumber}" htmlEscape="false"/>
            <c:if test="${fn:endsWith(currentUrl, currentStepUrl)}">
                <c:set var="activeStep" value="active"/>
            </c:if>
            <c:choose>
                <c:when test="${step.status eq 'UNSET'}">
                    <c:set var="stepClass" value="disabled"/>
                </c:when>
                <c:when test="${step.status eq 'COMPLETED'}">
                    <c:set var="stepClass" value="completed"/>
                </c:when>
            </c:choose>
            <li class="${activeStep} checkout-progress__step js-step ${stepClass}">
                <c:choose>
                    <c:when test="${stepClass eq 'disabled' && empty activeStep}">
                        ${fn:escapeXml(step.name)}
                    </c:when>
                    <c:otherwise>
                        <a href="${currentStepUrl}">${fn:escapeXml(step.name)}</a>
                    </c:otherwise>
                </c:choose>
            </li>
        </c:forEach>
    </ul>
</div>
<div class="clearfix"></div>

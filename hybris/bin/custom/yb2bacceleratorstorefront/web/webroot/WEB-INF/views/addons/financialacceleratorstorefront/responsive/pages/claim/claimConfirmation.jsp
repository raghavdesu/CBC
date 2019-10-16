<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/responsive/common" %>
<%@ taglib prefix="user" tagdir="/WEB-INF/tags/responsive/user" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<spring:url value="/my-account/my-insurance-claims" var="myAccountClaimsUrl" htmlEscape="true"/>
<spring:url value="/my-account/inbox" var="inboxUrl" htmlEscape="true"/>

<div class="notice-text">
    <h3 class="notice-text__heading notice-text__heading--blue">
        <spring:theme code="claims.submission.claimID"/>${fn:escapeXml(claim.requestId)}
    </h3>

    <p class="notice-text__content">
        <spring:theme code="claims.submission.thankYouNotice" arguments="${inboxUrl}" htmlEscape="false"/>
    </p>

    <p class="notice-text__content text-center">
        <spring:theme code="claims.submission.status" arguments="${myAccountClaimsUrl}" htmlEscape="false"/>
    </p>
</div>


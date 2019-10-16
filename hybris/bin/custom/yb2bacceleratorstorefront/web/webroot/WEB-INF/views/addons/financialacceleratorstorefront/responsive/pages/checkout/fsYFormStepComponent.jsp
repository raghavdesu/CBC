<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="multi-checkout" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout/multi" %>
<spring:htmlEscape defaultHtmlEscape="true"/>

<div class="col-md-12">
    <div id="checkoutContentPanel" class="xform-container">
        <div class="required"><spring:theme code="form.required" text="Fields marked * are required"/></div>
        <div class="xform-container__description"></div>
        <div class="xform-container__form">
            <c:if test="${not empty stepData}">
                <h3 class="section-header__heading">${fn:escapeXml(stepData.name)}</h3>
                <c:forEach var="contentItem" items="${stepData.stepContent.contentData}">
                    ${contentItem.value}
                </c:forEach>
            </c:if>
        </div>
    </div>
</div>

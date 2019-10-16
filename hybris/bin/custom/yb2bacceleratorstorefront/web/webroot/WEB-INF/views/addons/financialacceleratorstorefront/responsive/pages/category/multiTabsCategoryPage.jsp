<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<template:page pageTitle="${pageTitle}">
    <div class="boxed-content-wrapper">
        <cms:pageSlot position="Section1" var="feature">
            <cms:component component="${feature}" element="div" class="col-xs-12"/>
        </cms:pageSlot>

        <c:if test="${param.viewStatus eq'view' or isViewOnly}">
            <cms:pageSlot position="Section2" var="feature">
                <cms:component component="${feature}" element="div" class="col-xs-12"/>
            </cms:pageSlot>
        </c:if>
    </div>
</template:page>

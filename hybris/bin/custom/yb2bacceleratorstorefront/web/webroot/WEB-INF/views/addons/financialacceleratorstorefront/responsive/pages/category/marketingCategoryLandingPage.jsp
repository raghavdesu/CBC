<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<template:page pageTitle="${pageTitle}">

    <cms:pageSlot position="Section1" var="feature">
        <cms:component component="${feature}" element="div" class="span-24 section1 cms_disp-img_slot"/>
    </cms:pageSlot>

    <cms:pageSlot position="Section2" var="feature">
        <cms:component component="${feature}" element="div" class="span-24 section2 cms_disp-img_slot"/>
    </cms:pageSlot>

    <cms:pageSlot position="Section3" var="feature">
        <cms:component component="${feature}" element="div" class="span-24 section3 cms_disp-img_slot"/>
    </cms:pageSlot>

    <div id="productTabs">
        <cms:pageSlot position="Tabs" var="tabs">
            <cms:component component="${tabs}"/>
        </cms:pageSlot>
    </div>
</template:page>
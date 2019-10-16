<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/template" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>


<template:page pageTitle="${pageTitle}">
    <div class="main-width-wrapper">
        <cms:pageSlot position="TopContent" var="comp" element="div" class="requestPageTop">
            <cms:component component="${comp}" element="div" class="yComponentWrapper requestPageTop-component"/>
        </cms:pageSlot>

        <cms:pageSlot position="MiddleContent" var="comp" element="div" class="requestPageMiddle">
            <cms:component component="${comp}" element="div" class="yComponentWrapper requestPageMiddle-component"/>
        </cms:pageSlot>

        <cms:pageSlot position="BottomContent" var="comp" element="div" class="requestPageBottom">
            <cms:component component="${comp}" element="div" class="yComponentWrapper requestPageBottom-component"/>
        </cms:pageSlot>
    </div>
</template:page>

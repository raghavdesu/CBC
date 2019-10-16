<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/template" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>

<template:page pageTitle="${pageTitle}">
	<div class="full-width-content-wrapper">
	    <cms:pageSlot position="Section1" var="feature" >
	        <cms:component component="${feature}" element="div"/>
	    </cms:pageSlot>
    </div>
    <div class="main-width-wrapper">
        <cms:pageSlot position="Section2A" var="feature">
            <cms:component component="${feature}" element="div"/>
        </cms:pageSlot>


        <cms:pageSlot position="Section2B" var="feature">
            <cms:component component="${feature}" element="div"/>
        </cms:pageSlot>

        <cms:pageSlot position="Section2C" var="feature">
            <cms:component component="${feature}" element="div"/>
        </cms:pageSlot>


        <cms:pageSlot position="Section3" var="feature">
            <cms:component component="${feature}" element="div"/>
        </cms:pageSlot>

        <cms:pageSlot position="Section4" var="feature">
            <cms:component component="${feature}" element="div"/>
        </cms:pageSlot>

        <cms:pageSlot position="Section5" var="feature">
            <cms:component component="${feature}" element="div"/>
        </cms:pageSlot>
    </div>
</template:page>

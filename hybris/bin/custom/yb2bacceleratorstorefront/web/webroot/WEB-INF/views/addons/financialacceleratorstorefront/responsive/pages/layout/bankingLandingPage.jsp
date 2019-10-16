<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/template" %>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/responsive/common" %>

<template:page pageTitle="${pageTitle}">
    <div class="full-width-content-wrapper">
        <cms:pageSlot position="Section1" var="feature">
            <cms:component component="${feature}" element="div" class="banking-banner"/>
        </cms:pageSlot>
        <div class="banking-products">
            <div class="row flex flex--wrap-center">
                <cms:pageSlot position="Section2A" var="feature">
                    <cms:component component="${feature}" element="div" class="col-xs-12 col-sm-6 col-md-4 banking-product"/>
                </cms:pageSlot>
            </div>
        </div>

        <cms:pageSlot position="Section2B" var="feature">
            <cms:component component="${feature}" element="div"/>
        </cms:pageSlot>

        <div class="review review__wrapper">
            <cms:pageSlot position="Section2C" var="feature">
                <cms:component component="${feature}" element="div" class="col-xs-12 col-sm-6"/>
            </cms:pageSlot>
        </div>

        <cms:pageSlot position="Section3" var="feature">
            <cms:component component="${feature}" element="div" class="col-xs-12"/>
        </cms:pageSlot>

        <cms:pageSlot position="Section4" var="feature">
            <cms:component component="${feature}" element="div" class="col-xs-12"/>
        </cms:pageSlot>

        <cms:pageSlot position="Section5" var="feature">
            <cms:component component="${feature}" element="div" class="col-xs-12"/>
        </cms:pageSlot>
    </div>
</template:page>
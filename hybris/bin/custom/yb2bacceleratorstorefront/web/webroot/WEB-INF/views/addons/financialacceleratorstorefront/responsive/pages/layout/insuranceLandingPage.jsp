<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/template" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>

<template:page pageTitle="${pageTitle}">

	<div class="full-width-content-wrapper">
	    <cms:pageSlot position="Section1" var="feature">
	        <cms:component component="${feature}" element="div" class="landing-first-section"/>
	    </cms:pageSlot>

		<div class="main-width-wrapper row flex flex--wrap-center">
			<cms:pageSlot position="Section2A" var="feature">
				<cms:component component="${feature}" element="div" class="col-xs-6 col-sm-4 col-md-3 service-links"/>
			</cms:pageSlot>
		</div>

	    <cms:pageSlot position="Section2B" var="feature">
	        <cms:component component="${feature}" element="div"/>
	    </cms:pageSlot>

		<div class="main-width-wrapper review review__wrapper">
			<div class="row">
				<cms:pageSlot position="Section2C" var="feature">
					<cms:component component="${feature}" element="div" class="col-xs-12 col-sm-6"/>
				</cms:pageSlot>
			</div>
		</div>

		<cms:pageSlot position="Section3" var="feature">
			<cms:component component="${feature}" element="div" />
		</cms:pageSlot>
	
	    <cms:pageSlot position="Section4" var="feature">
	        <cms:component component="${feature}" element="div" class="col-xs-12"/>
	    </cms:pageSlot>
	
	    <cms:pageSlot position="Section5" var="feature">
	        <cms:component component="${feature}" element="div" class="col-xs-12"/>
	    </cms:pageSlot>
	</div>
</template:page>

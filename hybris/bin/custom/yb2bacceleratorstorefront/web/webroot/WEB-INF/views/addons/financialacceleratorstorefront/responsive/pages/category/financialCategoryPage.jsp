
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/product" %>
<%@ taglib prefix="financialCart" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/cart" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<template:page pageTitle="${pageTitle}">
	<div class="full-width-content-wrapper">
		<div class="row">
			<cms:pageSlot position="Section1" var="feature">
				<cms:component component="${feature}" element="div" class="category-hero-banner"/>
			</cms:pageSlot>
		</div>
		<div class="row">
			<div class="col-md-12">
				<cms:pageSlot position="Section2A" var="feature">
					<cms:component component="${feature}" element="div" class="category-title-promotion-banner"/>
				</cms:pageSlot>
			</div>
		</div>
		<div class="row category-promotion">
			<div class="col-md-8">
				<div class="category-promotion__column">
					<cms:pageSlot position="Section2B" var="feature">
						<cms:component component="${feature}" element="div" class="category-primary-promotion-banner"/>
					</cms:pageSlot>
				</div>
			</div>
			<div class="col-md-4">
				<div class="category-promotion__column">
					<cms:pageSlot position="Section3" var="feature">
						<cms:component component="${feature}" element="div" class="category-secondary-promotion-banner"/>
					</cms:pageSlot>
				</div>
			</div>
		</div>
		<div class="row product-feature">
			<cms:pageSlot position="Section4" var="feature">
				<cms:component component="${feature}" element="div" class="col-md-4"/>
			</cms:pageSlot>
		</div>
	</div>
</template:page>
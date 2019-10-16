<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<spring:htmlEscape defaultHtmlEscape="true"/>

<template:page pageTitle="${pageTitle}">
    <div class="boxed-content-wrapper">
        <div class="find-agent find-agent__main-page js-find-agent">
            <h2 class="heading-headline"><spring:theme code="text.agent.title.findAnAgent" text="Find an Agent"/></h2>
			<div class="row">
				<div class="col-xs-12 col-md-6 col-lg-3 pull-right">
					<div class="page-switcher">
						<span class="col-xs-6 page-switcher__button page-switcher__button--list-view page-switcher__button--active" ><spring:theme code="agentFinder.listView"/></span>
						<a class="col-xs-6 page-switcher__button page-switcher__button--map-view" href="agent-locator" ><spring:theme code="agentFinder.mapView"/></a>
					</div>
				</div>
			</div>
            <cms:pageSlot position="Section1" var="component">
                <cms:component component="${component}" element="div" class="category" />
            </cms:pageSlot>
        </div>
    </div>
</template:page>
<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ attribute name="errorNoResults" required="true" type="java.lang.String"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/common"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:url value="/agent-locator" var="agentLocatorFormAction" />

<div class="row boxed-content-wrapper">
	<div class="col-lg-12">
		<h2 class="heading-headline"><spring:theme code="agentFinder.find.an.agent" /></h2>
		<div class="store__finder--search">
			<div class="row">
				<div class="col-xs-12 col-md-6 col-lg-3 pull-right">
					<div class="page-switcher">
						<a class="col-xs-6 page-switcher__button page-switcher__button--list-view" href="find-agent"><spring:theme code="agentFinder.listView"/></a>
						<span class="col-xs-6 page-switcher__button page-switcher__button--map-view page-switcher__button--active"><spring:theme code="agentFinder.mapView"/></span>
					</div>
				</div>
				<div class="col-xs-12 col-md-6">
					<form:form action="${agentLocatorFormAction}" method="get" modelAttribute="storeFinderForm">
						<ycommerce:testId code="storeFinder_search_box">
							<div class="input-group">
								<formElement:formInputBox idKey="storelocator-query" labelKey="storelocator.query" path="q" labelCSS="sr-only" inputCSS="form-control js-store-finder-search-input" mandatory="true"  placeholder="pickup.search.message" />
								<span class="input-group-btn">
									<button class="btn btn-primary" type="submit">
										<span class="glyphicon glyphicon-search"></span>
									</button>
								</span>
							</div>
						</ycommerce:testId>
					</form:form>
				</div>
			</div>
		</div>
	</div>
</div>

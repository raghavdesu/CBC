<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="searchPageData" required="true" type="de.hybris.platform.core.servicelayer.data.SearchPageData" %>
<%@ attribute name="agentQuery" required="false" type="java.lang.String" %>
<%@ attribute name="geoPoint" required="false" type="de.hybris.platform.commerceservices.store.data.GeoPoint" %>
<%@ attribute name="numberPagesShown" required="true" type="java.lang.Integer" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="store" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/store" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>
<%@ taglib prefix="action" tagdir="/WEB-INF/tags/responsive/action" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:url value="/agent-locator" var="agentLocatorFormAction" />

<div class="store__finder js-store-finder" data-url="${agentLocatorFormAction}">
    <div class="row boxed-content-wrapper">
        <ycommerce:testId code="storeFinder">
            <div class="col-lg-12">
                <div class="store__finder--pagination">
	                <div class="row">
	                    <div class="store-finder-pager col-xs-12 col-sm-6">
		                    <span class="js-store-finder-pager-item-from"></span>&nbsp;-
		                    <span class="js-store-finder-pager-item-to"></span>
		                    <spring:theme code="storeFinder.pagination.from" text="from"></spring:theme>
		                    &nbsp;<span class="js-store-finder-pager-item-all"></span>
		                    <spring:theme code="agentFinder.pagination.agents" text="agents found"></spring:theme>
	                    </div>
	                    <div class="col-xs-12 col-sm-6">
	                    	<div class="btn-pagination-prev col-xs-12 col-sm-6">
		                        <button class="btn primary-button primary-button__default js-store-finder-pager-prev" type="button">
		                            <spring:theme code="storeFinder.pagination.previous" text="Previous"></spring:theme>
		                        </button>
	                        </div>
	                        <div class="btn-pagination-next col-xs-12 col-sm-6">
		                        <button class="btn secondary-button secondary-button__default js-store-finder-pager-next" type="button">
		                            <spring:theme code="storeFinder.pagination.next" text="Next"></spring:theme>
		                        </button>
		                    </div>
	                    </div>
	                </div>
                </div>

                <div class="store__finder--panel">
                    <div class="store__finder--details js-store-finder-details">
                        <div class="store__finder--buttons-holder">
		                    <div class="store-finder-pager">
			                    <span class="js-store-finder-pager-item-from"></span>&nbsp;-
			                    <span class="js-store-finder-pager-item-to"></span>
			                    <spring:theme code="storeFinder.pagination.from" text="from"></spring:theme>
			                    &nbsp;<span class="js-store-finder-pager-item-all"></span>
			                    <spring:theme code="agentFinder.pagination.agents" text="agents found"></spring:theme>
		                    </div>
                            <button class="btn primary-button primary-button__default store__finder--details-back js-store-finder-details-back">
                                <span class="glyphicon glyphicon-arrow-left"></span>
                                <spring:theme code="pickup.in.store.back.to.results" text="Back"></spring:theme>
                            </button>
                        </div>
                        <div class="store__finder--details-holder">
	                        <div class="store__finder--details-info">
								<div class="store__finder--details-image js-store-image"></div>
	                            <div class="info__name js-store-name"></div>
	                            <div class="info__address">
	                                <div class="js-store-posName info__address--position-name"></div>
	                                <div class="js-store-line1 info__address--street"></div>
	                                <div class="js-store-line2 info__address--number"></div>
	                                <div class="js-store-town"></div>
	                            </div>
	                        </div>
	                        <div class="store__finder--details-openings">
	                            <div class="openings__title"><spring:theme code="agentDetails.table.categories" /></div>
	                            <ul class="js-store-agents"></ul>
							    <div class="agent-info">
							        <a id="contactBtn" class="secondary-button secondary-button__default secondary-button__agent" href=""><spring:theme code="text.agent.contactExpert.request" text="Contact"/></a>
							    </div>
	                        </div>
                        </div>
                        <div id="store-finder-map" class="store__finder--map js-store-finder-map"></div>
                    </div>
                    <div class="store__finder--navigation col-xs-12">
                        <ul class="store__finder--navigation-list js-store-finder-navigation-list">
                            <li class="loading"><span class="glyphicon glyphicon-repeat"></span></li>
                        </ul>
                    </div>
                </div>

                <div class="store__finder--pagination hidden-xs">
	                <div class="row">
	                    <div class="store-finder-pager col-xs-12 col-sm-6">
		                    <span class="js-store-finder-pager-item-from"></span>&nbsp;-
		                    <span class="js-store-finder-pager-item-to"></span>
		                    <spring:theme code="storeFinder.pagination.from" text="from"></spring:theme>
		                    &nbsp;<span class="js-store-finder-pager-item-all"></span>
		                    <spring:theme code="agentFinder.pagination.agents" text="agents found"></spring:theme>
	                    </div>
	                    <div class="col-xs-12 col-sm-6">
	                    	<div class="btn-pagination-prev col-xs-12 col-sm-6">
		                        <button class="btn primary-button primary-button__default js-store-finder-pager-prev" type="button">
		                            <spring:theme code="storeFinder.pagination.previous" text="Previous"></spring:theme>
		                        </button>
	                        </div>
	                        <div class="btn-pagination-next col-xs-12 col-sm-6">
		                        <button class="btn secondary-button secondary-button__default js-store-finder-pager-next" type="button">
		                            <spring:theme code="storeFinder.pagination.next" text="Next"></spring:theme>
		                        </button>
		                    </div>
	                    </div>
	                </div>
                </div>
            </div>

        </ycommerce:testId>
    </div>
</div>

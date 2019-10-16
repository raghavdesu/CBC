<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="multi-checkout" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout/multi" %>
<%@ taglib prefix="formatter" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/format" %>

<spring:htmlEscape defaultHtmlEscape="true"/>

<div class="col-md-12">
    <h2 class="section-header__heading">
        <spring:theme code="text.customer360.summary.heading" text="Summary"/>
    </h2>
    <div id="checkoutContentPanel" class="accordion">
    	<div class="accordion-item clearfix">
	        <c:if test="${not empty stepData}">
	            <c:forEach var="step" items="${requestData.configurationSteps}" varStatus="counter">
	                <c:if test="${step.sequenceNumber < stepData.sequenceNumber and not step.summaryStep}">
						<div class="col-md-12 col-sm-12 col-xs-12 accordion-item__wrapper">
						    <h2 class="accordion-item__heading accordion-item--valid js-toggle ${counter.count == 1 ? 'active' : ''}">
						        <span class="accordion-item__open" data-open="quoteReviewCoverageLevel"></span>
						        ${fn:escapeXml(step.stepContent.title)}
						    </h2>
						    <div class="accordion-item__body ${counter.count == 1 ? 'opened' : ''}">
						        <div class="col-md-9 col-sm-9 col-xs-12">
						            <ul class="accordion-item__list">
						                <c:forEach var="contentItem" items="${step.stepContent.contentData}">
						                    <li class="accordion-item__list-item">
						                        <div class="row">
						                            <div class="col-xs-6">
						                                <spring:theme code="yform.text.fsstep.label.${contentItem.key}" text="${contentItem.key}"/>
						                            </div>
						                            <div class="col-xs-6 ellipsis">
						                                <formatter:propertyValueFormatter targetFormatKey="yform.text.fsstep.format.${contentItem.key}" valueKeyPrefix="yform.text.fsstep.value.${contentItem.key}" rawValue="${contentItem.value}"/>
						                            </div>
						                        </div>
						                    </li>
						                </c:forEach>
						            </ul>
						        </div>
						        <spring:url var="editUrl" value="/fsStepGroup/${requestData.requestId}/step/${step.sequenceNumber}" htmlEscape="false"/>
						        <div class="col-md-3 col-sm-3 col-xs-12 accordion-item__button">
						            <a class="secondary-button secondary-button__default secondary-button__edit" href="${editUrl}"><spring:theme code="text.cmsformsubmitcomponent.edit" text="Edit"/></a>
						        </div>
						    </div>
						</div>
	                </c:if>
	            </c:forEach>
	        </c:if>
        </div>
    </div>
</div>
<div class="clearfix"></div>

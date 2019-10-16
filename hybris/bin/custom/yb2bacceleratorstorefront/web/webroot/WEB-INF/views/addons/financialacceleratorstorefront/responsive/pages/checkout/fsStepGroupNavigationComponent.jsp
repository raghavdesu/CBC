<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<spring:htmlEscape defaultHtmlEscape="true"/>

<c:url value="${nextStep}" var="nextStepUrl"/>
<c:url value="${previousStep}" var="previousStepUrl"/>
<div class="margin-t-30">
	<c:if test="${not empty previousStepUrl}">
	    <div class="col-xs-12 col-sm-5">
	        <a id="backBtn" class="secondary-button secondary-button__default secondary-button__checkout"
	           href="${fn:escapeXml(previousStepUrl)}">
	            <spring:theme code="checkout.multi.quoteForm.back" text="Back"/>
	        </a>
	    </div>
	</c:if>
	<c:choose>
		<c:when test="${empty previousStepUrl}">
			<c:set var="continueButton" value="primary-button__single-checkout"/>
		</c:when>
		<c:otherwise>
			<c:set var="continueButton" value="primary-button__checkout"/>
		</c:otherwise>
	</c:choose>
	<div class="col-xs-12 col-sm-5 pull-right">
		<c:choose>
		    <c:when test="${not empty nextStepUrl}">
		        <c:if test="${stepData.getYFormConfigurator() ne null}">
		            <c:set var="yFormSubmissionId" value="continueBtn"/>
		        </c:if>
		        <a id="${yFormSubmissionId}" class="primary-button primary-button__default ${continueButton}"
		           href="${fn:escapeXml(nextStepUrl)}">
		            <spring:theme code="checkout.multi.quoteForm.continue" text="Continue"/>
		        </a>
		    </c:when>
		    <c:otherwise>
			    <c:url value="/fsStepGroup/submit" var="submitUrl"/>
			    <form action="${submitUrl}" method="POST">
			        <input name="requestId" type="hidden" value="${requestData.requestId}">
			        <input type="hidden" name="CSRFToken" value="${CSRFToken.token}">
			        <button type="submit" class="primary-button primary-button__default ${continueButton}">
			            <spring:theme code="checkout.multi.hostedOrderPostPage.button.submit" text="Submit"/>
			        </button>
			    </form>
		    </c:otherwise>
		</c:choose>
	</div>
	<div class="clearfix"></div>
</div>

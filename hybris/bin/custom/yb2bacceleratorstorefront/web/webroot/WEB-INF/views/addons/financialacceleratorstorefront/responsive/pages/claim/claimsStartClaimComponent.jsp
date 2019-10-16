<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="formatter" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/format" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement" %>
<spring:htmlEscape defaultHtmlEscape="true"/>

<spring:url value="/claims/create" var="createClaimLink" htmlEscape="false"/>

	<c:if  test="${not empty policies}">
	    <form:form modelAttribute="createClaimForm" action="${createClaimLink}">
	        <div class="row">
	            <div class="col-xs-12 col-sm-6 col-md-4 pull-right">
	                <label class="checkbox-label">
	    	            <input id="confirmation" name="confirmation" type="checkbox" value="true">
	                    <span class="checkbox-text"><spring:theme code="claim.item.confirmation"/></span>
	                </label>
	                    <input id="policyId" name="policyId" type="hidden">
						<input id="contractId" name="contractId" type="hidden">
					<button type="submit" class="primary-button primary-button__default primary-button__checkout js-submit-policy" disabled>
	                    <spring:theme code="checkout.multi.quoteForm.continue"/>
	                </button>
	            </div>
	        </div>
	    </form:form>
	</c:if>


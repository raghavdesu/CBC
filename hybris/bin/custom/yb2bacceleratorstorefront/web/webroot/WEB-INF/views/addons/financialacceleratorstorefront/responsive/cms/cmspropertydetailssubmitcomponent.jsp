<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<div class="listed-infos">
	<c:choose>
		<c:when test="${param.viewStatus=='view'}">
			<ul class="listed-infos__details">
				<c:forEach items="${propertyFormSessionMap}" var="property">
						<li>
							<c:set var="keyLabel" value="text.${fn:replace(property.key, '_', '.')}"/>
							<label class="listed-infos__details--right-margin"><spring:theme code="${keyLabel}"/>:</label>
							${property.value}
						</li>
					</c:forEach>
			</ul>
           	<ycommerce:testId code="multicheckout_cancel_button">
              		<a id="backBtn" class="secondary-button secondary-button__default secondary-button__infos" href="?viewStatus=edit">
               			<spring:theme code="text.cmsformsubmitcomponent.edit" text="Edit"/>
              		</a>
			</ycommerce:testId>
		</c:when>
		<c:otherwise>
	        <ycommerce:testId code="multicheckout_saveForm_button">
	            <a id="continueBtn" class="primary-button primary-button__default primary-button__infos pull-right" href="?viewStatus=view">
	               		<spring:theme code="text.cmsformsubmitcomponent.find.prices" text="Find Prices"/>
	            </a>
	        </ycommerce:testId>
        </c:otherwise>
	</c:choose>
</div>

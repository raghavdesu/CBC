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
      <c:when test="${param.viewStatus eq 'view'}">
			<ul class="listed-infos__details">
				<li><label class="listed-infos__details--right-margin"><spring:theme code="text.cmstripdetailssubmitcomponent.destination"/>:</label> ${fn:escapeXml(sessionScope.trip.tripDestination)}</li>
				<li><label class="listed-infos__details--right-margin"><spring:theme code="text.cmstripdetailssubmitcomponent.depart"/>:</label> ${fn:escapeXml(sessionScope.trip.tripStartDate)}</li>
				<li><label class="listed-infos__details--right-margin"><spring:theme code="text.cmstripdetailssubmitcomponent.return"/>:</label> ${fn:escapeXml(sessionScope.trip.tripEndDate)}</li>
			</ul>
			<ul class="listed-infos__details">
				<li><label class="listed-infos__details--right-margin"><spring:theme code="text.cmstripdetailssubmitcomponent.number.of.travellers"/>:</label> ${fn:escapeXml(sessionScope.trip.Travellers)}</li>
				<li>
					<label class="listed-infos__details--right-margin"><spring:theme code="text.cmstripdetailssubmitcomponent.ages.of.travellers"/>:</label>
					<c:forEach var="travellerAge" items="${sessionScope.trip.tripDetailsTravellerAges}" varStatus="status">
						<c:if test="${status.index ne 0 }">,&nbsp;</c:if>${fn:escapeXml(travellerAge)}
					</c:forEach>
				</li>
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

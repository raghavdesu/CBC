<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<div class="listed-infos">
	<c:choose>
		<c:when test="${param.viewStatus=='view'}">
			<ul class="listed-infos__details">
				<li>
					<c:if test="${not empty sessionScope.life.lifeWhoCovered}">
						<label class="listed-infos__details--right-margin"><spring:theme code="text.insurance.life.covered" text="Who is being covered:" /></label>${fn:escapeXml(sessionScope.life.lifeWhoCovered)}
					</c:if>
				</li>

				<li>
					<c:if test="${not empty sessionScope.life.lifeCoverageRequire}">
						<label class="listed-infos__details--right-margin"><spring:theme code="text.insurance.life.covered.required" text="How much life insurance coverage do you require:" /></label>${fn:escapeXml(sessionScope.life.lifeCoverageRequire)}
					</c:if>
				</li>
			</ul>

			<ul class="listed-infos__details">
				<li>
					<c:if test="${not empty sessionScope.life.lifeCoverageLast}">
						<label class="listed-infos__details--right-margin"><spring:theme code="text.insurance.life.coverage.last" text="How many years do you want the coverage to last:" /></label>${fn:escapeXml(sessionScope.life.lifeCoverageLast)}
					</c:if>
				</li>

				<li>
					<c:if test="${not empty sessionScope.life.lifeCoverageStartDate}">
						<label class="listed-infos__details--right-margin"><spring:theme code="text.insurance.life.coverage.start.date" text="Coverage start date:" /></label>${fn:escapeXml(sessionScope.life.lifeCoverageStartDate)}
					</c:if>
				</li>
			</ul>

			<ul class="listed-infos__details">
				<li>
					<c:if test="${not empty sessionScope.life.lifeMainDob}">
						<label class="listed-infos__details--right-margin"><spring:theme code="text.insurance.life.date.of.birth" text="Your date of birth:" /></label>${fn:escapeXml(sessionScope.life.lifeMainDob)}
					</c:if>
				</li>

				<li>
					<c:if test="${not empty sessionScope.life.lifeMainSmoke}">
						<label class="listed-infos__details--right-margin"><spring:theme code="text.insurance.life.main.smoke" text="Do you smoke:" /></label>${fn:escapeXml(sessionScope.life.lifeMainSmoke)}
					</c:if>
				</li>
			</ul>
			<c:if test="${sessionScope.life.lifeWhoCovered eq 'yourself and second person'}">
				<ul class="listed-infos__details">
					<li>
						<c:if test="${not empty sessionScope.life.lifeSecondDob}">
							<label class="listed-infos__details--right-margin"><spring:theme code="text.insurance.life.second.date.of.birth" text="Second persons date of birth:" /></label>${fn:escapeXml(sessionScope.life.lifeSecondDob)}
						</c:if>
					</li>

					<li>
						<c:if test="${not empty sessionScope.life.lifeSecondSmoke}">
							<label class="listed-infos__details--right-margin"><spring:theme code="text.insurance.life.second.smoke" text="Dose the second person smoke:" /></label>${fn:escapeXml(sessionScope.life.lifeSecondSmoke)}
						</c:if>
					</li>
				</ul>
				<ul class="listed-infos__details">
					<li>
						<c:if test="${not empty sessionScope.life.lifeRelationship}">
							<label class="listed-infos__details--right-margin"><spring:theme code="text.insurance.life.relationship" text="Relationship to the second person:" /></label>${fn:escapeXml(sessionScope.life.lifeRelationship)}
						</c:if>
					</li>
				</ul>
			</c:if>

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

<%@ attribute name="insuranceQuoteReviews" required="true" type="java.util.List<de.hybris.platform.commercefacades.insurance.data.InsuranceQuoteReviewData>" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="isValidStep" required="false" type="java.lang.Boolean" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<c:if test="${not empty insuranceQuoteReviews}">
    <c:forEach items="${insuranceQuoteReviews}" var="quoteReview">
		<c:choose>
			<c:when test="${isValidStep == 'true'}"> <c:set var="isValidClass" value="accordion-item__heading accordion-item--valid js-toggle"/></c:when>
			<c:otherwise><c:set var="isValidClass" value="accordion-item__heading accordion-item--invalid js-toggle"/></c:otherwise>
		</c:choose>
		<h2 class="${isValidClass}">
				<spring:theme code="checkout.multi.quoteReview.added" text="Added by you" />
			<c:if test="${isValidStep == 'true'}">
				<span class="accordion-item__open" data-open="optionalExtrasPanel"></span>
			</c:if>
		</h2>

		<c:if test="${isValidStep == 'true'}">
			<div class="accordion-item__body" id="optionalExtrasPanel">
				<div class="col-md-9 col-sm-9 col-xs-12">
					<c:if test="${empty quoteReview.optionalProducts}">
						<p class="accordion-item__text">
							<spring:theme code="checkout.multi.quoteReview.added.empty" text="(None)" />
						</p>
					</c:if>
					<ul class="accordion-item__list accordion-item__list--style-type">
						<c:forEach var="extraItem" items="${quoteReview.optionalProducts}">
							<li class="accordion-item__list-item">${fn:escapeXml(extraItem.coverageProduct.name)}</li>
						</c:forEach>
					</ul>
				</div>
				<c:if test="${cartData.insuranceQuote.state eq 'UNBIND'}">
					<spring:url var="editOptionUrl" value="/cart" htmlEscape="false"/>
					<div class="col-md-3 col-sm-3 col-xs-12 accordion-item__button">
						<a class="secondary-button secondary-button__default secondary-button__edit" href="${editOptionUrl}"><spring:theme code="text.cmsformsubmitcomponent.edit" text="Edit"/></a>
					</div>
				</c:if>
			</div>
		</c:if>
    </c:forEach>
</c:if>

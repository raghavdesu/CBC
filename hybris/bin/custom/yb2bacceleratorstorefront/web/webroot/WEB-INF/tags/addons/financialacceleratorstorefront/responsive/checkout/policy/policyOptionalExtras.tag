<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="policyData" required="true" type="de.hybris.platform.commercefacades.insurance.data.InsurancePolicyData" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<spring:htmlEscape defaultHtmlEscape="true" />

<h2 class="accordion-item__heading accordion-item--valid js-toggle">
	<spring:theme code="checkout.orderConfirmation.optional.extras" text="Added by You"/>
	<span class="accordion-item__open" data-open="optionalExtras"></span>
</h2>

<div id="optionalExtras" class="accordion-item__body">
	<div class="col-md-9 col-sm-9 col-xs-12">
		<c:if test="${empty policyData.optionalProducts}">
			<p class="accordion-item__text">
				<spring:theme code="checkout.multi.quoteReview.extras.empty" text="No optional extras were chosen" />
			</p>
		</c:if>
		<ul class="accordion-item__list accordion-item__list--style-type">
			<c:set var="extraBenefints" value="${policyData.optionalProducts}"/>
			<c:forEach items="${extraBenefints}" var="benefit">
				<li class="accordion-item__list-item">${fn:escapeXml(benefit.coverageProduct.name)}</li>
			</c:forEach>
		</ul>
	</div>
</div>

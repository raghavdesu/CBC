<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="policyData" required="true" type="de.hybris.platform.commercefacades.insurance.data.InsurancePolicyData" %>
<%@ attribute name="openSection" required="false" type="java.lang.Boolean" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true" />


<c:if test="${openSection}">
	<c:set var="activeClass" value="active" />
	<c:set var="openedClass" value="opened" />
</c:if>

<h2 class="accordion-item__heading accordion-item--valid js-toggle ${activeClass}">
	<spring:theme code="checkout.multi.quoteReview.included" text="Whats Included" />
	<span class="accordion-item__open" data-open="whatsIncludedPanel"></span>
</h2>

<div id="whatsIncludedPanel" class="accordion-item__body ${openedClass}">
	<div class="col-md-9 col-sm-9 col-xs-12">
		<h3 class="accordion-item__list-title">
			${fn:escapeXml(policyData.mainProduct.coverageProduct.name)}
		</h3>
		<c:set var="benefits" value="${policyData.mainProduct.benefits}"/>
		<ul class="accordion-item__list accordion-item__list--style-type">
			<c:forEach items="${benefits}" var="benefit">
				<li class="accordion-item__list-item">${fn:escapeXml(benefit.name)}</li>
			</c:forEach>
		</ul>
	</div>
</div>

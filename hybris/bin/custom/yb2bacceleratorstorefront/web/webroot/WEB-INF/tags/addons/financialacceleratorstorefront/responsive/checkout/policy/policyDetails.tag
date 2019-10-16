<%@ attribute name="policyData" required="true" type="de.hybris.platform.commercefacades.insurance.data.InsurancePolicyData" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="formatter" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/format" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<c:if test="${not empty policyData.policyHolderDetail}">
    <c:set var="policyHolderDetail" value="${policyData.policyHolderDetail}"/>
    <h2 class="accordion-item__heading accordion-item--valid js-toggle">
		<spring:theme code="checkout.orderConfirmation.details.your.details" text="Personal Details"/>
		<span class="accordion-item__open" data-open="policyDetails"></span>
	</h2>

	<div class="accordion-item__body" id="policyDetails">
	    <div class="col-md-9 col-sm-9 col-xs-12">
	        <h3 class="accordion-item__list-title"><spring:theme code="checkout.orderConfirmation.details.policy.holder" text="Policy Holder"/></h3>
	        <ul class="accordion-item__list">
	            <li class="accordion-item__list-item">${fn:escapeXml(policyHolderDetail.title)}&nbsp;${fn:escapeXml(policyHolderDetail.firstName)}&nbsp;${fn:escapeXml(policyHolderDetail.lastName)}</li>
                <c:if test="${not empty policyHolderDetail.phoneNumber}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.phoneNumber"/>: ${policyHolderDetail.phoneNumber}</li>
                </c:if>
                <c:if test="${not empty policyHolderDetail.emailAddress}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.emailAddress"/>: ${policyHolderDetail.emailAddress}</li>
                </c:if>
                <c:if test="${not empty policyHolderDetail.addressLine1}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.addressLine1"/>: ${fn:escapeXml(policyHolderDetail.addressLine1)}</li>
                </c:if>
                <c:if test="${not empty policyHolderDetail.addressLine2}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.addressLine2"/>: ${fn:escapeXml(policyHolderDetail.addressLine2)}</li>
                </c:if>
                <c:if test="${not empty policyHolderDetail.addressCity}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.addressCity"/>: ${fn:escapeXml(policyHolderDetail.addressCity)}</li>
                </c:if>
                <c:if test="${not empty policyHolderDetail.postcode}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.postcode"/>: ${policyHolderDetail.postcode}</li>
                </c:if>
                <c:if test="${not empty policyHolderDetail.addressCountry}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.addressCountry"/>: ${fn:escapeXml(policyHolderDetail.addressCountry)}</li>
                </c:if>
                <c:if test="${not empty policyHolderDetail.dateOfBirth}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.dateOfBirth"/> :
                        <formatter:propertyValueFormatter targetFormatKey="checkout.text.configuration.format.date" rawValue="${detailData.dateOfBirth}"/>
                    </li>
                </c:if>
                <c:if test="${not empty policyHolderDetail.partnerName}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.partnerName"/>: ${fn:escapeXml(policyHolderDetail.partnerName)}</li>
                </c:if>
                <c:if test="${not empty policyHolderDetail.partnerDateOfBirth}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.partnerDateOfBirth"/> :
                        <formatter:propertyValueFormatter targetFormatKey="checkout.text.configuration.format.date" rawValue="${policyHolderDetail.partnerDateOfBirth}"/>
                    </li>
                </c:if>
                <c:if test="${not empty policyHolderDetail.numberOfChildren}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.numberOfChildren"/>: ${fn:escapeXml(policyHolderDetail.numberOfChildren)}</li>
                </c:if>
	        </ul>
	        <c:if test="${not empty policyData.travellers}">
	            <h3 class="accordion-item__list-title"><spring:theme code="checkout.orderConfirmation.details.beneficiaries" text="Travellers"/></h3>
	            <c:forEach items="${policyData.travellers}" var="traveller" varStatus="status">
	                <ul class="accordion-item__list">
	                    <li class="accordion-item__list-item accordion-item__list-item--title"><spring:theme code="checkout.orderConfirmation.details.traveller" text="Traveller"/>&nbsp;${status.count}</li>
	                    <li class="accordion-item__list-item">${fn:escapeXml(traveller.firstName)}&nbsp;${fn:escapeXml(traveller.lastName)}</li>
	                    <li class="accordion-item__list-item"><spring:theme code="checkout.orderConfirmation.details.age" text="Age:"/>&nbsp;${fn:escapeXml(traveller.age)}</li>
	                </ul>
	            </c:forEach>
	        </c:if>
	    </div>
    </div>
</c:if>


<%@ attribute name="insuranceQuoteReviews" required="true" type="java.util.List<de.hybris.platform.commercefacades.insurance.data.InsuranceQuoteReviewData>" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="isValidStep" required="false" type="java.lang.Boolean" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="quote" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout/multi/quote" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<c:if test="${not empty insuranceQuoteReviews}">
    <c:forEach items="${insuranceQuoteReviews}" var="quoteReview">
            <c:set var="policyHolderDetail" value="${quoteReview.policyHolderDetail}"/>
            <c:choose>
                <c:when test="${isValidStep == 'true'}"> <c:set var="isValidClass" value="accordion-item__heading accordion-item--valid js-toggle"/></c:when>
                <c:otherwise><c:set var="isValidClass" value="accordion-item__heading accordion-item--invalid js-toggle"/></c:otherwise>
            </c:choose>
            <h2 class="${isValidClass}">
                <spring:theme code="checkout.multi.quoteReview.details.policy.holder.details" text="Personal Details"/>
                <span class="accordion-item__open" data-open="quoteReviewYourDetails"></span>
            </h2>

            <div class="accordion-item__body" id="quoteReviewYourDetails">
                <div class="col-md-9 col-sm-9 col-xs-12">
                    <h3 class="accordion-item__list-title"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.${fn:toLowerCase(cmsSite.channel)}" text="Policy Holder"/></h3>

                    <quote:quoteReviewPersonalDetails detailData="${policyHolderDetail}" />

                    <c:if test="${not empty quoteReview.additionalApplicant}">
                        <h3>
                            <spring:theme code="checkout.multi.quoteReview.details.policy.holder.additional" text="Additional applicant"/>
                        </h3>
                        <quote:quoteReviewPersonalDetails detailData="${quoteReview.additionalApplicant}" />
                    </c:if>

                    <c:if test="${not empty quoteReview.travellers}">
                        <c:forEach items="${quoteReview.travellers}" var="traveller" varStatus="status">
                            <ul class="accordion-item__list">
                                <li class="accordion-item__list-item accordion-item__list-item--title"><spring:theme code="checkout.multi.quoteReview.details.traveller" text="Traveller"/>&nbsp;${status.count}</li>
                                <li class="accordion-item__list-item">${fn:escapeXml(traveller.firstName)}&nbsp;${fn:escapeXml(traveller.lastName)}</li>
                                <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.age" text="Age:"/>&nbsp;${traveller.age}</li>
                            </ul>
                        </c:forEach>
                    </c:if>
                </div>
                <c:if test="${cartData.insuranceQuote.state eq 'UNBIND'}">
                    <spring:url var="updatePersonalDetailsUrl" value="/checkout/multi/form" htmlEscape="false"/>
                    <div class="col-md-3 col-sm-3 col-xs-12 accordion-item__button">
                        <a class="secondary-button secondary-button__default secondary-button__edit" href="${updatePersonalDetailsUrl}"><spring:theme code="text.cmsformsubmitcomponent.edit" text="Edit"/></a>
                    </div>
                </c:if>
            </div>
    </c:forEach>
</c:if>

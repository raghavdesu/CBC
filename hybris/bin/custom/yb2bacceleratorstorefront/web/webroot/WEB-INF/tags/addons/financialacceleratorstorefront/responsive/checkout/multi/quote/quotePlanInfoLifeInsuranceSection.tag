<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="quoteData" required="true"
              type="de.hybris.platform.commercefacades.quotation.InsuranceQuoteData" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<c:if test="${not empty quoteData.lifeDetail.lifeWhoCovered}">
    <li class="accordion-item__list-item">
        <div class="row">
            <div class="col-md-6 col-sm-6 col-xs-6">
                <spring:theme code="checkout.multi.quoteReview.life.who.covered" text="Who is being covered: "/>
            </div>
            <div class="col-md-6 col-sm-6 col-xs-6">${quoteData.lifeDetail.lifeWhoCovered}</div>
        </div>
    </li>
</c:if>
<c:if test="${not empty quoteData.lifeDetail.lifeCoverageAmount}">
    <li class="accordion-item__list-item">
        <div class="row">
            <div class="col-md-6 col-sm-6 col-xs-6">
                <spring:theme code="checkout.multi.quoteReview.life.coverage.amount" text="Coverage amount: "/>
            </div>
            <div class="col-md-6 col-sm-6 col-xs-6">${quoteData.lifeDetail.lifeCoverageAmount}</div>
        </div>
    </li>
</c:if>
<c:if test="${not empty quoteData.lifeDetail.lifeCoverageLast}">
    <li class="accordion-item__list-item">
        <div class="row">
            <div class="col-md-6 col-sm-6 col-xs-6">
                <spring:theme code="checkout.multi.quoteReview.life.length.of.coverage" text="Length of coverage: "/>
            </div>
            <div class="col-md-6 col-sm-6 col-xs-6">${quoteData.lifeDetail.lifeCoverageLast}</div>
        </div>
    </li>
</c:if>
<c:if test="${not empty quoteData.lifeDetail.lifeCoverStartDate}">
    <li class="accordion-item__list-item">
        <div class="row">
            <div class="col-md-6 col-sm-6 col-xs-6">
                <spring:theme code="checkout.multi.quoteReview.life.start.date" text="Start date: "/>
            </div>
            <div class="col-md-6 col-sm-6 col-xs-6">${quoteData.lifeDetail.lifeCoverStartDate}</div>
        </div>
    </li>
</c:if>
<c:if test="${not empty quoteData.lifeDetail.lifeMainDob}">
    <li class="accordion-item__list-item">
        <div class="row">
            <div class="col-md-6 col-sm-6 col-xs-6">
                <spring:theme code="checkout.multi.quoteReview.life.date.of.birth" text="Date Of Birth: "/>
            </div>
            <div class="col-md-6 col-sm-6 col-xs-6">${quoteData.lifeDetail.lifeMainDob}</div>
        </div>
    </li>
</c:if>
<c:if test="${not empty quoteData.lifeDetail.lifeMainSmoke}">
    <li class="accordion-item__list-item">
        <div class="row">
            <div class="col-md-6 col-sm-6 col-xs-6">
                <spring:theme code="checkout.multi.quoteReview.life.smoke" text="Do you smoke: "/>
            </div>
            <div class="col-md-6 col-sm-6 col-xs-6">${quoteData.lifeDetail.lifeMainSmoke}</div>
        </div>
    </li>
</c:if>
<c:if test="${not empty quoteData.lifeDetail.lifeSecondDob and not empty quoteData.lifeDetail.lifeSecondSmoke and not empty quoteData.lifeDetail.lifeRelationship}">
    <li class="accordion-item__list-item">
        <div class="row">
            <div class="col-md-6 col-sm-6 col-xs-6">
                <spring:theme code="checkout.multi.quoteReview.life.person.two" text="Person Two"/>
            </div>
        </div>
    </li>
</c:if>
<c:if test="${not empty quoteData.lifeDetail.lifeSecondDob}">
    <li class="accordion-item__list-item">
        <div class="row">
            <div class="col-md-6 col-sm-6 col-xs-6">
                <spring:theme code="checkout.multi.quoteReview.life.date.of.birth" text="Date Of Birth: "/>
            </div>
            <div class="col-md-6 col-sm-6 col-xs-6">${quoteData.lifeDetail.lifeSecondDob}</div>
        </div>
    </li>
</c:if>
<c:if test="${not empty quoteData.lifeDetail.lifeSecondSmoke}">
    <li class="accordion-item__list-item">
        <div class="row">
            <div class="col-md-6 col-sm-6 col-xs-6">
                <spring:theme code="checkout.multi.quoteReview.life.smoke" text="Do you smoke: "/>
            </div>
            <div class="col-md-6 col-sm-6 col-xs-6">${quoteData.lifeDetail.lifeSecondSmoke}</div>
        </div>
    </li>
</c:if>
<c:if test="${not empty quoteData.lifeDetail.lifeRelationship}">
    <li class="accordion-item__list-item">
        <div class="row">
            <div class="col-md-6 col-sm-6 col-xs-6">
                <spring:theme code="checkout.multi.quoteReview.life.relationship" text="Relationship to the second person: "/>
            </div>
            <div class="col-md-6 col-sm-6 col-xs-6">${quoteData.lifeDetail.lifeRelationship}</div>
        </div>
    </li>
</c:if>


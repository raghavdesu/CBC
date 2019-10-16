<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="cartData" required="true" type="de.hybris.platform.commercefacades.order.data.CartData" %>
<%@ attribute name="cartEntry" required="true" type="de.hybris.platform.commercefacades.order.data.OrderEntryData" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<spring:htmlEscape defaultHtmlEscape="true"/>

<c:choose>
    <c:when test="${not empty entry.product.price.recurringChargeEntries or cartData.insuranceQuote.quoteType eq 'LIFE'}">
        <c:set var="paymentFrequency"><spring:theme code="checkout.cart.payment.frequency.monthly" text="Monthly"/></c:set>
    </c:when>
    <c:otherwise>
        <c:set var="paymentFrequency"><spring:theme code="checkout.cart.payment.frequency.annual" text="Annual"/></c:set>
    </c:otherwise>
</c:choose>

<c:set var="shownStartDate" value=""/>
<c:if test="${cartData.insuranceQuote.quoteType ne 'EVENT'}">
    <c:set var="shownStartDate">${cartData.insuranceQuote.startDate}</c:set>
</c:if>

<c:if test="${not empty cartData.insuranceQuote.formattedStartDate}">
    <c:set var="shownStartDate">${cartData.insuranceQuote.formattedStartDate}</c:set>
</c:if>

<c:if test="${not empty shownStartDate and cartData.insuranceQuote.quoteType ne 'LIFE'}">
    <div class="short-overview__item">
        <span class="short-overview__item-name col-xs-7"><spring:theme code="checkout.cart.start.date" text="Start Date"/>:</span>
        <span class="short-overview__item-price col-xs-5">${cartData.insuranceQuote.formattedStartDate}</span>
    </div>
</c:if>
<c:if test="${cartData.insuranceQuote.quoteType eq 'TRAVEL'}">
    <c:if test="${not empty cartData.insuranceQuote.tripEndDate}">
        <div class="short-overview__item">
            <span class="short-overview__item-name col-xs-7"><spring:theme code="checkout.cart.end.date" text="End Date"/>:</span>
            <span class="short-overview__item-price col-xs-5">${cartData.insuranceQuote.tripEndDate}</span>
        </div>
    </c:if>
    <c:if test="${not empty cartData.insuranceQuote.tripNoOfTravellers}">
        <div class="short-overview__item">
            <span class="short-overview__item-name col-xs-7"><spring:theme code="checkout.cart.num.travellers" text="Number of Travellers"/>:</span>
            <span class="short-overview__item-price col-xs-5">${cartData.insuranceQuote.tripNoOfTravellers}</span>
        </div>
        <div class="short-overview__item">
            <span class="short-overview__item-name col-xs-7"><spring:theme code="checkout.cart.age.travellers" text="Travellers Ages"/>:</span>
            <span class="short-overview__item-price col-xs-5">
                <c:forEach items="${cartData.insuranceQuote.tripTravellersAge}" var="age" varStatus="status">
                    ${age}<c:if test="${not status.last}">, </c:if>
                </c:forEach>
            </span>
        </div>
    </c:if>
</c:if>

<c:if test="${cartData.insuranceQuote.quoteType eq 'AUTO'}">
    <c:if test="${not empty cartData.insuranceQuote.autoDetail.autoMake}">
        <div class="short-overview__item">
            <span class="short-overview__item-name col-xs-7"><spring:theme code="text.insurance.auto.vehicle.make" text="Vehicle Make: "/></span>
            <span class="short-overview__item-price col-xs-5">${cartData.insuranceQuote.autoDetail.autoMake}</span>
        </div>
    </c:if>
    <c:if test="${not empty cartData.insuranceQuote.autoDetail.autoModel}">
        <div class="short-overview__item">
                                <span class="short-overview__item-name col-xs-7"><spring:theme code="text.insurance.auto.vehicle.model"
                                                                                               text="Vehicle Model: "/></span>
            <span class="short-overview__item-price col-xs-5">${cartData.insuranceQuote.autoDetail.autoModel}</span>
        </div>
    </c:if>
    <c:if test="${not empty cartData.insuranceQuote.autoDetail.autoType}">
        <div class="short-overview__item">
            <span class="short-overview__item-name col-xs-7"><spring:theme code="text.insurance.auto.vehicle.type" text="Vehicle Type: "/></span>
            <span class="short-overview__item-price col-xs-5">${cartData.insuranceQuote.autoDetail.autoType}</span>
        </div>
    </c:if>
    <c:if test="${not empty cartData.insuranceQuote.autoDetail.autoYear}">
        <div class="short-overview__item">
                                <span class="short-overview__item-name col-xs-7"><spring:theme code="text.insurance.auto.vehicle.year"
                                                                                               text="Vehicle Year: "/></span>
            <span class="short-overview__item-price col-xs-5">${cartData.insuranceQuote.autoDetail.autoYear}</span>
        </div>
    </c:if>
    <c:if test="${not empty cartData.insuranceQuote.autoDetail.autoLicense}">
        <div class="short-overview__item">
                                <span class="short-overview__item-name col-xs-7"><spring:theme code="text.insurance.auto.vehicle.license"
                                                                                               text="Vehicle License: "/></span>
            <span class="short-overview__item-price col-xs-5">${cartData.insuranceQuote.autoDetail.autoLicense}</span>
        </div>
    </c:if>
    <c:if test="${not empty cartData.insuranceQuote.autoDetail.autoPrice}">
        <div class="short-overview__item">
            <span class="short-overview__item-name col-xs-7"><spring:theme code="text.insurance.auto.vehicle.value" text="Vehicle Value: "/></span>
            <span class="short-overview__item-price col-xs-5">${cartData.insuranceQuote.autoDetail.autoPrice}</span>
        </div>
    </c:if>
</c:if>

<c:if test="${cartData.insuranceQuote.quoteType eq 'LIFE'}">
    <c:if test="${not empty cartData.insuranceQuote.lifeDetail.lifeWhoCovered}">
        <div class="short-overview__item">
            <span class="short-overview__item-name col-xs-7"><spring:theme code="text.insurance.life.covered" text="Who is being covered: "/></span>
            <span class="short-overview__item-price col-xs-5">${cartData.insuranceQuote.lifeDetail.lifeWhoCovered}</span>
        </div>
    </c:if>
    <c:if test="${not empty cartData.insuranceQuote.lifeDetail.lifeCoverageAmount}">
        <div class="short-overview__item">
            <span class="short-overview__item-name col-xs-7"><spring:theme code="text.insurance.life.coverage.amount" text="Coverage amount: "/></span>
            <span class="short-overview__item-price col-xs-5">${cartData.insuranceQuote.lifeDetail.lifeCoverageAmount}</span>
        </div>
    </c:if>
    <c:if test="${not empty cartData.insuranceQuote.lifeDetail.lifeCoverageLast}">
        <div class="short-overview__item">
            <span class="short-overview__item-name col-xs-7"><spring:theme code="text.insurance.life.length.of.coverage" text="Length of coverage: "/></span>
            <span class="short-overview__item-price col-xs-5">${cartData.insuranceQuote.lifeDetail.lifeCoverageLast}</span>
        </div>
    </c:if>
    <c:if test="${not empty cartData.insuranceQuote.lifeDetail.lifeCoverStartDate}">
        <div class="short-overview__item">
            <span class="short-overview__item-name col-xs-7"><spring:theme code="text.insurance.life.start.date" text="Start date: "/></span>
            <span class="short-overview__item-price col-xs-5">${cartData.insuranceQuote.lifeDetail.lifeCoverStartDate}</span>
        </div>
    </c:if>
</c:if>

<c:if test="${cartData.insuranceQuote.quoteType eq 'SAVINGS'}">
    <c:if test="${not empty cartData.insuranceQuote.savingsDetail.annualContributionIncrease}">
        <div class="short-overview__item">
            <span class="short-overview__item-name col-xs-7"><spring:theme code="text.insurance.savings.annual.contribution.increase" text="Annual Contribution Increase: "/></span>
            <span class="short-overview__item-price col-xs-5">${cartData.insuranceQuote.savingsDetail.annualContributionIncrease}&#37;</span>
        </div>
    </c:if>
    <c:if test="${not empty cartData.insuranceQuote.savingsDetail.retirementAge}">
        <div class="short-overview__item">
            <span class="short-overview__item-name col-xs-7"><spring:theme code="text.insurance.savings.retirement.age" text="Retirement age: "/></span>
            <span class="short-overview__item-price col-xs-5">${cartData.insuranceQuote.savingsDetail.retirementAge}</span>
        </div>
    </c:if>
</c:if>

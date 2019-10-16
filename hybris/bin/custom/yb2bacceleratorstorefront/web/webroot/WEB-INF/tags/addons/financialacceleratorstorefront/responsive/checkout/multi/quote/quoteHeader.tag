<%@ attribute name="insuranceQuoteReviews" required="true" type="java.util.List<de.hybris.platform.commercefacades.insurance.data.InsuranceQuoteReviewData>" %>
<%@ attribute name="cartData" required="false" type="de.hybris.platform.commercefacades.order.data.CartData" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<c:if test="${not empty insuranceQuoteReviews}">
    <c:forEach items="${insuranceQuoteReviews}" var="quoteReview">
        <c:forEach items="${quoteReview.mainProduct.coverageProduct.images}" var="image">
            <c:if test="${image.format == '40Wx40H_quote_responsive'}">
                <c:set var="thumbnail_img" value="${image}"/>
            </c:if>
        </c:forEach>
        <div class="row accordion-header">
            <div class="col-md-1 col-sm-1 col-xs-12 accordion-header__icon">
                <span class="images images__wrapper images__wrapper--size"><img class="images__size" src="${thumbnail_img.url}"/></span>
            </div>
            <div class="col-md-7 col-sm-7 col-xs-12 accordion-header__text">
                <spring:theme code="checkout.multi.quoteReview.title.${fn:toLowerCase(cmsSite.channel)}" text="Application/Quote {0}" arguments="${quoteReview.mainProduct.coverageProduct.defaultCategory.name}"/>
            </div>
            <div class="col-md-4 col-sm-4 col-xs-12 accordion-header__details">
                <c:choose>
                    <c:when test="${cartData.insuranceQuote.state eq 'BIND'}">
                        <div class="accordion-header__id"><spring:theme code="checkout.multi.quoteReview.quote.id" text="ID: {0}" arguments="${cartData.insuranceQuote.quoteId}" /></div>
                        <div class="accordion-header__expiry-date"><spring:theme code="checkout.multi.quoteReview.expiry.date" text="Expiry Date: {0}" arguments="${cartData.insuranceQuote.formattedExpiryDate}" /></div>
                    </c:when>
                </c:choose>
            </div>
        </div>
    </c:forEach>
</c:if>

<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="cartTitle" required="false" type="java.lang.String" %>
<%@ attribute name="messageKey" required="false" type="java.lang.String" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<spring:theme code='checkout.cart.empty.text' var="defaultText" />
<div class="section-header__heading">
    <spring:theme code="checkout.multi.quoteReview.title.${fn:toLowerCase(cmsSite.channel)}" text="Application/Quote {0}" arguments="${cartTitle}"/>
</div>
<div id="desktop-spinner" class="spinner spinner--desktop js-spinner"></div>
<div class="short-overview__items">
    <div class="short-overview__item">
        <span class="short-overview__item-name col-xs-12"><spring:theme code="${messageKey}" text="${defaultText}"/></span>
    </div>
    <div id="orderTotals" class="short-overview__item short-overview__item--highlighted">
    </div>
</div>

<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<div class="notice-text">
    <h3 class="notice-text__heading">
        <spring:theme code="checkout.error.price.calculation.error"
                      text="There has been an error with price calculation, please try again."/>
    </h3>
</div>

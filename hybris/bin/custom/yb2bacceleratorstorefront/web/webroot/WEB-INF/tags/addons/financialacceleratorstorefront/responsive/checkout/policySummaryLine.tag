<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ attribute name="images" required="true" type="java.util.Collection" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<spring:htmlEscape defaultHtmlEscape="true" />

<div class="col-md-1 col-sm-1 col-xs-12">
    <span class="images images__wrapper images__wrapper--size">
        <c:forEach items="${images}" var="image">
            <c:if test="${image.format == '40Wx40H_policy_responsive'}">
                <c:set var="thumbnail_img" value="${image}"/>
            </c:if>
        </c:forEach>
        <c:if test="${not empty thumbnail_img}"><img class="images__size" src="${thumbnail_img.url}"/></c:if>
    </span>
</div>
<div class="col-md-7 col-sm-7 col-xs-12 accordion-header__summary-line-text">
    <spring:theme code="checkout.link.quote.name" text="Your quote name is" />&nbsp;${fn:escapeXml(categoryName)} <br/>
    <spring:theme code="checkout.link.quote.number" text="Your quote number is" />: ${fn:escapeXml(orderData.insuranceQuote.quoteId)}
</div>

<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="cartData" required="true" type="de.hybris.platform.commercefacades.order.data.CartData" %>
<%@ attribute name="flowStartUrl" required="true" type="java.lang.String" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:forEach items="${cartData.entries}" var="entry" varStatus="status">
	<c:if test="${status.first}">
		<c:if test="${cartData.insuranceQuote.state eq 'UNBIND'}">
			<c:choose>
				<c:when test="${fn:toLowerCase(fn:escapeXml(cmsSite.channel)) eq 'insurance'}">
					<spring:url var="editInformationUrl" value="/c/${entry.product.defaultCategory.code}"  htmlEscape="false">
						<spring:param value="view" name="viewStatus"/>
					</spring:url>
				</c:when>
				<c:otherwise>
					<spring:url var="editInformationUrl" value="/p/${entry.product.code}/configuratorPage/YFORM"  htmlEscape="false" />
				</c:otherwise>
			</c:choose>
			<div class="short-overview__link-wrapper">
				<a class="mean-link mean-link--bold" href="${editInformationUrl}"><spring:theme code="checkout.cart.modify.plan" text="Modify Plan" /></a>
			</div>
		</c:if>
	</c:if>
</c:forEach>

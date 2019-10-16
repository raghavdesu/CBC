<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ attribute name="product" required="true"
			  type="de.hybris.platform.commercefacades.product.data.ProductData"%>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<spring:htmlEscape defaultHtmlEscape="true"/>


<c:set value="${product.bundleTemplates[0]}" var="productPackage" />
<c:set value="${product.price.oneTimeChargeEntries}" var="productComponents" />

<c:set value="${not empty product.potentialPromotions}"
	   var="hasPromotion" />

<li class="product__list--item col-xs-12 col-sm-6 col-md-3">
	<div class="product__list--item-wrapper">
		<ycommerce:testId code="test_searchPage_wholeProduct">

			<ycommerce:testId code="searchPage_productName_link_${product.code}">
				<h3 class="product__list--category">${fn:escapeXml(product.name)}</h3>
			</ycommerce:testId>
			<c:forEach items="${product.images}" var="image">
				<c:if test="${image.format == '40Wx40H_policy_responsive'}">
					<c:set var="thumbnail_img" value="${image}"/>
				</c:if>
			</c:forEach>
			<c:if test="${not empty thumbnail_img}">
				<div class="images images__wrapper" >
					<img class="images__size" src="${thumbnail_img.url}"/>
				</div>
			</c:if>
			<div class="base__options">
				<c:set value="${fn:length(productComponents) - 1}" var="size" />
				<c:forEach var="billingEvent"
						   items="${productComponents}" begin="1" end="3">
					<c:choose>
						<c:when test="${billingEvent.billingTime.name != null && billingEvent.price.value > 0}">
							<div class="event-name">${fn:escapeXml(billingEvent.billingTime.name)} up to ${fn:escapeXml(billingEvent.price.formattedValue)}</div>
						</c:when>
						<c:when test="${billingEvent.billingTime.name != null && billingEvent.chargeInformation != null}">
							<div class="event-name">${fn:escapeXml(billingEvent.billingTime.name)} - ${fn:escapeXml(billingEvent.chargeInformation)}</div>
						</c:when>
						<c:otherwise>
							<div class="event-name">${fn:escapeXml(billingEvent.billingTime.name)}</div>
						</c:otherwise>
					</c:choose>
				</c:forEach>
				<c:choose>
					<c:when test="${size > 3}">
						<div class="additional-message"><spring:message code="text.search.muchMore" /></div>
					</c:when>
				</c:choose>
			</div>
			<div class="buttons-wrapper">
				<spring:url var="moreInfoUrl" value="${product.defaultCategory.parentCategory.url}" htmlEscape="false"/>
				<a class="primary-button primary-button__default primary-button__edit" href="${moreInfoUrl}">
					<spring:message code="text.search.moreInfo" />
				</a>
				<form method="get" action="${fn:escapeXml(request.contextPath)}${fn:escapeXml(productPackage.products[0].defaultCategory.url)}">
					<button type="submit" class="secondary-button secondary-button__default secondary-button__edit" >
						<spring:message code="text.search.getQuote" />
					</button>
				</form>
			</div>

		</ycommerce:testId>
	</div>
</li>

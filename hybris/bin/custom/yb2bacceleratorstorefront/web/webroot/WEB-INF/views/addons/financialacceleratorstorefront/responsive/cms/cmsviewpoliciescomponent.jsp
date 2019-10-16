<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true"/>
<spring:url value="/my-account/policy/" var="policyDetailsUrl" htmlEscape="false"/>

<c:url value="/my-account/my-policies" var="accountUrl"/>
<c:if test="${component.visible}">
	<div class="review__policies">
		<c:choose>
			<c:when test="${isAnonymousUser == true}">
				<a href="${accountUrl}">
					<button class="secondary-button secondary-button__default secondary-button__home"><spring:theme code="homepage.viewpoliciescomponent.anonymoususer.button.label" /></button>
				</a>
			</c:when>
			<c:otherwise>
				<c:set value="${component.numberOfPoliciesToDisplay}" var="maxItems" />
				<c:choose>
					<c:when test="${not empty policies}">
						<div class="my-policies">
							<h2 class="my-policies__title"><spring:theme code="text.home.viewPolicies" text="View Policies"/></h2>
							<ul>
								<c:forEach items="${policies}" begin="0" end="${maxItems - 1}" var="policy">
									<c:set var="category" value="${policy.categoryData.name}" />
									<c:set var="item" value="${policy.mainProduct}" />
									<c:forEach items="${item.coverageProduct.images}" var="image">
										<c:if test="${image.format == '40Wx40H_policy_responsive'}">
											<c:set var="thumbnail_img" value="${image}" />
										</c:if>
									</c:forEach>
									<a href="${policyDetailsUrl}${ycommerce:encodeUrl(policy.policyNumber)}&#47;${ycommerce:encodeUrl(policy.contractNumber)}" target="_blank">
										<li class="my-policies__my-policy">
											<div class="my-policies__data-container">
										<span class="images images__wrapper">
											<img class="images images__size" src="${thumbnail_img.url}" alt=""/>
										</span>
												<div class="my-policies__name-number">
													<span class="my-policies__name">${fn:escapeXml(category)}&nbsp;<spring:theme code="homepage.viewpoliciescomponent.policy.label" /></span>
													<span class="my-policies__number">${fn:escapeXml(policy.policyNumber)}</span>
												</div>
												<span class="my-policies__add-infos">${policy.policyEndDate}</span>
											</div>
										</li>
									</a>
								</c:forEach>
							</ul>
							<c:if test="${policies.size() gt maxItems}">
								<p><a href="${accountUrl}"><button class="secondary-button secondary-button__default secondary-button__home"><spring:theme code="homepage.viewpoliciescomponent.too.many" /></button></a></p>
							</c:if>
						</div>
					</c:when>
					<c:otherwise>
						<div class="none-policies">
							<h2 class="none-policies__title"><spring:theme code="text.home.viewPolicies" text="View Policies"/></h2>
							<p class="none-policies__content"><spring:theme code="homepage.viewquotescomponent.empty.policy.title" /></p>
						</div>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</div>
</c:if>

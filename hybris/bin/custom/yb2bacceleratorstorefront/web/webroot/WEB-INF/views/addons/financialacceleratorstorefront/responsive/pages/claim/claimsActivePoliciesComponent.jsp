<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="formatter" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/format" %>
<spring:htmlEscape defaultHtmlEscape="true"/>

<c:choose>
    <c:when test="${empty policies}">
		<div class="notice-text">
			<h3 class="notice-text__heading">
			    <spring:theme code="text.account.myPolicies.noPolicies" text="You have no valid policies"/>
			</h3>
		</div>
    </c:when>
    <c:otherwise>
	    <div class="row">
	        <c:forEach items="${policies}" var="policy">
	        	<div class="claims col-sm-6 col-md-4" data-policy="${fn:escapeXml(policy.policyNumber)}" data-contract="${fn:escapeXml(policy.contractNumber)}">
	        		<c:set var="insuredObject" value="${policy.insuredObjects[0]}"/>
					<div class="claims-feature__wrapper">
						<h3 class="item-headline item-headline--type-uppercase-chubby">
							<c:if test="${not empty policy.categoryData}">
								<spring:theme code="claim.item.policy" arguments="${policy.categoryData.name}"/>
							</c:if>
						</h3>
						<div class="claims-feature__image">
							<span class="images images__wrapper">
								 <c:if test="${not empty policy.mainProduct.coverageProduct}">
                                    <c:forEach items="${policy.mainProduct.coverageProduct.images}" var="image">
										<c:if test="${image.format == '40Wx40H_quote_responsive'}">
											<c:set var="thumbnail_img" value="${image}"/>
										</c:if>
								</c:forEach>
								</c:if>
				          		<c:if test="${not empty thumbnail_img}"><img class="images__size" src="${thumbnail_img.url}" alt=""/></c:if>
							</span>
						</div>
						<ul class="claims-feature__details">
							<c:set var="insuredObjectType" value="${fn:toLowerCase(insuredObject.insuredObjectType)}"/>
							<li>
				                <c:if test="${not empty insuredObject.insuredObjectItems[0]}">
				                    <c:set var="insuredObjectItem" value="${insuredObject.insuredObjectItems[0]}"/>
			                            <label class="item-label"><spring:theme code="policy.details.${insuredObjectType}.${insuredObjectItem.label}"/></label> : <span class="item-data--blue">${fn:escapeXml(insuredObjectItem.value)}</span>
				                </c:if>
							</li>
							<li>
				                <c:if test="${not empty insuredObject.insuredObjectItems[1]}">
				                    <c:set var="insuredObjectItem" value="${insuredObject.insuredObjectItems[1]}"/>
			                            <label class="item-label"><spring:theme code="policy.details.${insuredObjectType}.${insuredObjectItem.label}"/></label> :  <span class="item-data--blue">${fn:escapeXml(insuredObjectItem.value)}</span>
				                </c:if>
							</li>
						</ul>
					</div>
	            </div>
	        </c:forEach>
		</div>
    </c:otherwise>
</c:choose>

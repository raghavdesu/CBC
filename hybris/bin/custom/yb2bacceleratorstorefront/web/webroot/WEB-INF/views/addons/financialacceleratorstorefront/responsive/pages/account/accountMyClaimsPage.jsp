<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="formatter" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/format" %>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>
<spring:htmlEscape defaultHtmlEscape="true"/>


<h2 class="heading-headline">
    <spring:theme code="text.account.myClaims" text="Claims"/>
</h2>
<c:choose>
    <c:when test="${empty claims}">
        <p>
            <spring:theme code="text.account.myClaims.noClaims" text="You have no claims"/>
        </p>
    </c:when>
    <c:otherwise>
        <div class="row">
            <c:forEach items="${claims}" var="claim">
                <div class="col-xs-12 col-sm-6 col-md-4 cards">
                    <div class="cards__wrapper cards__wrapper--border-primary">
                        <div class="account-cards-actions">
                            <c:if test="${claim.claimStatus eq 'OPEN' || claim.claimStatus eq 'ERROR'}">
                                <ycommerce:testId code="myClaims_deleteClaim_button" >
                                    <a class="action-links action-links--primary-button js-deleteClaimButton" href="#" data-claim-number="${fn:escapeXml(claim.claimNumber)}">
                                        <span class="glyphicon glyphicon-trash"></span>
                                    </a>
                                </ycommerce:testId>
                            </c:if>
                        </div>
                        <div class="cards__title cards__title--border-primary">
	                        <span class="images images__wrapper">
	                            <c:choose>
	                                <c:when test="${claim.incidentType.icon.url ne null}">
	                                    <img class="images__size" src="${claim.incidentType.icon.url}" alt="${claim.incidentType.icon.altText}">
	                                </c:when>
	                                <c:otherwise>
	                                    <spring:theme code="text.account.myClaims.claim.incidentType.icon.url.not.applicable" text="/" var="imagePath" htmlEscape="false"/>
	                                    <c:choose>
	                                        <c:when test="${originalContextPath ne null}">
	                                            <c:url value="${imagePath}" var="imageUrl" context="${originalContextPath}"/>
	                                        </c:when>
	                                        <c:otherwise>
	                                            <c:url value="${imagePath}" var="imageUrl" />
	                                        </c:otherwise>
	                                    </c:choose>
	                                    <img class="images__size" src="${imageUrl}" alt="">
	                                </c:otherwise>
	                            </c:choose>
	                        </span>
                            <h4 class="cards__caption cards__caption--color-primary">
                                <c:choose>
                                    <c:when test="${not empty claim.incidentType.incidentName}">
                                        ${fn:escapeXml(claim.incidentType.incidentName)}
                                    </c:when>
                                    <c:otherwise>
                                        <spring:theme code="text.account.myClaims.claim.incidentType.incidentName.not.applicable" text="N/A"/>
                                    </c:otherwise>
                                </c:choose>
                            </h4>
							<div class="cards__info cards__info--color-primary">
                               <c:choose>
                                   <c:when test="${claim.claimStatus eq 'PROCESSING' || claim.claimStatus eq 'APPROVED'}">
                                       ${fn:escapeXml(claim.claimNumber)}
                                   </c:when>
                                   <c:otherwise>
                                       ${fn:escapeXml(claim.requestId)}
                                   </c:otherwise>
                               </c:choose>
                           </div>
                        </div>
                        <div class="cards__details-wrapper">
                            <div class="cards__data">
                                <span class="title">
                                    ${fn:escapeXml(claim.insurancePolicy.categoryData.name)}
                                </span>
                                <span class="value">
                                        ${fn:escapeXml(claim.insurancePolicy.policyNumber)}
                                </span>
                            </div>
                            <div class="cards__data">
                            <span class="title">
                                <spring:theme code="text.account.myClaims.dateOfLoss" text="Date of Loss"/>
                            </span>
                                <span class="value">
                                <c:choose>
                                    <c:when test="${not empty claim.dateOfLoss}">
                                        <formatter:stringToDate inputValue="${claim.dateOfLoss}" inputDatePattern="dd-MM-yyyy" outputDatePattern="dd MMM yyyy"/>
                                    </c:when>
                                    <c:otherwise>
                                        <spring:theme code="text.account.myClaims.claim.incidentType.dateOfLoss.not.applicable" text="N/A"/>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                            </div>
                            <div class="cards__data">
                            <span class="title">
                            	<spring:theme code="text.account.myClaims.status" text="Status"/>
                            </span>
                             <c:choose>
                                <c:when test="${claim.claimStatus eq 'PROCESSING'|| claim.claimStatus eq 'APPROVED'}">
                                <span class="status__icon icon-ok">
                                 </c:when>
                                 <c:when test="${claim.claimStatus eq 'REJECTED' || claim.claimStatus eq 'ERROR'}">
                                     <span class="status__icon icon-remove">
                                 </c:when>
                                 <c:otherwise>
                                     <span class="status__icon icon-info">
                                 </c:otherwise>
                             </c:choose>
                             ${fn:escapeXml(claim.claimStatus)}
                            </span>
                            </div>
                            <div class="cards__data">
                                <span class="title">
                                    <spring:theme code="text.account.myClaims.claimHandler.title" text="Claim Handler"/>
                                </span>
                                <span class="value">
                                    <c:choose>
                                        <c:when test="${not empty claim.claimHandler}">
                                                <span class="value">
                                                    ${fn:escapeXml(claim.claimHandler.displayName)}
                                                </span><br/>
                                                <span class="value">
                                                    ${fn:escapeXml(claim.claimHandler.email)}
                                                </span>
                                        </c:when>
                                        <c:otherwise>
                                            <spring:theme code="text.account.myClaims.claim.claimHandler.not.applicable" text="N/A"/><br/>
                                            <spring:theme code="text.account.myClaims.claim.claimHandler.not.applicable" text="N/A"/>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        <div class="cards-button-wrapper cards-button-wrapper--border-primary">
                            <div class="cards__button">
                                <c:choose>
                                    <c:when test="${claim.claimStatus eq 'OPEN' || claim.claimStatus eq 'REJECTED'}">
                                        <spring:url var="claimCheckoutStep1" value="/fsStepGroup/${claim.requestId}/step/1" htmlEscape="false"/>
                                        <a class="secondary-button secondary-button__default secondary-button__account-policies" href="${claimCheckoutStep1}">
                                            <spring:theme code="text.account.myClaims.claim.resume" text="Resume"/>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="secondary-button secondary-button__default secondary-button__account-policies" href="#">
                                            <spring:theme code="text.account.myClaims.claim.view" text="Details"/>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="display-none">
                    <div id="popup_confirm_claim_deletion_${fn:escapeXml(claim.claimNumber)}" class="popup-content-wrapper">
                        <h3><spring:theme code="text.account.myClaims.delete.open.claim"/></h3>
                        <p><spring:theme code="text.account.myClaims.delete.open.claim.following"/></p>
                        <div class="modal-actions">
                            <div class="row">
                    			<c:url value="/claims/delete" var="deleteClaimActionUrl"/>
                    			<form:form id="deleteClaim${fn:escapeXml(claim.claimNumber)}" action="${deleteClaimActionUrl}" method="post">
                        		<input type="hidden" name="claimNumber" value="${fn:escapeXml(claim.claimNumber)}"/>
                                <ycommerce:testId code="myClaimsDelete_delete_button" >
                                    <div class="col-xs-12 col-sm-6 col-sm-push-6">
                                        <button type="submit" class="primary-button primary-button__default primary-button__popup">
                                            <spring:theme code="text.account.myClaims.delete"/>
                                        </button>
                                    </div>
                                </ycommerce:testId>
                               </form:form>
                                <div class="col-xs-12 col-sm-6 col-sm-pull-6">
                                    <button class="closeColorBox secondary-button secondary-button__default secondary-button__popup">
                                        <spring:theme code="text.button.cancel" />
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>

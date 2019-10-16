<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:set var="noBorder" value=""/>
<c:if test="${not empty paymentInfoData}">
    <c:set var="noBorder" value="no-border"/>
</c:if>

<h2 class="heading-headline ${noBorder}">
    <spring:theme code="text.account.paymentDetails" />
</h2>

<c:choose>
    <c:when test="${not empty paymentInfoData}">
        <div class="row">
            <c:forEach items="${paymentInfoData}" var="paymentInfo">
                <div class="col-xs-12 col-sm-6 col-md-4">
                    <div class="card">
                        <h4 class="card__subtitle"><spring:theme code="text.account.paymentDetails.cardTitle"/></h4>

                        <div class="card__image-container">
                            <div class="centered-image">
                                <theme:image code="img.payment.details.default"/>
                            </div>
                        </div>
                        <h4 class="centered-bold-title">${fn:escapeXml(paymentInfo.cardTypeData.name)}</h4>
                        <div class="account-cards-actions pull-left">
                            <ycommerce:testId code="paymentDetails_deletePayment_button" >
                                <a class="action-links removePaymentDetailsButton" href="#" data-payment-id="${fn:escapeXml(paymentInfo.id)}" data-popup-title="<spring:theme code="text.account.paymentDetails.delete.popup.title"/>">
                                    <span class="glyphicon glyphicon-trash"></span>
                                </a>
                            </ycommerce:testId>
                        </div>
                        <div class="card-details">
                            <c:if test="${paymentInfo.billingAddress ne null}">
                                <div class="rows-info">
                                    <div class="rows-info__row">
                                        <p class="rows-info__item rows-info__item--label"><spring:theme code="text.account.paymentDetails.cardHolder"/> :</p>
                                        <p class="rows-info__item rows-info__item--paragraph">${fn:escapeXml(paymentInfo.accountHolderName)}</p>
                                    </div>
                                    <div class="rows-info__row">
                                        <p class="rows-info__item rows-info__item--label"><spring:theme code="text.account.paymentDetails.cardNumber"/> :</p>
                                        <p class="rows-info__item rows-info__item--paragraph"><ycommerce:testId code="paymentDetails_item_cardNumber_text" >${fn:escapeXml(paymentInfo.cardNumber)}</ycommerce:testId></p>
                                    </div>
                                    <div class="rows-info__row">
                                        <p class="rows-info__item rows-info__item--label"><spring:theme code="text.account.paymentDetails.expires"/> :</p>
                                        <p class="rows-info__item rows-info__item--paragraph"><c:if test="${paymentInfo.expiryMonth lt 10}">0</c:if> ${fn:escapeXml(paymentInfo.expiryMonth)}&nbsp;/&nbsp;${fn:escapeXml(paymentInfo.expiryYear)}</p>
                                    </div>
                                    <div class="rows-info__row">
                                        <p class="rows-info__item rows-info__item--label"><spring:theme code="text.account.paymentDetails.billingAddress"/> :</p>
                                        <p class="rows-info__item rows-info__item--paragraph">${fn:escapeXml(paymentInfo.billingAddress.line1)}</p>
                                    </div>
                                    <div class="rows-info__row">
                                        <p class="rows-info__item rows-info__item--label"><spring:theme code="text.account.paymentDetails.billingCity"/> :</p>
                                        <p class="rows-info__item rows-info__item--paragraph">${fn:escapeXml(paymentInfo.billingAddress.town)}&nbsp;${fn:escapeXml(paymentInfo.billingAddress.region.isocodeShort)}</p>
                                    </div>
                                    <div class="rows-info__row">
                                        <p class="rows-info__item rows-info__item--label"><spring:theme code="text.account.paymentDetails.billingCountry"/> :</p>
                                        <p class="rows-info__item rows-info__item--paragraph">${fn:escapeXml(paymentInfo.billingAddress.country.name)}&nbsp;${fn:escapeXml(paymentInfo.billingAddress.postalCode)}</p>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                        <c:set var="diabledButtonClass" value=""/>
                        <c:set var="disabledButtonPropery" value=""/>
                        <c:if test="${paymentInfo.defaultPaymentInfo}" >
                            <c:set var="diabledButtonClass" value="btn btn-default btn-block"/>
                            <c:set var="disabledButtonPropery" value="disabled='disabled'"/>
                        </c:if>
                        <c:url value="/my-account/set-default-payment-details" var="setDefaultPaymentActionUrl"/>
                        <form:form class="set-default" id="setDefaultPaymentDetails${fn:escapeXml(paymentInfo.id)}" action="${setDefaultPaymentActionUrl}" method="post">
                            <input type="hidden" name="paymentInfoId" value="${fn:escapeXml(paymentInfo.id)}"/>
                            <ycommerce:testId code="paymentDetails_setAsDefault_button" >
                                <button type="submit" ${disabledButtonPropery} class="primary-button primary-button__default primary-button__infos ${diabledButtonClass}">
                                    <c:choose>
                                        <c:when test="${paymentInfo.defaultPaymentInfo}">
                                            <spring:theme code="text.default" />
                                        </c:when>
                                        <c:otherwise>
                                            <spring:theme code="text.setDefault" />
                                        </c:otherwise>
                                    </c:choose>
                                </button>
                            </ycommerce:testId>
                        </form:form>
                </div>
            </div>
                <div class="display-none">
                    <div id="popup_confirm_payment_removal_${fn:escapeXml(paymentInfo.id)}" class="account-address-removal-popup">
                        <spring:theme code="text.account.paymentDetails.delete.following"/>
                        <div class="address">
                            <strong>
                            ${fn:escapeXml(paymentInfo.accountHolderName)}
                            </strong>
                            <br>${fn:escapeXml(paymentInfo.cardTypeData.name)}
                            <br>${fn:escapeXml(paymentInfo.cardNumber)}
                            <br>
                            <c:if test="${paymentInfo.expiryMonth lt 10}">0</c:if>
                            ${fn:escapeXml(paymentInfo.expiryMonth)}&nbsp;/&nbsp;${fn:escapeXml(paymentInfo.expiryYear)}
                            <c:if test="${paymentInfo.billingAddress ne null}">
                                <br>${fn:escapeXml(paymentInfo.billingAddress.line1)}
                                <br>${fn:escapeXml(paymentInfo.billingAddress.town)}&nbsp;${fn:escapeXml(paymentInfo.billingAddress.region.isocodeShort)}
                                <br>${fn:escapeXml(paymentInfo.billingAddress.country.name)}&nbsp;${fn:escapeXml(paymentInfo.billingAddress.postalCode)}
                            </c:if>
                        </div>
                        <c:url value="/my-account/remove-payment-method" var="removePaymentActionUrl"/>
                        <form:form id="removePaymentDetails${fn:escapeXml(paymentInfo.id)}" action="${removePaymentActionUrl}" method="post">
                            <input type="hidden" name="paymentInfoId" value="${fn:escapeXml(paymentInfo.id)}"/>
                            <br />
                            <div class="modal-actions">
                                <div class="row">
                                    <ycommerce:testId code="paymentDetailsDelete_delete_button" >
                                        <div class="col-xs-12 col-sm-6 col-sm-push-6">
                                            <button type="submit" class="btn btn-default btn-primary btn-block paymentsDeleteBtn">
                                                <spring:theme code="text.account.paymentDetails.delete"/>
                                            </button>
                                        </div>
                                    </ycommerce:testId>
                                    <div class="col-xs-12 col-sm-6 col-sm-pull-6">
                                        <a class="btn btn-default closeColorBox paymentsDeleteBtn btn-block" data-payment-id="${fn:escapeXml(paymentInfo.id)}">
                                            <spring:theme code="text.button.cancel" />
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </form:form>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:when>
    <c:otherwise>
        <p>
            <spring:theme code="text.account.paymentDetails.noPaymentInformation" />
        </p>
    </c:otherwise>
</c:choose>

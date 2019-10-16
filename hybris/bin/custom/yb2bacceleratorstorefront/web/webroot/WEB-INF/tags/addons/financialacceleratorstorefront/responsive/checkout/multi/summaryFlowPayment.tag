<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="paymentInfo" required="true" type="de.hybris.platform.commercefacades.order.data.CCPaymentInfoData" %>
<%@ attribute name="requestSecurityCode" required="true" type="java.lang.Boolean" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<c:set value="${not empty paymentInfo and not empty paymentInfo.billingAddress}" var="billingAddressOk"/>
<spring:theme code="checkout.summary.paymentMethod.securityCode.whatIsThis.description" var="securityWhatText"/>

<div class="final-review__body--word-break js-summaryPayment"  data-security-what-text="${securityWhatText}">
    <div class="row">
        <ycommerce:testId code="checkout_paymentDetails_text">
                <div class="col-xs-6 col-sm-4">
                    <div class="final-review__title"><spring:theme code="checkout.summary.paymentMethod.header" /></div>
                    <ul class="final-review__list">
                        <li>${fn:escapeXml(paymentInfo.accountHolderName)}</li>
                        <li>${fn:escapeXml(paymentInfo.cardNumber)}</li>
                        <li>${fn:escapeXml(paymentInfo.cardTypeData.name)}</li>
                        <li><spring:theme code="checkout.summary.paymentMethod.paymentDetails.expires" arguments="${paymentInfo.expiryMonth},${paymentInfo.expiryYear}"/></li>
                    </ul>
                    <c:if test="${requestSecurityCode}">
                     <form>
                         <div class="control-group security">
                             <label for="SecurityCode"><spring:theme code="checkout.summary.paymentMethod.securityCode"/>*</label>
                             <div class="controls">
                                <input type="text" class="text security" id="SecurityCode"/>
                                <a href="#" class="security_code_what"><spring:theme code="checkout.summary.paymentMethod.securityCode.whatIsThis"/></a>
                             </div>
                         </div>
                     </form>
                    </c:if>
                </div>

                <div class="col-xs-6 col-sm-5">
                    <c:if test="${billingAddressOk}">
                        <div class="final-review__title"><spring:theme code="checkout.summary.paymentMethod.billingAddress.header"/></div>
                        <ul class="final-review__list">
                            <li>
                                <c:if test="${not empty paymentInfo.billingAddress.title}">${fn:escapeXml(paymentInfo.billingAddress.title)}&nbsp;</c:if>
                                    ${fn:escapeXml(paymentInfo.billingAddress.firstName)}&nbsp;${fn:escapeXml(paymentInfo.billingAddress.lastName)}
                            </li>
                            <li>${fn:escapeXml(paymentInfo.billingAddress.line1)}</li>
                            <li>${fn:escapeXml(paymentInfo.billingAddress.line2)}</li>
                            <li> <c:if test="${not empty paymentInfo.billingAddress.region.name}">${fn:escapeXml(paymentInfo.billingAddress.region.name)}&nbsp;</c:if>
                                    ${fn:escapeXml(paymentInfo.billingAddress.town)}
                            </li>
                            <li>${fn:escapeXml(paymentInfo.billingAddress.postalCode)}</li>
                            <li>${fn:escapeXml(paymentInfo.billingAddress.country.name)}</li>
                        </ul>
                    </c:if>
                </div>
        </ycommerce:testId>
        <ycommerce:testId code="checkout_changePayment_element">
            <div class="col-xs-12 col-sm-3">
                <c:url value="${addPaymentMethodUrl}" var="addPaymentMethod"/>
                <a href="${addPaymentMethod}" class="secondary-button secondary-button__default secondary-button__edit"><spring:theme code="checkout.summary.edit"/></a>
            </div>
        </ycommerce:testId>
    </div>
</div>

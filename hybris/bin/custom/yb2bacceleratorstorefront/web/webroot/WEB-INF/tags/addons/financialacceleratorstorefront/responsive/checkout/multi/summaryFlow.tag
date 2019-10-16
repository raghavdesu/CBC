<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="deliveryAddress" required="true" type="de.hybris.platform.commercefacades.user.data.AddressData" %>
<%@ attribute name="deliveryMode" required="true" type="de.hybris.platform.commercefacades.order.data.DeliveryModeData" %>
<%@ attribute name="paymentInfo" required="true" type="de.hybris.platform.commercefacades.order.data.CCPaymentInfoData" %>
<%@ attribute name="requestSecurityCode" required="true" type="java.lang.Boolean" %>
<%@ attribute name="cartData" required="false" type="de.hybris.platform.commercefacades.order.data.CartData" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="multi-checkout" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout/multi" %>


<div id="checkoutContentPanel" class="final-review__body">
	<multi-checkout:summaryFlowPayment paymentInfo="${paymentInfo}" requestSecurityCode="${requestSecurityCode}"/>
</div>

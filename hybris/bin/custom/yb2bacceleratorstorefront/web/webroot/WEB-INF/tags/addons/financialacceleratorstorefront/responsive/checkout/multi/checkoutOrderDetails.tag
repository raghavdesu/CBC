<%@ attribute name="cartData" required="true" type="de.hybris.platform.commercefacades.order.data.CartData" %>
<%@ attribute name="showShipDeliveryEntries" required="false" type="java.lang.Boolean" %>
<%@ attribute name="showPickupDeliveryEntries" required="false" type="java.lang.Boolean" %>
<%@ attribute name="showTax" required="false" type="java.lang.Boolean" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="financialCart" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/cart" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>

<c:if test="${not empty cartData}">
    <div class="col-md-4">
        <div class="short-overview short-overview--right">
            <div class="short-overview__content">
                <financialCart:cartItems cartData="${cartData}" displayChangeOptionLink="true"/>
                <financialCart:cartTotals cartData="${cartData}" showTaxEstimate="${taxEstimationEnabled}"/>
            </div>
            <financialCart:cartModifyPlan cartData="${cartData}" flowStartUrl="${flowStartUrl}"/>
        </div>
    </div>
</c:if>

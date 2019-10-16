<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="user" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/user" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:url value="/login/checkout/register" var="registerAndCheckoutActionUrl" />
<user:register actionNameKey="checkout.login.registerAndCheckout" action="${fn:escapeXml(registerAndCheckoutActionUrl)}"/>

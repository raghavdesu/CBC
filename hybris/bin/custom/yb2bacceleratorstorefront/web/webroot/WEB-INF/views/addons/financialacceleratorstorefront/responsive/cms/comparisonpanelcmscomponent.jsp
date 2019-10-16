<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/product" %>
<%@ taglib prefix="financialCart" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/cart" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<spring:htmlEscape defaultHtmlEscape="true"/>
<c:choose>
    <c:when test="${fn:length(searchPageData.results) gt 0}">
        <product:productComparison columns="4" initialRowsCount="${initialRowsCount}" searchPageData="${searchPageData}"
                                   showOptionalProducts="${showOptionalProducts}" addToCartBtn_label_key="basket.add.to.basket.select"/>
        <financialCart:changePlanConfirmPopup confirmActionButtonId="addNewPlanConfirmButton" cartData="${cartData}"/>
    </c:when>
    <c:otherwise>
        <product:productComparisonError/>
    </c:otherwise>
</c:choose>



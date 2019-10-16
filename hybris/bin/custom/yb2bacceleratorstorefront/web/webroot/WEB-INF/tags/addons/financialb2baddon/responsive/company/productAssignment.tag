<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ attribute name="products" required="true" type="java.util.List" %>
<%@ attribute name="assignmentFlag" required="true" type="java.lang.Boolean" %>
<%@ attribute name="action" required="true" type="java.lang.String" %>
<%@ attribute name="createUrl" required="true" type="java.lang.String" %>
<%@ attribute name="editUrl" required="true" type="java.lang.String" %>
<%@ attribute name="role" required="true" type="java.lang.String" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<div>
    <c:choose>
        <c:when test="${assignmentFlag}">
            <c:set var="url" value="/my-company/organization-management/manage-units/products/deassign"/>
            <c:set var="id" value="assigned-products"/>
            <c:set var="containerClass" value="assigned-products-container"/>
        </c:when>
        <c:otherwise>
            <c:set var="url" value="/my-company/organization-management/manage-units/products/assign"/>
            <c:set var="id" value="not-assigned-products"/>
            <c:set var="containerClass" value="not-assigned-products-container"/>
        </c:otherwise>
    </c:choose>

    <div class="account-list-header">
        <spring:theme code="text.company.manage.units.header.${action}"/> (<span class="counter">${fn:length(products)}</span>)
    </div>

    <div class="account-cards">
        <div id="${id}" class="row ${containerClass}">
            <c:forEach items="${products}" var="product" varStatus="rows">
                <div class="col-xs-12 col-sm-6 col-md-4 card">
                    <spring:url value="${url}" var="assigningUrl" htmlEscape="false">
                        <spring:param name="product" value="${product.code}"/>
                        <spring:param name="unit" value="${unit.uid}"/>
                    </spring:url>
                    <ul id="id-${rows.index}" class="pull-left">
                        <li>
                            <a href="${fn:escapeXml(viewProductUrl)}">
                                    ${fn:escapeXml(product.name)}
                            </a>
                        </li>
                        <li>${fn:escapeXml(product.description)}</li>
                    </ul>
                    <div class="account-cards-actions pull-left">
                        <div data-url="${fn:escapeXml(assigningUrl)}" class="js-product-status" data-rowid="${rows.index}" data-productid="${fn:escapeXml(product.code)}" data-unitid="${fn:escapeXml(unit.uid)}">
                            <span class="glyphicon"></span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ attribute name="products" required="true" type="java.util.List" %>
<%@ attribute name="action" required="true" type="java.lang.String" %>
<%@ attribute name="createUrl" required="true" type="java.lang.String" %>
<%@ attribute name="editUrl" required="true" type="java.lang.String" %>
<%@ attribute name="role" required="true" type="java.lang.String" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>

<spring:htmlEscape defaultHtmlEscape="true"/>

<div class="account-list-header">
    <spring:theme code="text.company.manage.units.header.${action}"/> (<span class="counter">${fn:length(products)}</span>)

    <div class="account-list-header-add pull-right">
        <div class="hidden-xs">
            <a href="${fn:escapeXml(editUrl)}" class="button edit">
                <spring:theme code="text.company.activateProducts.button"/>
            </a>
            <c:if test="${!isUserAdminOfUnit}">
                &#124;
                <a href="${fn:escapeXml(createUrl)}&amp;role=${fn:escapeXml(ycommerce:encodeUrl(role))}" class="button create">
                    <spring:theme code="text.company.assignProducts.button"/>
                </a>
            </c:if>
        </div>

        <div class="visible-xs">
            <div class="add-user-action-menu">
                <a href="#" class="add-user-action js-add-user-action"><spring:theme
                        code="text.company.manage.unit.product.add"/></a>
                <ul class="add-user-action-buttons js-add-user-action-buttons">
                    <li><a href="${fn:escapeXml(editUrl)}">
                        <button class="btn btn-primary btn-block"><spring:theme
                                code="text.company.manage.unit.product.activate"/></button>
                    </a></li>
                    <c:if test="${!isUserAdminOfUnit}">
                        <li><a href="${fn:escapeXml(createUrl)}&amp;role=${ycommerce:encodeUrl(role)}">
                            <button class="btn btn-primary btn-block"><spring:theme
                                    code="text.company.manage.units.products.button.assign"/></button>
                        </a></li>
                    </c:if>
                </ul>
            </div>
        </div>
    </div>
</div>

<div class="account-cards">
    <div class="row">
        <c:forEach items="${products}" var="product" varStatus="rows">
            <div class="col-xs-12 col-sm-6 col-md-4 card">
                <spring:url value="/my-company/organization-management/manage-units/products/deselect" var="removeProductUrl"
                            htmlEscape="false">
                    <spring:param name="product" value="${product.code}"/>
                    <spring:param name="unit" value="${unit.uid}"/>
                </spring:url>
                <ul id="id-${rows.index}" class="pull-left">
                    <li>
                        ${fn:escapeXml(product.defaultCategory.name)}
                    </li>
                    <li>
                        ${fn:escapeXml(product.name)}
                    </li>
                    <li>
                        ${fn:escapeXml(product.description)}
                    </li>
                </ul>
                <div class="account-cards-actions pull-left">
                    <a href="#" url="${fn:escapeXml(removeProductUrl)}" class="js-remove-user-from-unit remove-item"
                       data-rowid="${rows.index}" title="<spring:theme code='text.company.manage.unit.product.remove'/>">
                        <span class="glyphicon glyphicon-remove"></span>
                    </a>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

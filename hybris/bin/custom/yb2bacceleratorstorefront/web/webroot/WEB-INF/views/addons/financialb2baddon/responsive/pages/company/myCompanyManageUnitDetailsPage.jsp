<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="org-common" tagdir="/WEB-INF/tags/addons/commerceorgaddon/responsive/common" %>
<%@ taglib prefix="company" tagdir="/WEB-INF/tags/addons/commerceorgaddon/responsive/company" %>
<%@ taglib prefix="fscompany" tagdir="/WEB-INF/tags/addons/financialb2baddon/responsive/company" %>

<spring:htmlEscape defaultHtmlEscape="true"/>

<spring:url value="/my-company/organization-management/manage-units/" var="cancelUrl" htmlEscape="false"/>

<spring:url value="/my-company/organization-management/manage-units/edit" var="editUnitUrl" htmlEscape="false">
    <spring:param name="unit" value="${unit.uid}"/>
</spring:url>
<spring:url value="/my-company/organization-management/manage-units/create" var="createUnitUrl" htmlEscape="false">
    <spring:param name="unit" value="${unit.uid}"/>
</spring:url>
<spring:url value="/my-company/organization-management/manage-units/disable" var="disableUnitUrl" htmlEscape="false">
    <spring:param name="unit" value="${unit.uid}"/>
</spring:url>
<spring:url value="/my-company/organization-management/manage-units/enable" var="enableUnitUrl" htmlEscape="false">
    <spring:param name="unit" value="${unit.uid}"/>
</spring:url>
<spring:url value="/my-company/organization-management/manage-units/products/add" var="addProductsUrl" htmlEscape="false">
    <spring:param name="unit" value="${unit.uid}"/>
</spring:url>


<template:page pageTitle="${pageTitle}">
    <div class="account-section">
        <div>
            <org-common:headline url="${cancelUrl}" labelKey="text.company.manage.units.unitDetails"/>
        </div>

        <div class="account-section-content">
            <div class="well well-lg well-tertiary">
                <div class="row">
                    <div class="col-sm-10 col-no-padding">
                        <div class="row">
                            <div class="col-sm-4">
                                <div class="item-group">
                                    <span class="item-label">
                                        <spring:theme code="text.company.unit.id"/>
                                    </span>
                                    <span class="item-value">
                                            ${fn:escapeXml(unit.uid)}
                                    </span>
                                </div>
                                <div class="item-group">
                                    <span class="item-label">
                                        <spring:theme code="text.company.unit.name"/>
                                    </span>
                                    <span class="item-value">
                                            ${fn:escapeXml(unit.name)}
                                    </span>
                                </div>
                            </div>
                            <c:if test="${not empty unit.unit.uid}">
                                <div class="col-sm-4">
                                    <div class="item-group">
                                        <span class="item-label">
                                            <spring:theme code="text.company.unit.parent"/>
                                        </span>
                                        <span class="item-value">
                                                ${fn:escapeXml(unit.unit.uid)}
                                        </span>
                                    </div>
                                </div>
                            </c:if>
                            <c:if test="${not empty unit.approvalProcessName}">
                                <div class="col-sm-4">
                                    <div class="item-group">
                                        <span class="item-label">
                                            <spring:theme code="text.company.unit.approvalProcess"/>
                                        </span>
                                        <span class="item-value">
                                                ${fn:escapeXml(unit.approvalProcessName)}
                                        </span>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                    <div class="col-sm-2">
                        <div class="item-action">
                            <a href="${fn:escapeXml(editUnitUrl)}" class="edit btn btn-block btn-primary">
                                <spring:theme code="text.company.manage.units.button.editUnit"/>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="accountActions-link">
                <c:choose>
                    <c:when test="${unit.active}">
                        <c:if test="${unit.uid != user.unit.uid}">
                        <span class="js-action-confirmation-modal disable-link">
                            <ycommerce:testId code="Unit_DisableUnit_button">
                                <a href="#"
                                   data-action-confirmation-modal-title="<spring:theme code="text.company.manage.units.button.disableUnit"/>"
                                   data-action-confirmation-modal-id="disable">
                                    <spring:theme code="text.company.manage.units.button.disableUnit"/>
                                </a>
                            </ycommerce:testId>
                        </span>
                            <fscompany:actionConfirmationModal id="disable" targetUrl="${disableUnitUrl}"
                                                             messageKey="text.company.manage.units.disableUnit.confirmation"/>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${unit.unit.active}">
                                <ycommerce:testId code="Unit_EnableUnit_button">
                                    <a href="${fn:escapeXml(enableUnitUrl)}" class="button enable-link">
                                        <spring:theme code="text.company.manage.units.button.enableUnit"/>
                                    </a>
                                </ycommerce:testId>
                            </c:when>
                            <c:otherwise>
                                <div class="pull-right">
                                    <spring:theme code="text.company.manage.units.parentUnit.disabled"/>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="account-list">

                <org-common:selectEntityHeadline url="${createUnitUrl}" labelKey="text.company.manage.units.childUnits"
                                                 count="${fn:length(unit.children)}" addNew="true"/>
                <div class="account-cards">
                    <div class="row">
                        <c:forEach items="${unit.children}" var="unit">
                            <div class="col-xs-12 col-sm-6 col-md-4 card">
                                <spring:url value="/my-company/organization-management/manage-units/details" var="unitUrl"
                                            htmlEscape="false">
                                    <spring:param name="unit" value="${unit.uid}"/>
                                </spring:url>
                                <ul class="pull-left">
                                    <li>
                                        <a href="${fn:escapeXml(unitUrl)}">${fn:escapeXml(unit.uid)}</a>
                                    </li>
                                    <li>${fn:escapeXml(unit.name)}</li>
                                </ul>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <spring:url value="/my-company/organization-management/manage-units/createuser" var="createUserUrl"
                            htmlEscape="false">
                    <spring:param name="unit" value="${unit.uid}"/>
                </spring:url>
                <spring:url value="/my-company/organization-management/manage-units/administrators" var="editAdministratorUrl"
                            htmlEscape="false">
                    <spring:param name="unit" value="${unit.uid}"/>
                    <spring:param name="role" value="b2badmingroup"/>
                </spring:url>
                <spring:url value="/my-company/organization-management/manage-units/customers" var="editCustomersUrl"
                            htmlEscape="false">
                    <spring:param name="unit" value="${unit.uid}"/>
                    <spring:param name="role" value="b2bcustomergroup"/>
                </spring:url>
                <spring:url value="/my-company/organization-management/manage-units/products" var="editProductsUrl"
                            htmlEscape="false">
                    <spring:param name="unit" value="${unit.uid}"/>
                    <spring:param name="role" value="b2badmingroup"/>
                </spring:url>

                <company:userList users="${unit.administrators}" action="administrators" role="b2badmingroup"
                                  editUrl="${editAdministratorUrl}"
                                  createUrl="${createUserUrl}"/>

                <company:userList users="${unit.customers}" action="customers" role="b2bcustomergroup"
                                  editUrl="${editCustomersUrl}"
                                  createUrl="${createUserUrl}"/>
                <fscompany:productList products="${products}" action="products" role="b2badmingroup" editUrl="${editProductsUrl}"
                                       createUrl="${addProductsUrl}"/>
            </div>
        </div>
    </div>
</template:page>

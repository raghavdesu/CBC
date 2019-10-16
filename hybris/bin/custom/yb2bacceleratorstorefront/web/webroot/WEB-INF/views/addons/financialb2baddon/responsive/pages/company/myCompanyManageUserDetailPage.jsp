<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="company" tagdir="/WEB-INF/tags/addons/commerceorgaddon/responsive/company"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="org-common" tagdir="/WEB-INF/tags/addons/commerceorgaddon/responsive/common"%>
<%@ taglib prefix="fscompany" tagdir="/WEB-INF/tags/addons/financialb2baddon/responsive/company" %>
<spring:htmlEscape defaultHtmlEscape="true" />
<spring:url value="/my-company/organization-management/manage-users/" var="backToManageUsersUrl" htmlEscape="false" />
<spring:url value="/my-company/organization-management/manage-users/edit" var="editUserUrl" htmlEscape="false">
    <spring:param name="user" value="${customerData.uid}" />
</spring:url>
<spring:url value="/my-company/organization-management/manage-users/disable" var="disableUserUrl" htmlEscape="false">
    <spring:param name="user" value="${customerData.uid}" />
</spring:url>
<spring:url value="/my-company/organization-management/manage-users/enable" var="enableUserUrl" htmlEscape="false">
    <spring:param name="user" value="${customerData.uid}" />
</spring:url>
<spring:url value="/my-company/organization-management/manage-users/resetpassword" var="resetPasswordUrl" htmlEscape="false">
    <spring:param name="user" value="${customerData.uid}" />
</spring:url>
<spring:url value="/my-company/organization-management/manage-users/approvers" var="approversUrl" htmlEscape="false">
    <spring:param name="user" value="${customerData.uid}" />
</spring:url>
<spring:url value="/my-company/organization-management/manage-units/details" var="unitDetailsUrl" htmlEscape="false">
    <spring:param name="unit" value="${customerData.unit.uid}" />
</spring:url>
<template:page pageTitle="${pageTitle}">
    <div class="account-section">
        <div>
            <org-common:headline url="${backToManageUsersUrl}" labelKey="text.company.manageUser.userDetails" />
        </div>
        <div class="account-section-content">
            <div class="well well-lg well-tertiary">
                <div class="row">
                    <div class="col-sm-10 col-no-padding">
                        <div class="row">
                            <div class="col-sm-4">
                                <div class="item-group">
                                    <span class="item-label">
                                        <spring:theme code="text.company.user.email" />
                                    </span>
                                    <span class="item-value">
                                            ${fn:escapeXml(customerData.displayUid)}
                                    </span>
                                </div>
                                <div class="item-group">
                                    <span class="item-label">
                                        <spring:theme code="text.company.manage.units.user.name" />
                                    </span>
                                    <span class="item-value">
                                        <spring:theme code="text.company.user.${customerData.titleCode}.name" />
                                        &nbsp;${fn:escapeXml(customerData.firstName)}&nbsp;${fn:escapeXml(customerData.lastName)}
                                    </span>
                                </div>
                            </div>
                            <div class="col-sm-4">
                                <c:if test="${not empty customerData.contactNumber}">
                                    <div class="item-group">
                                    <span class="item-label">
                                        <spring:theme code="text.company.unit.contactNumber" />
                                    </span>
                                    <span class="item-value">
                                            ${fn:escapeXml(customerData.contactNumber)}
                                    </span>
                                    </div>
                                </c:if>
                                <div class="item-group">
                                    <span class="item-label">
                                        <spring:theme code="text.company.user.parentBusinessUnit" />
                                    </span>
                                    <span class="item-value">
                                        <a href="${fn:escapeXml(unitDetailsUrl)}">${fn:escapeXml(customerData.unit.name)}</a>
                                    </span>
                                </div>
                            </div>
                            <div class="col-sm-4">
                                <div class="item-group">
                                <span class="item-label">
                                    <spring:theme code="text.company.manageUser.roles" />
                                </span>
                                <span class="item-value">
                                    <c:forEach items="${customerData.roles}" var="group">
                                        <spring:theme code="b2busergroup.${group}.name" /><br/>
                                    </c:forEach>
                                </span>
                                </div>
                                <div class="item-group">
                                <span class="item-label">
                                    <spring:theme code="text.company.user.userEnabledStatus" />
                                </span>
                                <span class="item-value">
                                    <c:choose>
                                        <c:when test="${customerData.active}">
                                            <spring:theme code="text.company.manage.unit.user.enable" />
                                        </c:when>
                                        <c:otherwise>
                                            <spring:theme code="text.company.manage.unit.user.disable" />
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-2">
                        <div class="item-action">
                            <a href="${fn:escapeXml(editUserUrl)}" class="button edit btn btn-block btn-primary">
                                <spring:theme code="text.company.manageUser.button.edit" />
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="accountActions-link">
                <div class="enable-link">
                    <a href="${fn:escapeXml(resetPasswordUrl)}">
                        <spring:theme code="text.company.user.resetPassword" />
                    </a>
                </div>
                <c:choose>
                    <c:when test="${customerData.active}">
                        <div class="js-action-confirmation-modal disable-link">
                            <a href="#" data-action-confirmation-modal-title="<spring:theme code="text.company.manageusers.button.disableuser"/>"
                               data-action-confirmation-modal-id="disable" class="last">
                                <spring:theme code="text.company.manageusers.button.disableuser" />
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${customerData.unit.active}">
                                <div class="enable-link">
                                    <form:form action="${enableUserUrl}">
                                        <button type="submit">
                                            <spring:theme code="text.company.manageusers.button.enableuser" />
                                        </button>
                                    </form:form>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="enable-link">
                                    <button type="button" disabled>
                                        <spring:theme code="text.company.manageusers.button.enableuser" />
                                    </button>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </div>
            <fscompany:actionConfirmationModal id="disable" targetUrl="${disableUserUrl}" messageKey="text.company.manageuser.disableuser.confirmation" messageArguments="${customerData.uid}"/>
            <div class="row">
                <div class="col-xs-12 col-sm-5 col-md-4">
                    <div class="accountActions-bottom">
                        <org-common:back cancelUrl="${backToManageUsersUrl}" displayTextMsgKey="text.company.manageUsers.back.button" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</template:page>

<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/nav" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="org-common" tagdir="/WEB-INF/tags/addons/commerceorgaddon/responsive/common" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<spring:theme code="text.company.select.action.label" var="selectAction" />
<spring:theme code="text.company.deselect.action.label" var="deselectAction"/>

<c:if test="${empty cancelUrl}">
    <spring:url value="/my-company/organization-management/manage-units/details?unit=${fn:escapeXml(param.unit)}" var="cancelUrl" htmlEscape="false"/>
</c:if>

<c:set var="searchUrl" value="${baseUrl}/${ycommerce:encodeUrl(action)}?unit=${ycommerce:encodeUrl(param.unit)}&role=${ycommerce:encodeUrl(param.role)}&sort=${ycommerce:encodeUrl(searchPageData.sorts[0].code)}"/>

<jsp:useBean id="additionalParams" class="java.util.HashMap"/>
<c:set target="${additionalParams}" property="unit" value="${param.unit}" />
<c:set target="${additionalParams}" property="role" value="${param.role}" />

<template:page pageTitle="${pageTitle}">
    <div class="account-section">
        <div class="row">
            <div class="col-xs-12 col-sm-7">
                <org-common:headline url="${cancelUrl}" labelKey="text.company.manage.units.${action}.mainTitle"/>
            </div>
            <div class="col-xs-12 col-sm-3 col-sm-push-2">
                <div class="account-header-done-btn">
                    <org-common:done url="${cancelUrl}" labelKey="text.company.done.button"/>
                </div>
            </div>
        </div>

        <div class="account-section-content ${empty searchPageData.results ? 'content-empty' : ''}">
            <nav:fsPagination top="true" showTopTotals="false" supportShowPaged="${isShowPageAllowed}"
                              supportShowAll="${isShowAllAllowed}" searchPageData="${searchPageData}"
                              hideRefineButton="true" searchUrl="${searchUrl}" msgKey="text.company.${action}.page"
                              additionalParams="${additionalParams}" numberPagesShown="${numberPagesShown}" showSortBar="true"/>

            <div id="selectProducts" class="account-list">
                <c:choose>
                    <c:when test="${not empty searchPageData.results}">
                        <div class="account-cards card-select">
                            <div class="row">
                                <c:forEach items="${searchPageData.results}" var="assignment">
                                    <spring:url value="/my-company/organization-management/manage-users/details" var="viewUrl" htmlEscape="false">
                                        <spring:param name="product" value="${assignment.product.code}"/>
                                    </spring:url>
                                    <spring:url value="${baseUrl}/products/select" var="selectUrl" htmlEscape="false">
                                        <spring:param name="unit" value="${param.unit}"/>
                                        <spring:param name="product" value="${assignment.product.code}"/>
                                    </spring:url>
                                    <spring:url value="${baseUrl}/products/deselect" var="deselectUrl" htmlEscape="false">
                                        <spring:param name="unit" value="${param.unit}"/>
                                        <spring:param name="product" value="${assignment.product.code}"/>
                                    </spring:url>
                                    <div class="col-xs-12 col-sm-6 col-md-4 card ${assignment.active ? 'selected' : ''}" id="row-${fn:escapeXml(assignment.product.code)}">
                                        <ul class="pull-left">
                                            <li>
                                                    ${fn:escapeXml(assignment.product.name)}
                                            </li>
                                            <li class="js-state">
                                                <ycommerce:testId code="status_${action}_label">
                                                    <spring:theme code="text.company.status.active.${assignment.active}"/>
                                                </ycommerce:testId>
                                            </li>
                                        </ul>
                                        <ycommerce:testId code="actions_${action}_label">
                                            <span id="selection-${fn:escapeXml(assignment.product.code)}" class="account-cards-actions pull-left">
                                                <c:choose>
                                                    <c:when test="${assignment.active}">
                                                        <a href="#" url="${fn:escapeXml(deselectUrl)}" class="action-links">
                                                            <span class="glyphicon glyphicon-ok"></span>
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                         <a href="#" url="${fn:escapeXml(selectUrl)}" class="action-links">
                                                             <span class="glyphicon glyphicon-ok"></span>
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </ycommerce:testId>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <spring:theme code="text.company.noentries"/>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="accountActions-bottom hidden-sm hidden-md hidden-lg">
            <org-common:done url="${cancelUrl}" labelKey="text.company.done.button"/>
        </div>

        <nav:fsPagination top="false" supportShowPaged="${isShowPageAllowed}" supportShowAll="${isShowAllAllowed}"
                          searchPageData="${searchPageData}"
                          hideRefineButton="true" searchUrl="${searchUrl}" msgKey="text.company.${action}.page"
                          additionalParams="${additionalParams}" numberPagesShown="${numberPagesShown}" showSortBar="true"/>
    </div>

</template:page>

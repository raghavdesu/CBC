<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true"/>

<div class="${component.itemtype}">
    <div class="comparison-table comparison-table__header">
        <c:if test="${fn:length(tabComponents) gt 1}">
            <ul class="multi-tabs js-multi-tabs">
                <c:set var="activeTabCounter" value="0"/>
                <c:forEach items="${tabComponents}" var="tabComponent" varStatus="status">
                    <c:if test="${not empty tabComponent.comparisonPanel.products}">
                        <li id="${fn:escapeXml(tabComponent.uid)}" class="multi-tabs__tab <c:if test="${activeTabCounter == '0'}">active
                            <c:set var="activeTabCounter" value="${status.count}"/></c:if> js-tab"> ${fn:escapeXml(tabComponent.title)}</li>
                    </c:if>
                </c:forEach>
            </ul>
        </c:if>
    </div>
    <div id="tab_content" class="comparison-table comparison-table__body content">
        <c:set var="initial_content" value="false"/>
        <c:forEach items="${component.simpleCMSComponents}" var="tabComponent" varStatus="status">
            <c:if test="${tabComponent.visible && initial_content != true}">
                <c:if test="${not empty activeTabCounter && status.count==activeTabCounter}">
                    <c:set var="initial_content" value="true"/>
                </c:if>
                <cms:component component="${tabComponent}" evaluateRestriction="true"/>
            </c:if>
        </c:forEach>
    </div>
</div>


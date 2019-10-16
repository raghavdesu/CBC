<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="store" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/store" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${searchPageData ne null and not empty searchPageData.results}">
    {
    "total":${searchPageData.pagination.totalNumberOfResults},
    "pageSize": ${searchPageData.pagination.pageSize},
    "data":[
    <c:forEach items="${searchPageData.results}" var="agent" varStatus="agentLoopStatus">
        <c:set var="agentName" value="${fn:escapeXml(agent.firstName)} ${fn:escapeXml(agent.lastName)}"/>
        {
        "uid" : "${fn:escapeXml(agent.uid)}",
        "name" : "${agentName}",
        "displayName" : "${fn:escapeXml(agentName)}",
        "agentimage" : "${agent.thumbnail.url}",
        <c:if test="${not empty agent.pointsOfService}">
            "pointsOfService" : [
            <c:forEach items="${agent.pointsOfService}" var="pos" varStatus="posLoopStatus">
                {
                "posName" : "${fn:escapeXml(pos.displayName)}",
                "displayName" : "${fn:escapeXml(agentName)}",
                "formattedDistance" : "${fn:escapeXml(pos.formattedDistance)}",
                "line1" : "${fn:escapeXml(pos.address.line1)}",
                "line2" : "${fn:escapeXml(pos.address.line2)}",
                "town" : "${fn:escapeXml(pos.address.town)}",
                "postalCode" : "${fn:escapeXml(pos.address.postalCode)}",
                "latitude" : "${pos.geoPoint.latitude}",
                "longitude" : "${pos.geoPoint.longitude}"
                }
                <c:if test="${!posLoopStatus.last}">,</c:if>
            </c:forEach>
            ]</c:if>,
        <c:if test="${not empty agent.categories}">
            "categories" : [
            <c:forEach items="${agent.categories}" var="category" varStatus="categoryLoopStatus">
                {
                "categoryName" : "${fn:escapeXml(category.name)}"
                }
                <c:if test="${!categoryLoopStatus.last}">,</c:if>
            </c:forEach>
            ]
        </c:if>
        }
        <c:if test="${!agentLoopStatus.last}">,</c:if>
    </c:forEach>
    ]}
</c:if>
<c:if test="${empty searchPageData.results}">
    <template:page pageTitle="${pageTitle}">
        <cms:pageSlot position="TopContent" var="feature">
            <cms:component component="${feature}"  element="div" class="top-content-slot cms_disp-img_slot"  />
        </cms:pageSlot>
        <div id="storeFinder">
			<div class="js-storefinder-alert alert alert-danger alert-dismissable inactive">
				<button class="close closeAccAlert" type="button" data-dismiss="alert" aria-hidden="true">&#215;</button><spring:theme code="agentlocator.error.no.results.subtitle" text="Please enter a valid insurance category or agent name."/>
			</div>
            <cms:pageSlot position="MiddleContent" var="feature">
                <cms:component component="${feature}"  element="div"/>
            </cms:pageSlot>
        </div>
    </template:page>
</c:if>
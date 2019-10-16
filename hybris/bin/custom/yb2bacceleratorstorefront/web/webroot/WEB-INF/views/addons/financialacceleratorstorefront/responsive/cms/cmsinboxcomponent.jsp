<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/nav" %>
<%@ taglib prefix="inbox" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/inbox" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true" />
<div id="inbox" class="inbox">
    <div class="${component.itemtype}">
        <div class="tabs js-tabs tabs-responsive hidden-xs hidden-sm">
            <ul class="clearfix tabs-list">
                <c:forEach items="${tabComponents}" var="tabComponent" varStatus="status">
                    <cms:component component="${tabComponent}" evaluateRestriction="true" element="li"
                                           id="${fn:escapeXml(tabComponent.title)}-${fn:escapeXml(tabComponent.messageGroup.code)}"
                                           group="${fn:escapeXml(tabComponent.messageGroup.code)}"/>
                </c:forEach>
            </ul>
        </div>
		<div class="row margin-t-20 margin-b-20">
			<div class="col-xs-4 col-sm-6">
				<span class="messages-state js-update-messages-state"></span>
			</div>
			<div class="col-xs-8 col-sm-6 pagination-content"></div>
		</div>
        <div id="mobile-dropdown" class="dropdown hidden-md hidden-lg">
            <label class="checkbox-label js-check-main">
                <input type="checkbox" value="true">
                <span class="checkbox-text"></span>
            </label>
            <div class="section-header__heading dropdown-toggle" data-toggle="dropdown">
            <span class="dropdown-category">
                <spring:theme code="text.account.inbox.message.list.category" text="Category"/></span>
                <span class="glyphicon glyphicon-triangle-bottom"></span>
            </div>
                <ul class="dropdown-menu clearfix">
                    <c:forEach items="${tabComponents}" var="tabComponent" varStatus="status">
                        <cms:component component="${tabComponent}" evaluateRestriction="true" element="li"
                                           group="${fn:escapeXml(tabComponent.messageGroup.code)}"/>
                    </c:forEach>
                </ul>
        </div>
        <inbox:siteMessagesTable/>
    </div>
</div>
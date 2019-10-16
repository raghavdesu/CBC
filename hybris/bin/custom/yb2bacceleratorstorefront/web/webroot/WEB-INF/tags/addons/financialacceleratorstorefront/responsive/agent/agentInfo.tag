<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ attribute name="agent" required="true" type="de.hybris.platform.financialfacades.findagent.data.AgentData"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<spring:htmlEscape defaultHtmlEscape="true"/>

<div class="agent-info agent-info__wrapper col-xs-10 col-sm-4 col-md-3">
    <div class="agent-info__image">
        <img class="agent-info__image--color-border" src="${agent.thumbnail.url}"/>
    </div>
    <div class="agent-info__description">
        <ul class="agent-info__details">
            <li class="agent-info__name">${fn:escapeXml(agent.firstName)}&nbsp;${fn:escapeXml(agent.lastName)}</li>
        </ul>
    </div>
    <div class="agent-info__button">
        <a id="contactBtn" class="secondary-button__agent glyphicon glyphicon-envelope" href="${request.contextPath}/contact-agent?agent=${fn:escapeXml(agent.uid)}&activeCategory=${fn:escapeXml(activeCategory)}"></a>
    </div>
    <div class="agent-info__button">
        <a id="locateBtn" class="primary-button__agent glyphicon glyphicon-map-marker" href="${request.contextPath}/agent-locator"></a>
    </div>
</div>

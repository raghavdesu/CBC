<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>

    <c:url value="${url}" var="linkUrl"/>
    <div ${fn:escapeXml(component.styleAttributes)}>
        <a href="${fn:escapeXml(linkUrl)}" ${target}>
            <div class="servicelinks">
                <cms:component component="${component.image}" evaluateRestriction="true"/>
            </div>${fn:escapeXml(component.linkName)}
        </a>
    </div>

<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<div class="CMSComparisonTabComponent">
    <cms:component component="${comparisonPanel}" evaluateRestriction="true"/>
</div>

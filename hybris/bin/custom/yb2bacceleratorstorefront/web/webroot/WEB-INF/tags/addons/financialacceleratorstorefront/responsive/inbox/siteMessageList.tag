<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="formatter" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/format" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<spring:htmlEscape defaultHtmlEscape="true"/>

<div class="messages">
    <c:forEach items="${searchPageData.results}" var="message">
            <div class="tr ${message.readDate == null? 'unread':'read'}">
                <div class="td1">
                    <label class="checkbox-label js-check-toggle" data-uid=${fn:escapeXml(message.uid)}>
                        <input type="checkbox" value="true">
                        <span class="checkbox-text"></span>
                    </label>
                </div>
                <div class="td2 js-msg-trigger"><span class="cell-text">${fn:escapeXml(message.title)}</span></div>
                <div class="td3 js-msg-trigger hidden-xs hidden-sm"><span class="cell-text">${fn:escapeXml(message.content)}</span></div>
                <div class="td4"><formatter:stringToDate inputValue="${fn:escapeXml(message.sentDate)}"
                                                         inputDatePattern="EEE MMM d HH:mm:ss zzz yyyy"
                                                         outputDatePattern="dd MMM yyyy"/></div>
            </div>
            <div class="message">${ycommerce:sanitizeHTML(message.richContent)}</div>
    </c:forEach>
</div>

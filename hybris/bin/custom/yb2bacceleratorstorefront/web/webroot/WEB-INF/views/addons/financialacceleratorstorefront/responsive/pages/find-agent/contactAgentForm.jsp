<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<spring:htmlEscape defaultHtmlEscape="true"/>

<template:page pageTitle="${pageTitle}">
    <div class="boxed-content-wrapper">
        <div class="col-md-12 contact-expert">
            <c:if test="${not empty param.agent}">
                <cms:pageSlot position="Section2A" var="component">
                    <c:if test="${empty thankyou}">
                      <div class="contact-expert__wrapper">
                         <c:choose>
                            <c:when test="${not empty agentData}">
                            <h2 class ="section-header__heading">
                                <img class="agent-info__image--color-border" src="${agentData.thumbnail.url}" alt=""/>
                                <span class="section-header__heading--title">
                                    <spring:theme code="text.agent.contactExpert.expert.request"
                                       arguments="${agentData.firstName} ${agentData.lastName}"
                                       argumentSeparator=";"
                                       text="Contact ${agentData.firstName} ${agentData.lastName}" />
                                </span>
                            </h2>
                            </c:when>
                            <c:otherwise>
                               <h2><spring:theme code="text.agent.contactExpert.fallback.request" text="Contact Expert" /></h2>
                            </c:otherwise>
                         </c:choose>
                      </div>
                      <cms:component component="${component}"/>
                   </c:if>
                   <c:if test="${not empty thankyou}">
                        <h2 class="contact-expert__message">
                           <spring:theme code="text.agent.contactExpert.thankyou"
                                    arguments="${agentData.firstName} ${agentData.lastName}"
                                    argumentSeparator=";" text="Thank you for your message. ${agentData.firstName} ${agentData.lastName} will reply to you shortly!"/>
                                    <br><spring:theme code="text.agent.contactExpert.redirect" /><span id="timer"></span>
                        </h2>
                   </c:if>
                </cms:pageSlot>
            </c:if>
        </div>
    </div>
</template:page>

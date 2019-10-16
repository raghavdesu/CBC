<%@ tag body-content="scriptless" trimDirectiveWhitespaces="true" %>
<%@ attribute name="pageTitle" required="false" rtexprvalue="true" %>
<%@ attribute name="pageCss" required="false" fragment="true" %>
<%@ attribute name="pageScripts" required="false" fragment="true" %>
<%@ attribute name="hideHeaderLinks" required="false" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/responsive/common" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/template" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="header" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/common/header" %>
<%@ taglib prefix="footer" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/common/footer" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true"/>

<template:master pageTitle="${pageTitle}">

	<jsp:attribute name="pageCss">
		<jsp:invoke fragment="pageCss"/>
	</jsp:attribute>

    <jsp:attribute name="pageScripts">
		<jsp:invoke fragment="pageScripts"/>
	</jsp:attribute>

    <jsp:body>
        <div class="desktop__nav">
            <div class="nav__left">
                <div class="row">
                    <div class="col-sm-2 hidden-md hidden-lg mobile-menu">
                        <button class="btn js-toggle-sm-navigation" type="button">
                            <span class="glyphicon glyphicon-menu-hamburger"></span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <div class="branding-mobile hidden-md hidden-lg">
            <div class="js-mobile-logo">
                    <%--populated by JS acc.navigation--%>
            </div>
        </div>
        <main data-currency-iso-code="${fn:escapeXml(currentCurrency.isocode)}">
            <spring:theme code="text.skipToContent" var="skipToContent" />
            <a href="#skip-to-content" class="skiptocontent" data-role="none">${skipToContent}</a>
            <spring:theme code="text.skipToNavigation" var="skipToNavigation"/>
            <a href="#skiptonavigation" class="skiptonavigation" data-role="none">${skipToNavigation}</a>


            <header:header hideHeaderLinks="${hideHeaderLinks}"/>


            <a id="skip-to-content"></a>

            <div>
                <div class="main-content-wrapper">
                    <common:globalMessages/>
                    <cart:cartRestoration/>
                    <jsp:doBody/>
                </div>
            </div>

            <footer:footer/>
        </main>

    </jsp:body>

</template:master>

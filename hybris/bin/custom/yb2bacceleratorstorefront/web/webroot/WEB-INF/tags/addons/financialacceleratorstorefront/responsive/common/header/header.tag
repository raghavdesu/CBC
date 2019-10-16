<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="hideHeaderLinks" required="false" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav"%>
<%@ taglib prefix="languageCurrency" tagdir="/WEB-INF/tags/responsive/common/footer"%>
<spring:htmlEscape defaultHtmlEscape="true"/>

<cms:pageSlot position="TopHeaderSlot" var="component" element="div" class="container">
    <cms:component component="${component}"/>
</cms:pageSlot>

<header class="js-mainHeader">
	<nav class="navigation navigation--top hidden-xs hidden-sm" data-category="${fn:escapeXml(categoryCode)}">
		<div class="row">
			<div class="col-sm-12 col-md-4">
				<div class="nav__left js-site-logo">
					<cms:pageSlot position="SiteLogo" var="logo" limit="1">
						<cms:component component="${logo}" element="div" class="yComponentWrapper"/>
					</cms:pageSlot>
				</div>
			</div>
			<div class="col-sm-12 col-md-8">
				<div class="nav__right">
					<ul class="nav__links nav__links--account js-nav-links">
						<c:if test="${empty hideHeaderLinks}">
							<c:if test="${uiExperienceOverride}">
								<li class="backToMobileLink"><c:url
										value="/_s/ui-experience?level=" var="backToMobileStoreUrl" />
									<a href="${backToMobileStoreUrl}"> <spring:theme
											code="text.backToMobileStore" />
									</a>
								</li>
							</c:if>
                            <sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
                                <c:set var="maxNumberChars" value="25"/>
                                <c:if test="${fn:length(user.firstName) gt maxNumberChars}">
                                    <c:set target="${user}" property="firstName"
                                           value="${fn:substring(user.firstName, 0, maxNumberChars)}..."/>
                                </c:if>

								<li class="logged_in js-logged_in">
									<span class="glyphicon glyphicon-user myAcctUserIcon visible-md-inline-block visible-lg-inline-block"></span>
									<ycommerce:testId code="header_LoggedUser">
										<spring:theme code="header.welcome" arguments="${user.firstName},${user.lastName}"/>
									</ycommerce:testId>
								</li>
							</sec:authorize>

							 <cms:pageSlot position="HeaderLinks" var="link">
								 <cms:component component="${link}" element="li" />
							 </cms:pageSlot>
						</c:if>
					</ul>
					<ul id="langCurrSwticher" class="language-currency row">
						<%-- Language/Currency selectors for widescreen view --%>
						<li class="language dropdown-header js-language">
							<languageCurrency:languageSelector languages="${languages}" currentLanguage="${currentLanguage}" />
						</li>
						<li class="currency dropdown-header js-currency">
							<%-- Currency selector placeholder --%>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</nav>
	<div class="search-wrapper">
		<div class="site-search">
			<cms:pageSlot position="SearchBox" var="component">
				<cms:component component="${component}" />
			</cms:pageSlot>
		</div>
		<button class="inverted__search-button inverted__default js-btn-search js-btn-search">
			<span class="glyphicon glyphicon-search"></span>
		</button>
	</div>
	<%-- a hook for the my account links in desktop/wide desktop--%>
	<div class="hidden-xs hidden-sm js-secondaryNavAccount collapse" id="accNavComponentDesktopOne">
		<ul class="nav__links">

        </ul>
    </div>
    <div class="hidden-xs hidden-sm js-secondaryNavCompany collapse" id="accNavComponentDesktopTwo">
        <ul class="nav__links js-nav__links">

        </ul>
    </div>
    <a id="skiptonavigation"></a>
    <nav:topNavigation/>
</header>


<cms:pageSlot position="BottomHeaderSlot" var="component" element="div" class="container-fluid">
    <cms:component component="${component}"/>
</cms:pageSlot>

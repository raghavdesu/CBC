<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/nav" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/product" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true"/>

<div class="product__list--wrapper">
    <div class="col-xs-12 product__list--heading">
        <h2 class="service-heading">
            <spring:theme code="search.page.searchText"/>&nbsp;<span><c:out value="${searchPageData.freeTextSearch}" escapeXml="false"/></span>
        </h2>
    </div>

    <nav:searchSpellingSuggestion spellingSuggestion="${searchPageData.spellingSuggestion}" />

    <nav:pagination top="true"  supportShowPaged="${isShowPageAllowed}" supportShowAll="${isShowAllAllowed}" searchPageData="${searchPageData}" searchUrl="${fn:escapeXml(searchPageData.currentQuery.url)}"  numberPagesShown="${numberPagesShown}"/>
    <ul class="product__listing product__list">
            <c:forEach items="${searchPageData.results}" var="product">
                <product:productListerItem product="${product}"/>
            </c:forEach>
    </ul>

    <div id="addToCartTitle" class="display-none">
        <div class="add-to-cart-header">
            <div class="headline">
                <span class="headline-text"><spring:theme code="basket.added.to.basket"/></span>
            </div>
        </div>
    </div>

    </div>

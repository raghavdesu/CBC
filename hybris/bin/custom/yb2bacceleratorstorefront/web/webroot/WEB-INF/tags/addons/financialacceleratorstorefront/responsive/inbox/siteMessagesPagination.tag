<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/nav" %>
<div id="paginationFragment">
    <nav:fsPagination top="true" showTopTotals="false" supportShowPaged="${isShowPageAllowed}"
                      supportShowAll="${isShowAllAllowed}" searchPageData="${searchPageData}"
                      hideRefineButton="true" searchUrl="${searchUrl}" additionalParams="${additionalParams}"
                      numberPagesShown="${numberPagesShown}" showSortBar="false"/>
</div>
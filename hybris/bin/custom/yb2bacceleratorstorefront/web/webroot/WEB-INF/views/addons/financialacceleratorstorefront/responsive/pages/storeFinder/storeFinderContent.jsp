<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="store" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/store" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<store:storeSearch errorNoResults="${errorNoResults}"/>
<store:storeListForm searchPageData="${searchPageData}" agentQuery="${agentQuery}" numberPagesShown="${numberPagesShown}" geoPoint="${geoPoint}"/>

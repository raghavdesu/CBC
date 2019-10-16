<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>

<div class="chooseProduct quote">
    <ul>
        <c:forEach items="${linkImages}" var="linkImage">
            <li class="col-xs-6 col-sm-4 col-md-2">
                <cms:component component="${linkImage}" evaluateRestriction="true"/>
            </li>
        </c:forEach>
    </ul>
</div>
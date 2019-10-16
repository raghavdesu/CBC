<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ attribute name="insuredObjects" required="true" type="java.util.List<de.hybris.platform.commercefacades.insurance.data.InsuredObjectData>"%>
<%@ attribute name="insuredObjectType" required="true" type="java.lang.String"%>

<ul class="accordion-item__list accordion-item__list--enhanced margin-t-20">
    <c:forEach items="${insuredObjects}" var="insuredObjectItem">
        <li class="accordion-item__list-item ">
            <div class="col-xs-6 col-sm-3 accordion-item__title bold">
                <spring:theme code="policy.details.${insuredObjectType}.${insuredObjectItem.label}"/>
            </div>
            <div class="col-xs-6 col-sm-3 accordion-item__value notice notice--dark">
                    ${fn:escapeXml(insuredObjectItem.value)}
            </div>
            <div class="col-xs-12 col-sm-6"></div>
        </li>
    </c:forEach>
</ul>

<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<div class="listed-infos">
    <c:choose>
        <c:when test="${param.viewStatus == 'view'}">
            <ul class="listed-infos__details">
                <li>
                    <label class="listed-infos__details--right-margin"><spring:theme code="text.insurance.savings.contribution.frequency" text="Contribution Frequency:"/></label>${sessionScope.savings.contributionFrequency}
                </li>
                <li>
                    <label class="listed-infos__details--right-margin"><spring:theme code="text.insurance.savings.contribution" text="Contribution:"/></label>${sessionScope.savings.contribution}
                </li>
            </ul>
            <ul class="listed-infos__details">
                <li>
                    <label class="listed-infos__details--right-margin"><spring:theme code="text.insurance.savings.annual.contribution.increase" text="Annual Contribution Increase:"/></label>${sessionScope.savings.annualContributionIncrease}&#37;
                </li>
                <li>
                    <label class="listed-infos__details--right-margin"><spring:theme code="text.insurance.savings.start.date" text="Start Date:"/></label>${sessionScope.savings.startDate}
                </li>
            </ul>
            <ycommerce:testId code="multicheckout_cancel_button">
                <a id="backBtn" class="secondary-button secondary-button__default secondary-button__infos" href="?viewStatus=edit">
                    <spring:theme code="text.cmsformsubmitcomponent.edit" text="Edit"/>
                </a>
            </ycommerce:testId>
        </c:when>
        <c:otherwise>
            <ycommerce:testId code="multicheckout_saveForm_button">
                <a id="continueBtn" class="primary-button primary-button__default primary-button__infos pull-right" href="?viewStatus=view">
                    <spring:theme code="text.cmsformsubmitcomponent.find.prices" text="Find Prices"/>
                </a>
            </ycommerce:testId>
        </c:otherwise>
    </c:choose>
</div>

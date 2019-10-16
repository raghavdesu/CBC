<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="formatter" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/format" %>
<spring:htmlEscape defaultHtmlEscape="true"/>

<h2 class="heading-headline">
    <spring:theme code="text.account.premiumCalendar" text="Premium Calendar"/>
</h2>
<c:choose>
    <c:when test="${empty policies}">
        <p>
            <spring:theme code="text.account.premiumCalendar.noPremiums" text="You have no premiums awaiting payment"/>
        </p>
    </c:when>
    <c:otherwise>
        <div class="premium-grid js-premium-grid">
            <div class="hidden-sm hidden-xs">
                <div class="section-header section-header__heading">
                    <h3 class="width-20 section-header__heading--small-title">
                        <spring:theme code="text.account.premiumCalendar.policy" text="Policy"/>
                    </h3>
                    <h3 class="width-20 section-header__heading--small-title">
                        <spring:theme code="text.account.premiumCalendar.paymentFrequency" text="Payment Frequency"/>
                    </h3>
                    <h3 class="width-20 section-header__heading--small-title">
                        <spring:theme code="text.account.premiumCalendar.dueDate" text="Due Date"/>
                    </h3>
                    <h3 class="width-20 section-header__heading--small-title">
                        <spring:theme code="text.account.premiumCalendar.premium" text="Premium"/>
                    </h3>
                    <h3 class="width-20 section-header__heading--small-title">
                        <spring:theme code="text.account.premiumCalendar.paymentMethod" text="Payment Method"/>
                    </h3>
                    <span class="clearfix"></span>
                </div>
                <c:forEach items="${policies}" var="policy">
                    <c:if test="${not empty policy.billingData}">
                        <div class="section-row section-row--grey <c:if test="${fn:length(policy.billingData) gt 1}"> collapse js-collapse</c:if>">
                            <div class="section-cell width-20">
                                <div class="row">
                                    <div class="col-md-4">
                                         <span class="images images__wrapper">
                                            <img class="images images__size" src="${policy.mainProduct.coverageProduct.images[0].url}"
                                                 data-alt-text="${policy.mainProduct.coverageProduct.images[0].altText}" alt=""/>
                                        </span>
                                    </div>
                                    <div class="col-md-8">
                                        <div> ${fn:escapeXml(policy.categoryData.name)} </div>
                                        <div> ${fn:escapeXml(policy.policyNumber)} </div>
                                    </div>
                                </div>
                            </div>
                            <div class="section-cell width-20">
                                <p><spring:theme code="text.policy.premiumCalendar.${policy.paymentFrequency}" text="${policy.paymentFrequency}"/></p>
                            </div>
                            <c:choose>
                                <c:when test="${policy.billingData[0].paymentStatus == 'Overdue'}">
                                    <div class="section-cell width-20 warn">
                                        <c:if test="${not empty policy.billingData}">
                                            ${policy.billingData[0].billingDate} <br> <spring:theme
                                                code="text.account.premiumCalendar.overdue" text="Overdue"/>
                                        </c:if>
                                    </div>
                                    <div class="section-cell width-20 warn">
                                            ${policy.billingData[0].paymentAmount}
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="section-cell width-20 <c:if test="${not empty policy.billingData[0].paymentStatus }">notice</c:if>">
                                        <p>
                                            <c:if test="${not empty policy.billingData}">
                                                <formatter:stringToDate
                                                        inputValue="${policy.billingData[0].billingDate}"
                                                        inputDatePattern="dd-MM-yyyy" outputDatePattern="dd MMM yyyy"/>
                                            </c:if>
                                        </p>
                                    </div>
                                    <div class="section-cell width-20 <c:if test="${not empty policy.billingData[0].paymentStatus }">notice</c:if>">
                                        <p> ${policy.billingData[0].paymentAmount}</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <div class="section-cell width-20">
                                <c:choose>
                                    <c:when test="${not empty policy.paymentMethod}">
                                        <c:if test="${policy.paymentMethod.cardCardType ne null && policy.paymentMethod.cardAccountNumber ne null}">
                                            <p>${fn:toUpperCase(policy.paymentMethod.cardCardType)} ${fn:escapeXml(fn:toUpperCase(policy.paymentMethod.cardAccountNumber))}</p>
                                        </c:if>
                                        <c:if test="${policy.paymentMethod.bank ne null && policy.paymentMethod.paymentOption ne null}">
                                            <p>${fn:escapeXml(fn:toUpperCase(policy.paymentMethod.bank))}<span>&#47;</span>
                                                <spring:theme code="policy.payment.method.${policy.paymentMethod.paymentOption}"/></p>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <p><spring:theme code="text.not.available" text="N/A"/></p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <c:if test="${fn:length(policy.billingData) gt 1}">
                                <ul class="list-data list-data--closed js-accordion">
                                    <c:forEach items="${policy.billingData}" var="premium" begin="1">
                                        <li class="list-data__list-item border-top-grey">
                                            <div class="width-20"></div>
                                            <div class="width-20"></div>
                                            <div class="width-20">
                                                <span class="list-data__info"><formatter:stringToDate
                                                        inputValue="${premium.billingDate}"
                                                        inputDatePattern="dd-MM-yyyy" outputDatePattern="dd MMM yyyy"/></span>
                                            </div>
                                            <div class="width-20">
                                                <span class="list-data__info" >${premium.paymentAmount}</span>
                                            </div>
                                            <div class="width-20"></div>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:if>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
            <c:forEach items="${policies}" var="policy">
                <div class="col-sm-6 col-md-4 hidden-md hidden-lg">
                    <div class="cards__wrapper">
                        <div class="cards__title cards__title--gradient-background">
                            <span class="images images__wrapper images__wrapper--white-bck">
                                <img class="images images__size" src="${policy.mainProduct.coverageProduct.images[0].url}"
                                     data-alt-text="${policy.mainProduct.coverageProduct.images[0].altText}" alt=""/>
                            </span>
                            <h4 class="cards__caption cards__caption--color-white">
                                    ${fn:escapeXml(policy.categoryData.name)}
                            </h4>
                            <div class="cards__info cards__info--color-white">
                                    ${fn:escapeXml(policy.policyNumber)}
                            </div>
                        </div>
                        <div class="cards__details-wrapper cards__details-wrapper--grey">
                            <div class="cards__data border-bottom-grey">
                                <span class="title">
                                    <spring:theme code="text.account.premiumCalendar.paymentFrequency" text="Payment Frequency"/>
                                </span>
                                <span class="value">
                                    <spring:theme code="text.policy.premiumCalendar.${policy.paymentFrequency}" text="${policy.paymentFrequency}"/>
                                </span>
                            </div>
                            <div class="cards__data border-bottom-grey <c:if test="${fn:length(policy.billingData) gt 1}">js-collapse arrow</c:if> ">
                                <div class="row">
                                    <c:choose>
                                        <c:when test="${policy.billingData[0].paymentStatus == 'Overdue'}">
                                            <div class="col-xs-5">
                                                <div class="title">
                                                    <p class="cell-text"><spring:theme code="text.account.premiumCalendar.dueDate" text="Due Date"/></p>
                                                </div>
                                                <div class="title warn">
                                                    <c:if test="${not empty policy.billingData}">
                                                        ${policy.billingData[0].billingDate} <br> <spring:theme
                                                            code="text.account.premiumCalendar.overdue" text="Overdue"/>
                                                    </c:if>
                                                </div>
                                            </div>
                                            <div class="col-xs-5">
                                                <div class="title">
                                                    <p class="cell-text"><spring:theme code="text.account.premiumCalendar.premium" text="Premium"/></p>
                                                </div>
                                                <div class="title warn">
                                                        ${policy.billingData[0].paymentAmount}                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="col-xs-6 text-left padding-l-35">
                                                <div class="title">
                                                    <p class="cell-text"><spring:theme code="text.account.premiumCalendar.dueDate" text="Due Date"/></p>
                                                </div>
                                                <div class="title notice">
                                                    <c:if test="${not empty policy.billingData}">
                                                        <formatter:stringToDate
                                                                inputValue="${policy.billingData[0].billingDate}"
                                                                inputDatePattern="dd-MM-yyyy" outputDatePattern="dd MMM yyyy"/>
                                                    </c:if>
                                                </div>
                                            </div>
                                            <div class="col-xs-6 text-left padding-l-35">
                                                <div class="title">
                                                    <p class="cell-text"><spring:theme code="text.account.premiumCalendar.premium" text="Premium"/></p>
                                                </div>
                                                <div class="title notice">
                                                        ${policy.billingData[0].paymentAmount}                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <c:if test="${fn:length(policy.billingData) gt 1}">
                                <ul class="list-data list-data--closed <c:if test="${fn:length(policy.billingData) gt 1}">js-accordion collapse</c:if>">
                                    <c:forEach items="${policy.billingData}" var="premium" begin="1">
                                        <li class="list-data__list-item border-bottom-grey">
                                            <div class="row">
                                                <div class="col-xs-6 text-left padding-l-35"><formatter:stringToDate
                                                        inputValue="${premium.billingDate}"
                                                        inputDatePattern="dd-MM-yyyy" outputDatePattern="dd MMM yyyy"/></div>
                                                <div class="col-xs-6 text-left padding-l-35">${policy.billingData[0].paymentAmount}</div>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:if>
                            <div class="cards__data">
                                <span class="title">
                                    <spring:theme code="text.account.premiumCalendar.paymentMethod" text="Payment Method"/>
                                </span>
                                <c:choose>
                                    <c:when test="${not empty policy.paymentMethod}">
                                        <c:if test="${policy.paymentMethod.cardCardType ne null && policy.paymentMethod.cardAccountNumber ne null}">
                                    <span class="value">
                                    ${fn:toUpperCase(policy.paymentMethod.cardCardType)} ${fn:escapeXml(fn:toUpperCase(policy.paymentMethod.cardAccountNumber))}
                                    </span>
                                        </c:if>
                                        <c:if test="${policy.paymentMethod.bank ne null && policy.paymentMethod.paymentOption ne null}">
                                    <span class="value">
                                    ${fn:escapeXml(fn:toUpperCase(policy.paymentMethod.bank))}<span>&#47;</span>
                                        <spring:theme code="policy.payment.method.${policy.paymentMethod.paymentOption}"/>
                                    </span>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="value">
                                            <spring:theme code="text.not.available" text="N/A"/>
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>

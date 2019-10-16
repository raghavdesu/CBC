<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="orderData" required="false" type="de.hybris.platform.commercefacades.order.data.OrderData" %>
<%@ attribute name="isValidStep" required="false" type="java.lang.Boolean" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="quote" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/checkout/multi/quote" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<spring:htmlEscape defaultHtmlEscape="true" />

    <c:set value="${orderData}" var="masterEntry"/>

    <h2 class="accordion-item__heading accordion-item--valid js-toggle active">
        <spring:theme code="checkout.orderConfirmation.details.information.${masterEntry.insuranceQuote.quoteType}" />
        <span class="accordion-item__open" data-open="policyCoverageLevel"></span>
    </h2>

    <div id="policyCoverageLevel" class="accordion-item__body opened">
        <div class="col-md-9 col-sm-9 col-xs-12">
            <ul class="accordion-item__list">
                <c:if test="${not empty masterEntry.insuranceQuote.tripDestination}">
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6">
                                <spring:theme code="checkout.multi.quoteReview.travel.destination" text="Destination"/>
                            </div>
                            <div class="col-xs-6">${masterEntry.insuranceQuote.tripDestination}</div>
                        </div>
                    </li>
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6">
                                <spring:theme code="checkout.multi.quoteReview.travel.depart" text="Depart"/>
                            </div>
                            <div class="col-xs-6">${masterEntry.insuranceQuote.tripStartDate}</div>
                        </div>
                    </li>
					<c:if test="${not empty masterEntry.insuranceQuote.tripEndDate}">
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6">
                                <spring:theme code="checkout.multi.quoteReview.travel.return" text="Return"/>
                            </div>
                            <div class="col-xs-6">${masterEntry.insuranceQuote.tripEndDate}</div>
                        </div>
                    </li>
                    </c:if>
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6">
                                <spring:theme code="checkout.multi.quoteReview.travel.nooftravellers" text="No. of Travellers"/>
                            </div>
                            <div class="col-xs-6">${masterEntry.insuranceQuote.tripNoOfTravellers}</div>
                        </div>
                    </li>
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6">
                                <spring:theme code="checkout.multi.quoteReview.travel.age" text="Age of Travellers"/>
                            </div>
                            <div class="col-xs-6">
                                <c:forEach items="${masterEntry.insuranceQuote.tripTravellersAge}" var="travellerAge"
                                           varStatus="status">
                                    ${travellerAge}${not status.last ? ',' : ''}
                                </c:forEach>
                            </div>
                        </div>
                    </li>
                </c:if>
                <c:if test="${not empty masterEntry.insuranceQuote.propertyAddressLine1}">
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6">
                                <spring:theme code="checkout.multi.quoteReview.property.property.address" text="Property:"/>
                            </div>
                            <div class="col-xs-6">${masterEntry.insuranceQuote.propertyAddressLine1}</div>
                        </div>
                    </li>
                </c:if>
                <c:if test="${not empty masterEntry.insuranceQuote.propertyCoverRequired}">
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6">
                                <spring:theme code="checkout.multi.quoteReview.property.property.cover.required" text="Cover Required:"/>
                            </div>
                            <div class="col-xs-6"><spring:theme code="checkout.multi.quoteReview.property.property.cover.required.${masterEntry.insuranceQuote.propertyCoverRequired}" text="Cover Required"/></div>
                        </div>
                    </li>
                </c:if>
                <c:if test="${not empty masterEntry.insuranceQuote.propertyStartDate}">
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6">
                                <spring:theme code="checkout.multi.quoteReview.property.property.start.date" text="Start Date:"/>
                            </div>
                            <div class="col-xs-6">${masterEntry.insuranceQuote.propertyStartDate}</div>
                        </div>
                    </li>
                </c:if>
                <c:if test="${not empty masterEntry.insuranceQuote.propertyType}">
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6">
                                <spring:theme code="checkout.multi.quoteReview.property.property.type" text="Property Type:"/>
                            </div>
                            <div class="col-xs-6"><spring:theme code="checkout.multi.quoteReview.property.property.type.${masterEntry.insuranceQuote.propertyType}" text="Property Type" /></div>
                        </div>
                    </li>
                </c:if>
                <c:if test="${not empty masterEntry.insuranceQuote.propertyValue}">
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6">
                                <spring:theme code="checkout.multi.quoteReview.property.property.value" text="Property Value:"/>
                            </div>
                            <div class="col-xs-6">${masterEntry.insuranceQuote.propertyValue}</div>
                        </div>
                    </li>
                </c:if>
                <c:if test="${not empty masterEntry.insuranceQuote.autoDetail.autoMake}">
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6">
                                <spring:theme code="checkout.multi.quoteReview.auto.vehicle.make" text="Vehicle Make: "/>
                            </div>
                            <div class="col-xs-6">${masterEntry.insuranceQuote.autoDetail.autoMake}</div>
                        </div>
                    </li>
                </c:if>
                <c:if test="${not empty masterEntry.insuranceQuote.autoDetail.autoModel}">
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6">
                                <spring:theme code="checkout.multi.quoteReview.auto.vehicle.model" text="Vehicle Model: "/>
                            </div>
                            <div class="col-xs-6">${masterEntry.insuranceQuote.autoDetail.autoModel}</div>
                        </div>
                    </li>
                </c:if>
                <c:if test="${not empty masterEntry.insuranceQuote.autoDetail.autoType}">
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6">
                                <spring:theme code="checkout.multi.quoteReview.auto.vehicle.type" text="Vehicle Type: "/>
                            </div>
                            <div class="col-xs-6">${masterEntry.insuranceQuote.autoDetail.autoType}</div>
                        </div>
                    </li>
                </c:if>
                <c:if test="${not empty masterEntry.insuranceQuote.autoDetail.autoYear}">
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6">
                                <spring:theme code="checkout.multi.quoteReview.auto.vehicle.year" text="Vehicle Year: "/>
                            </div>
                            <div class="col-xs-6">${masterEntry.insuranceQuote.autoDetail.autoYear}</div>
                        </div>
                    </li>
                </c:if>
                <c:if test="${not empty masterEntry.insuranceQuote.autoDetail.autoLicense}">
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6">
                                <spring:theme code="checkout.multi.quoteReview.auto.vehicle.license" text="Vehicle License: "/>
                            </div>
                            <div class="col-xs-6">${masterEntry.insuranceQuote.autoDetail.autoLicense}</div>
                        </div>
                    </li>
                </c:if>
                <c:if test="${not empty masterEntry.insuranceQuote.autoDetail.autoPrice}">
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6">
                                <spring:theme code="checkout.multi.quoteReview.auto.vehicle.value" text="Vehicle Value: "/>
                            </div>
                            <div class="col-xs-6">${masterEntry.insuranceQuote.autoDetail.autoPrice}</div>
                        </div>
                    </li>
                </c:if>
                <c:if test="${not empty masterEntry.insuranceQuote.savingsDetail.contributionFrequency}">
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6"><spring:theme code="checkout.multi.quoteReview.savings.contribution.frequency" text="Contribution Frequency: "/></div>
                            <div class="col-xs-6">${masterEntry.insuranceQuote.savingsDetail.contributionFrequency}</div>
                        </div>
                    </li>
                </c:if>
                <c:if test="${not empty masterEntry.insuranceQuote.savingsDetail.contribution}">
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6"><spring:theme code="checkout.multi.quoteReview.savings.contribution" text="Contribution: "/></div>
                            <div class="col-xs-6">${masterEntry.insuranceQuote.savingsDetail.contribution}</div>
                        </div>
                    </li>
                </c:if>
                <c:if test="${not empty masterEntry.insuranceQuote.savingsDetail.annualContributionIncrease}">
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6"><spring:theme code="checkout.multi.quoteReview.savings.contribution.annual.increase" text="Annual Contribution Increase: "/></div>
                            <div class="col-xs-6">${masterEntry.insuranceQuote.savingsDetail.annualContributionIncrease}&#37;</div>
                        </div>
                    </li>
                </c:if>
                <c:if test="${not empty masterEntry.insuranceQuote.savingsDetail.startDate}">
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6"><spring:theme code="checkout.multi.quoteReview.savings.start.date" text="Start Date: "/></div>
                            <div class="col-xs-6">${masterEntry.insuranceQuote.savingsDetail.startDate}</div>
                        </div>
                    </li>
                </c:if>
                <c:if test="${not empty masterEntry.insuranceQuote.savingsDetail.retirementAge}">
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6"><spring:theme code="checkout.multi.quoteReview.savings.retirement.age" text="Retirement Age: "/></div>
                            <div class="col-xs-6">${masterEntry.insuranceQuote.savingsDetail.retirementAge}</div>
                        </div>
                    </li>
                </c:if>
                <c:if test="${not empty masterEntry.insuranceQuote.savingsDetail.dateOfBirth}">
                    <li class="accordion-item__list-item">
                        <div class="row">
                            <div class="col-xs-6"><spring:theme code="checkout.multi.quoteReview.savings.dateOfBirth" text="Date of Birth: "/></div>
                            <div class="col-xs-6">${masterEntry.insuranceQuote.savingsDetail.dateOfBirth}</div>
                        </div>
                    </li>
                </c:if>
                <c:if test="${masterEntry.insuranceQuote.quoteType eq 'LIFE'}">
                    <quote:quotePlanInfoLifeInsuranceSection quoteData="${masterEntry.insuranceQuote}"/> 
                </c:if>
            </ul>
        </div>
    </div>

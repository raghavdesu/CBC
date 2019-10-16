<%@ attribute name="detailData" required="true" type="de.hybris.platform.commercefacades.insurance.data.PolicyHolderDetailData" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="isValidStep" required="false" type="java.lang.Boolean" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="formatter" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/format" %>
<spring:htmlEscape defaultHtmlEscape="true" />


<c:if test="${not empty detailData}">
    <ul class="accordion-item__list">
        <li class="accordion-item__list-item">
            <c:if test="${not empty detailData.title}">${fn:escapeXml(detailData.title)} </c:if>${fn:escapeXml(detailData.firstName)} ${fn:escapeXml(detailData.lastName)}
        </li>
        <c:if test="${not empty detailData.maritalStatus}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.maritalStatus"/> :
                <formatter:propertyValueFormatter valueKeyPrefix="checkout.multi.quoteReview.details.policy.holder.maritalStatus" rawValue="${detailData.maritalStatus}"/>
            </li>
        </c:if>
        <c:if test="${not empty detailData.propertyCorrespondenceAddress }">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.property.correspondance.address"/> : ${fn:escapeXml(detailData.propertyCorrespondenceAddress)}</li>
        </c:if>
        <c:if test="${not empty detailData.phoneNumber}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.phoneNumber"/>: ${fn:escapeXml(detailData.phoneNumber)}</li>
        </c:if>
        <c:if test="${not empty detailData.emailAddress}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.emailAddress"/>: ${fn:escapeXml(detailData.emailAddress)}</li>
        </c:if>
        <c:if test="${empty detailData.propertyCorrespondenceAddress or detailData.propertyCorrespondenceAddress eq 'no' }">
            <c:if test="${not empty detailData.addressLine1}">
                <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.addressLine1"/>: ${fn:escapeXml(detailData.addressLine1)}</li>
            </c:if>
            <c:if test="${not empty detailData.addressLine2}">
                <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.addressLine2"/>: ${fn:escapeXml(detailData.addressLine2)}</li>
            </c:if>
            <c:if test="${not empty detailData.addressCity}">
                <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.addressCity"/>: ${fn:escapeXml(detailData.addressCity)}</li>
            </c:if>
            <c:if test="${not empty detailData.postcode}">
                <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.postcode"/>: ${fn:escapeXml(detailData.postcode)}</li>
            </c:if>
            <c:if test="${not empty detailData.addressCountry}">
                <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.addressCountry"/>: ${fn:escapeXml(detailData.addressCountry)}</li>
            </c:if>
        </c:if>
        <c:if test="${not empty detailData.dateOfBirth}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.dateOfBirth"/> :
                <formatter:propertyValueFormatter targetFormatKey="checkout.text.configuration.format.date" rawValue="${detailData.dateOfBirth}"/>
            </li>
        </c:if>
        <c:if test="${not empty detailData.partnerName}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.partnerName"/>: ${fn:escapeXml(detailData.partnerName)}</li>
        </c:if>
        <c:if test="${not empty detailData.partnerDateOfBirth}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.partnerDateOfBirth"/> :
                <formatter:propertyValueFormatter targetFormatKey="checkout.text.configuration.format.date" rawValue="${detailData.partnerDateOfBirth}"/>
            </li>
        </c:if>
        <c:if test="${not empty detailData.numberOfChildren}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.numberOfChildren"/>: ${fn:escapeXml(detailData.numberOfChildren)}</li>
        </c:if>
        <c:if test="${not empty detailData.numberOfFinancialDependants}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.numberOfFinancialDependants"/> : ${fn:escapeXml(detailData.numberOfFinancialDependants)}</li>
        </c:if>
        <c:if test="${not empty detailData.isResidentOfBanksCountry}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.isResidentOfBanksCountry"/> : <spring:theme code="checkout.multi.quoteReview.boolean.${detailData.isResidentOfBanksCountry}"/></li>
        </c:if>
        <c:if test="${not empty detailData.isUsCitizen}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.isUsCitizen"/> : <spring:theme code="checkout.multi.quoteReview.boolean.${detailData.isUsCitizen}"/></li>
        </c:if>
        <c:if test="${not empty detailData.sameLocationAsMainApplicant}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.sameLocationAsMainApplicant"/> : <spring:theme code="checkout.multi.quoteReview.boolean.${detailData.sameLocationAsMainApplicant}"/></li>
        </c:if>
        <c:if test="${not empty detailData.residentialStatus}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.residentialStatus"/> :
                <formatter:propertyValueFormatter valueKeyPrefix="checkout.multi.quoteReview.details.policy.holder.residentialStatus" rawValue="${detailData.residentialStatus}"/>
            </li>
        </c:if>
        <c:if test="${not empty detailData.residentialAddress}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.residentialAddress"/> : ${fn:escapeXml(detailData.residentialAddress)}</li>
        </c:if>
        <c:if test="${not empty detailData.movingInDateToResidentialAddress}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.movingInDateToResidentialAddress"/> :
                <formatter:propertyValueFormatter targetFormatKey="checkout.text.configuration.format.date" rawValue="${detailData.movingInDateToResidentialAddress}"/>
            </li>
        </c:if>
        <c:if test="${not empty detailData.isPostalSameAsResidential}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.isPostalSameAsResidential"/> : <spring:theme code="checkout.multi.quoteReview.boolean.${detailData.isPostalSameAsResidential}"/></li>
        </c:if>
        <c:if test="${not empty detailData.postalAddress}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.postalAddress"/> : ${fn:escapeXml(detailData.postalAddress)}</li>
        </c:if>
        <c:if test="${not empty detailData.employmentStatus}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.employmentStatus"/> :
                <formatter:propertyValueFormatter valueKeyPrefix="checkout.multi.quoteReview.details.policy.holder.employmentStatus" rawValue="${detailData.employmentStatus}"/>
            </li>
        </c:if>
        <c:if test="${not empty detailData.employersName}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.employersName"/> : ${fn:escapeXml(detailData.employersName)}</li>
        </c:if>
        <c:if test="${not empty detailData.jobTitle}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.jobTitle"/> : ${fn:escapeXml(detailData.jobTitle)}</li>
        </c:if>
        <c:if test="${not empty detailData.employmentStartDate}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.employmentStartDate"/> :
                <formatter:propertyValueFormatter targetFormatKey="checkout.text.configuration.format.date" rawValue="${detailData.employmentStartDate}"/>
            </li>
        </c:if>

        <c:if test="${not empty detailData.earnings}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.earnings"/> :</li>
            <ul class="accordion-item__list">
                <c:if test="${not empty detailData.earnings.incomeFrequency}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.earnings.incomeFrequency"/> :
                        <formatter:propertyValueFormatter valueKeyPrefix="checkout.multi.quoteReview.details.policy.holder.earnings.incomeFrequency" rawValue="${detailData.earnings.incomeFrequency}"/>
                    </li>
                </c:if>
                <c:if test="${not empty detailData.earnings.netIncomeAmount}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.earnings.netIncomeAmount"/> : ${fn:escapeXml(detailData.earnings.netIncomeAmount)}</li>
                </c:if>
                <c:if test="${not empty detailData.earnings.hasAnyOtherIncome}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.earnings.hasAnyOtherIncome"/> : <spring:theme code="checkout.multi.quoteReview.boolean.${detailData.earnings.hasAnyOtherIncome}"/></li>
                </c:if>
                <c:if test="${not empty detailData.earnings.typeOfIncome}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.earnings.typeOfIncome"/> : ${fn:escapeXml(detailData.earnings.typeOfIncome)}</li>
                </c:if>
                <c:if test="${not empty detailData.earnings.secondJobIncomeFrequency}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.earnings.secondJobIncomeFrequency"/> : ${fn:escapeXml(detailData.earnings.secondJobIncomeFrequency)}</li>
                </c:if>
                <c:if test="${not empty detailData.earnings.secondJobNetIncomeAmounth}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.earnings.secondJobNetIncomeAmounth"/> : ${fn:escapeXml(detailData.earnings.secondJobNetIncomeAmounth)}</li>
                </c:if>
                <c:if test="${not empty detailData.earnings.workingOvertimeIncomeFrequency}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.earnings.workingOvertimeIncomeFrequency"/> : ${fn:escapeXml(detailData.earnings.workingOvertimeIncomeFrequency)}</li>
                </c:if>
                <c:if test="${not empty detailData.earnings.workingOvertimeNetIncomeAmount}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.earnings.workingOvertimeNetIncomeAmount"/> : ${fn:escapeXml(detailData.earnings.workingOvertimeNetIncomeAmount)}</li>
                </c:if>
                <c:if test="${not empty detailData.earnings.otherIncomeIncomeFrequency}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.earnings.otherIncomeIncomeFrequency"/> : ${fn:escapeXml(detailData.earnings.otherIncomeIncomeFrequency)}</li>
                </c:if>
                <c:if test="${not empty detailData.earnings.otherIncomeNetIncomeAmount}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.earnings.otherIncomeNetIncomeAmount"/> : ${fn:escapeXml(detailData.earnings.otherIncomeNetIncomeAmount)}</li>
                </c:if>
                <c:if test="${not empty detailData.earnings.hasFinancialCommitments}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.earnings.hasFinancialCommitments"/> : <spring:theme code="checkout.multi.quoteReview.boolean.${detailData.earnings.hasFinancialCommitments}"/></li>
                </c:if>
                <c:if test="${not empty detailData.earnings.financialCommitmentsDescription}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.earnings.financialCommitmentsDescription"/> : ${fn:escapeXml(detailData.earnings.financialCommitmentsDescription)}</li>
                </c:if>
                <c:if test="${not empty detailData.earnings.hasFinancialObstacles}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.earnings.hasFinancialObstacles"/> : <spring:theme code="checkout.multi.quoteReview.boolean.${detailData.earnings.hasFinancialObstacles}"/></li>
                </c:if>
                <c:if test="${not empty detailData.earnings.financialObstaclesDescription}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.earnings.financialObstaclesDescription"/> : ${fn:escapeXml(detailData.earnings.financialObstaclesDescription)}</li>
                </c:if>
            </ul>
        </c:if>
        <c:if test="${not empty detailData.possessions.hasAnyPossessions}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.possessions"/> : </li>
            <ul class="accordion-item__list">
                <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.possessions.hasAnyPossessions"/> : <spring:theme code="checkout.multi.quoteReview.boolean.${detailData.possessions.hasAnyPossessions}"/></li>
                <c:if test="${detailData.possessions.hasAnyPossessions eq 'true'}">
                    <c:if test="${not empty detailData.possessions.numberOfRealEstates}">
                        <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.possessions.numberOfRealEstates"/> : ${fn:escapeXml(detailData.possessions.numberOfRealEstates)}</li>
                        <c:if test="${not empty detailData.possessions.realEstates}">
                            <ul class="accordion-item__list">
                                <c:forEach items="${detailData.possessions.realEstates}" var="realEstates" varStatus="status">
                                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.possessions.realEstates" text="Real Estates"/>&nbsp;${status.count}</li>
                                    <ul class="accordion-item__list">
                                        <c:if test="${not empty realEstates.type}">
                                            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.possessions.realEstates.type"/> : ${fn:escapeXml(realEstates.type)}</li>
                                        </c:if>
                                        <c:if test="${not empty realEstates.estimatedValue}">
                                            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.possessions.realEstates.estimatedValue"/> : ${fn:escapeXml(realEstates.estimatedValue)}</li>
                                        </c:if>
                                    </ul>
                                </c:forEach>
                            </ul>
                        </c:if>
                    </c:if>
                    <c:if test="${not empty detailData.possessions.numberOfVehicles}">
                        <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.possessions.numberOfVehicles"/> : ${detailData.possessions.numberOfVehicles}</li>
                        <c:if test="${not empty detailData.possessions.vehicles}">
                            <ul class="accordion-item__list">
                                <c:forEach items="${detailData.possessions.vehicles}" var="vehicles" varStatus="status">
                                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.possessions.vehicles" text="Vehicles"/>&nbsp;${status.count}</li>
                                    <ul class="accordion-item__list">
                                        <c:if test="${not empty vehicles.type}">
                                            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.possessions.vehicles.type"/> : ${fn:escapeXml(vehicles.type)}</li>
                                        </c:if>
                                        <c:if test="${not empty vehicles.estimatedValue}">
                                            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.possessions.vehicles.estimatedValue"/> : ${fn:escapeXml(vehicles.estimatedValue)}</li>
                                        </c:if>
                                    </ul>
                                </c:forEach>
                            </ul>
                        </c:if>
                    </c:if>
                    <c:if test="${not empty detailData.possessions.numberOfBankAccounts}">
                        <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.possessions.numberOfBankAccounts"/> : ${fn:escapeXml(detailData.possessions.numberOfBankAccounts)}</li>
                        <c:if test="${not empty detailData.possessions.bankAccounts}">
                            <ul class="accordion-item__list">
                                <c:forEach items="${detailData.possessions.bankAccounts}" var="bankAccounts" varStatus="status">
                                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.possessions.bankAccounts" text="BankAccounts"/>&nbsp;${status.count}</li>
                                    <ul class="accordion-item__list">
                                        <c:if test="${not empty bankAccounts.type}">
                                            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.possessions.bankAccounts.type"/> : ${fn:escapeXml(bankAccounts.type)}</li>
                                        </c:if>
                                        <c:if test="${not empty bankAccounts.balance}">
                                            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.possessions.bankAccounts.balance"/> : ${fn:escapeXml(bankAccounts.balance)}</li>
                                        </c:if>
                                    </ul>
                                </c:forEach>
                            </ul>
                        </c:if>
                    </c:if>
                    <c:if test="${not empty detailData.possessions.totalValueOfOtherAssets}">
                        <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.possessions.totalValueOfOtherAssets"/> : ${fn:escapeXml(detailData.possessions.totalValueOfOtherAssets)}</li>
                    </c:if>
                </c:if>
            </ul>
        </c:if>
        <c:if test="${not empty detailData.debts.hasAnyDebts}">
            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.debts"/> : </li>
            <ul class="accordion-item__list">
                <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.debts.hasAnyDebts"/> : <spring:theme code="checkout.multi.quoteReview.boolean.${detailData.debts.hasAnyDebts}"/></li>
                <c:if test="${detailData.debts.hasAnyDebts eq 'true'}">
                    <c:if test="${not empty detailData.debts.numberOfCreditCards}">
                        <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.debts.numberOfCreditCards"/> : ${fn:escapeXml(detailData.debts.numberOfCreditCards)}</li>
                        <c:if test="${not empty detailData.debts.creditCards}">
                            <ul class="accordion-item__list">
                                <c:forEach items="${detailData.debts.creditCards}" var="creditCards" varStatus="status">
                                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.debts.creditCards" text="CreditCards"/>&nbsp;${status.count}</li>
                                    <ul class="accordion-item__list">
                                        <c:if test="${not empty creditCards.limit}">
                                            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.debts.creditCards.limit"/> : ${fn:escapeXml(creditCards.limit)}</li>
                                        </c:if>
                                        <c:if test="${not empty creditCards.remainingDebt}">
                                            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.debts.creditCards.remainingDebt"/> : ${fn:escapeXml(creditCards.remainingDebt)}</li>
                                        </c:if>
                                    </ul>
                                </c:forEach>
                            </ul>
                        </c:if>
                    </c:if>

                    <c:if test="${not empty detailData.debts.numberOfOtherLoans}">
                        <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.debts.numberOfOtherLoans"/> : ${fn:escapeXml(detailData.debts.numberOfOtherLoans)}</li>
                        <c:if test="${not empty detailData.debts.otherLoans}">
                            <ul class="accordion-item__list">
                                <c:forEach items="${detailData.debts.otherLoans}" var="otherLoans" varStatus="status">
                                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.debts.otherLoans" text="otherLoans"/>&nbsp;${status.count}</li>
                                    <ul class="accordion-item__list">
                                        <c:if test="${not empty otherLoans.originalAmount}">
                                            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.debts.otherLoans.originalAmount"/> : ${fn:escapeXml(otherLoans.originalAmount)}</li>
                                        </c:if>
                                        <c:if test="${not empty otherLoans.remainingDebt}">
                                            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.debts.otherLoans.remainingDebt"/> : ${fn:escapeXml(otherLoans.remainingDebt)}</li>
                                        </c:if>
                                    </ul>
                                </c:forEach>
                            </ul>
                        </c:if>
                    </c:if>

                    <c:if test="${not empty detailData.debts.numberOfOtherDebts}">
                        <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.debts.numberOfOtherDebts"/> : ${fn:escapeXml(detailData.debts.numberOfOtherDebts)}</li>
                        <c:if test="${not empty detailData.debts.otherDebts}">
                            <ul class="accordion-item__list">
                                <c:forEach items="${detailData.debts.otherDebts}" var="otherDebts" varStatus="status">
                                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.debts.otherDebts" text="otherDebts"/>&nbsp;${status.count}</li>
                                    <ul class="accordion-item__list">
                                        <c:if test="${not empty otherDebts.type}">
                                            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.debts.otherDebts.type"/> : ${fn:escapeXml(otherDebts.type)}</li>
                                        </c:if>
                                        <c:if test="${not empty otherDebts.approximateRemainingAmount}">
                                            <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.debts.otherDebts.approximateRemainingAmount"/> : ${fn:escapeXml(otherDebts.approximateRemainingAmount)}</li>
                                        </c:if>
                                    </ul>
                                </c:forEach>
                            </ul>
                        </c:if>
                    </c:if>
                </c:if>

                <c:if test="${not empty detailData.debts.totalOtherMonthlyExpenses}">
                    <li class="accordion-item__list-item"><spring:theme code="checkout.multi.quoteReview.details.policy.holder.debts.totalOtherMonthlyExpenses"/> : ${fn:escapeXml(detailData.debts.totalOtherMonthlyExpenses)}</li>
                </c:if>
            </ul>
        </c:if>
    </ul>
</c:if>

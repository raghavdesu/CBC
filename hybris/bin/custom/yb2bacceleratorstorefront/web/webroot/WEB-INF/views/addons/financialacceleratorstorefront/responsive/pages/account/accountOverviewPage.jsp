<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format"%>
<spring:htmlEscape defaultHtmlEscape="true" />

<div id="accountOverview" class="account-overview-accordion">
	<div class="col-xs-12 account-overview-accordion-header__wrapper">
		<div class="account-overview-accordion-header">
			<div class="account-overview-accordion-header__text">
				<spring:theme code="text.account.myAccountOverview" />
			</div>
		</div>
	</div>
	<c:choose>
		<c:when test="${empty bankAccountDetails.results}">
			<p>
				<spring:theme code="text.account.myAccountOverview.noData" />
			</p>
		</c:when>
		<c:otherwise>
			<c:set var="previousAccountType" value=""/>
			<c:forEach items="${bankAccountDetails.results}" var="bankAccount">
				<c:set var="presentAccountType" value="${bankAccount.accountType}"/>
				<c:if test="${previousAccountType ne presentAccountType}">
					<div class="account-overview-accordion-item">
						<div class="col-xs-12 account-overview-accordion-item__wrapper">
							<h2 class="account-overview-accordion-item--valid js-toggle">
								<c:out value="${bankAccount.categoryData.name}"/>
								<span class="account-overview-accordion-item--open" data-open="accordionItem"></span>
							</h2>
							<div id="accordionItem" class="account-overview-accordion-item__body">
								<c:forEach items="${bankAccountDetails.results}" var="bankAccount">
									<c:if test="${bankAccount.accountType eq presentAccountType}">
										<div class="col-xs-12 col-sm-6 col-md-4 bank-account">
											<div class="bank-account__wrapper">
												<div class="bank-account__title">
													<span class="images images__wrapper"> 
														<img class="images__size" src="${bankAccount.categoryData.image.url}" alt="">
													</span>
													<h4 class="bank-account__caption">
														<c:out value="${bankAccount.categoryData.name}"/>
													</h4>
												</div>
												<div class="bank-account__details-wrapper">
												<c:if test="${bankAccount.accountNumber ne null}">
													<div class="bank-account__details-header ">
														<spring:theme code="text.account.myAccountOverview.${presentAccountType}.number" />
														<div class="bank-account__details-value ">${fn:escapeXml(bankAccount.accountNumber)}</div>
													</div>
												</c:if>
												<c:if test="${bankAccount.currentBalance ne null}">
													<div class="bank-account__details-header ">
														<spring:theme code="text.account.myAccountOverview.currentAccount.currentBalance" />
														<div class="bank-account__details-value">
															${fn:escapeXml(bankAccount.currentBalance.formattedValue)}
														</div>
													</div>
												</c:if>
												<c:if test="${bankAccount.availableBalance.formattedValue ne null}">
													<div class="bank-account__details-header ">
														<spring:theme code="text.account.myAccountOverview.currentAccount.availableBalance" />
														<div class="bank-account__details-value">
															${fn:escapeXml(bankAccount.availableBalance.formattedValue)}
														</div>
													</div>
												</c:if>
												<c:if test="${bankAccount.limit.formattedValue ne null}">
													<div class="bank-account__details-header ">
														<spring:theme code="text.account.myAccountOverview.currentAccount.limit" />
														<div class="bank-account__details-value">
															${fn:escapeXml(bankAccount.limit.formattedValue)}
														</div>
													</div>
												</c:if>
												<c:if test="${bankAccount.availableCredit.formattedValue ne null}">
													<div class="bank-account__details-header ">
														<spring:theme code="text.account.myAccountOverview.creditCard.availableCredit" />
														<div class="bank-account__details-value">
															${fn:escapeXml(bankAccount.availableCredit.formattedValue)}
														</div>
													</div>
												</c:if>
												<c:if test="${bankAccount.unbilledAmount.formattedValue ne null}">
													<div class="bank-account__details-header ">
														<spring:theme code="text.account.myAccountOverview.creditCard.unbilledAmount" />
														<div class="bank-account__details-value">
															${fn:escapeXml(bankAccount.unbilledAmount.formattedValue)}
														</div>
													</div>
												</c:if>
												<c:if test="${bankAccount.effectiveCapital.formattedValue ne null}">
													<div class="bank-account__details-header ">
														<spring:theme code="text.account.myAccountOverview.personalLoan.effectiveCapital" />
														<div class="bank-account__details-value">
															${fn:escapeXml(bankAccount.effectiveCapital.formattedValue)}
														</div>
													</div>
												</c:if>
												<c:if test="${bankAccount.installmentAmount.formattedValue ne null}">
													<div class="bank-account__details-header ">
														<spring:theme code="text.account.myAccountOverview.personalLoan.installmentAmount" />
														<div class="bank-account__details-value">
															${fn:escapeXml(bankAccount.installmentAmount.formattedValue)}
														</div>
													</div>
												</c:if>
												<c:if test="${bankAccount.nextStatementDate ne null}">
													<div class="bank-account__details-header ">
														<spring:theme code="text.account.myAccountOverview.creditCard.nextStatementDate" />
														<div class="bank-account__details-value">${fn:escapeXml(bankAccount.nextStatementDate)}</div>
													</div>
												</c:if>
												<c:if test="${bankAccount.nextDueDate ne null}">
													<div class="bank-account__details-header ">
														<spring:theme code="text.account.myAccountOverview.personalLoan.nextDueDate" />
														<div class="bank-account__details-value">${fn:escapeXml(bankAccount.nextDueDate)}</div>
													</div>
												</c:if>
												</div>
												<div class="bank-account__button">
													<a class="primary-button primary-button__default primary-button__bank-account" href="#" disabled="true"> 
														<spring:theme code="text.account.myAccountOverview.details" text="Details"  />
													</a>
												</div>
											</div>
										</div>
									</c:if>
									</c:forEach>
								</div>
							</div>
						</div>
					</c:if>
				<c:set var="previousAccountType" value="${presentAccountType}"/>
			</c:forEach>
		</c:otherwise>
	</c:choose>
</div>

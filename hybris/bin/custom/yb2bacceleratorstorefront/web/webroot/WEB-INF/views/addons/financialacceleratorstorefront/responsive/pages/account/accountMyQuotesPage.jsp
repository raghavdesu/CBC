<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="financialMyAccount" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/account" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true"/>

<h2 class="heading-headline">
	<spring:theme code="text.account.myQuotes.title.${fn:toLowerCase(cmsSite.channel)}"/>
</h2>
<c:choose>
	<c:when test="${empty quotes}">
		<p>
			<spring:theme code="text.account.myQuotes.noQuotes.${fn:toLowerCase(cmsSite.channel)}" text="You have no quotes" />
		</p>
	</c:when>
	<c:otherwise>
		<div id="myQuotesList" class="row">
			<spring:url var="retrieveQuoteUrl" value="/checkout/multi/retrieveQuote" htmlEscape="false"/>
			<c:forEach items="${quotes}" var="quote">
				<c:set var="thumbnail_img" value=""/>
				<c:set var="workflowStatus" value="${quote.quoteWorkflowStatus}"/>
				<c:set var="isExpired" value="${quote.isExpired}"/>
				<div class="col-xs-12 col-sm-6 col-md-4 cards">
					<div class="cards__wrapper cards__wrapper--border-secondary">
						<div class="cards__title cards__title--border-secondary">
                			<span class="images images__wrapper">
	                    		<c:forEach items="${quote.quoteImages}" var="image">
									<c:if test="${image.format == '40Wx40H_quote_responsive'}">
										<c:set var="thumbnail_img" value="${image}"/>
									</c:if>
								</c:forEach>
				                 <span class="images images__wrapper images__wrapper--size">
		                            <c:if test="${not empty thumbnail_img}"><img class="images__size" src="${thumbnail_img.url}" alt=""/></c:if>
		                        </span>
	                   		</span>
							<h3 class="cards__caption cards__caption--color-secondary">
									${fn:escapeXml(quote.defaultCategory.name)}
							</h3>
						</div>
						<div class="cards__details-wrapper">
							<div class="cards__data">
								<span class="title">
										${fn:escapeXml(quote.planName)}
								</span>
								<span class="value">
										${fn:escapeXml(quote.quoteId)}
								</span>
							</div>
							<div class="cards__data">
								<c:set var="quoteStatus">
									<spring:theme code="text.account.myQuotes.quote.status.${quote.quoteStatus}" text="${quote.quoteStatus}" />
								</c:set>
								<c:choose>
									<c:when test="${workflowStatus eq 'REJECTED'}">
										<c:set var="quoteStatus">
											<span class="warn">
												<spring:theme code="text.account.myQuotes.quote.status.rejected" text="Rejected" />
											</span>
										</c:set>
									</c:when>
									<c:when test="${workflowStatus eq 'REFERRED'}">
										<c:set var="quoteStatus">
											<span class="warn">
												<spring:theme code="text.account.myQuotes.quote.status.referred" text="Referred" />
											</span>
										</c:set>
									</c:when>
									<c:otherwise>
										<c:choose>
											<c:when test="${isExpired}">
												<c:set var="quoteStatus">
				                                    <span class="notice">
				        			                	<spring:theme code="text.account.myQuotes.quote.status.expired" text="Expired"/>
				        			                </span>
												</c:set>
											</c:when>
											<c:otherwise>
												<c:choose>
													<c:when test="${quote.state eq 'BIND' and workflowStatus eq 'APPROVED'}">
														<c:set var="quoteStatus">
															<span class="value">
			                                                	<spring:theme code="text.account.myQuotes.quote.status.readyForPurchase" text="Ready for purchase"/>
															</span>
														</c:set>
													</c:when>
													<c:when test="${workflowStatus eq 'ERROR'}">
														<c:set var="quoteStatus">
															<span class="value">
			                                                	<spring:theme code="text.account.myQuotes.quote.status.error" text="Error"/>
															</span>
														</c:set>
													</c:when>
													<c:otherwise>
														<c:set var="quoteStatus">
															<span class="value">
			                                                	<spring:theme code="text.account.myQuotes.quote.status.unfinished" text="Unfinished"/>
															</span>
														</c:set>
													</c:otherwise>
												</c:choose>
											</c:otherwise>
										</c:choose>
									</c:otherwise>
								</c:choose>
								<span class="title">
									 <spring:theme code="text.account.myQuotes.quote.status" text="Quote status"/>
								</span>
									${quoteStatus}

							</div>
							<div class="cards__data">
								<span class="title">
									<spring:theme code="text.account.myQuotes.quote.expiry.date" text="Expires"/>
								</span>
								<span class="value <c:if test='${isExpired}'>notice</c:if>">
									<c:set var="quoteExpiryDate" value="${quote.formattedExpiryDate}"/>
									<c:choose>
										<c:when test="${not empty quoteExpiryDate and workflowStatus ne 'REJECTED' }">
											${fn:escapeXml(quoteExpiryDate)}
										</c:when>
										<c:otherwise>
											<c:choose>
												<c:when test="${workflowStatus == 'REJECTED'}">
													<spring:theme code="checkout.notAvailable" text="N/A"/>
												</c:when>
												<c:otherwise>
													<spring:theme code="checkout.quote.expiry.date.notConfirmed" text="Not Confirmed"/>
												</c:otherwise>
											</c:choose>
										</c:otherwise>
									</c:choose>
                				</span>
							</div>
							<div class="cards__data">
								<span class="title">
									<spring:theme code="text.account.myQuotes.quote.price" text="Price"/>
								</span>
								<span class="value">
									<c:choose>
										<c:when test="${!isExpired and workflowStatus ne 'REJECTED'}">
											${fn:escapeXml(quote.quotePrice)} /
											<c:choose>
												<c:when test="${quote.isMonthly}">
													<spring:theme code="checkout.cart.payment.frequency.monthly" text="Monthly" />
												</c:when>
												<c:otherwise>
													<spring:theme code="checkout.cart.payment.frequency.annual" text="Annual" />
												</c:otherwise>
											</c:choose>
										</c:when>
										<c:otherwise>
											<spring:theme code="checkout.quote.expiry.date.notConfirmed" text="Not Confirmed"/>
										</c:otherwise>
									</c:choose>
								</span>
							</div>
						</div>
						<div class="cards-button-wrapper cards-button-wrapper--border-secondary">
							<div class="cards__button">
								<c:choose>
									<c:when test="${!isExpired and workflowStatus ne 'REJECTED' and workflowStatus ne 'REFERRED'}">
										<form class="my-quotes__retrieve-quote-form" action="${retrieveQuoteUrl}" method="POST">
											<input name="code" value="${quote.cartCode}" type="hidden"/>
											<input type="hidden" name="CSRFToken" value="${CSRFToken.token}">
											<a href="#" type="submit" class="primary-button primary-button__default primary-button__account-quotes js-retrieveBtn"><spring:theme code="text.account.myQuote.quote.retrieve" text="Retrieve"/></a>
										</form>
									</c:when>
									<c:otherwise>
										<a href="#" class="primary-button primary-button__default primary-button__account-quotes" disabled><spring:theme code="checkout.notAvailable" text="N/A"/></a>
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
<financialMyAccount:confirmRetrieveQuoteActionPopup/>

<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="financialMyAccount" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/account" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:htmlEscape defaultHtmlEscape="true"/>

<c:url value="/my-account/my-financial-applications" var="myAccQuotePageUrlLink"/>
<c:if test="${component.visible}">
	<div class="review__quote">
		<c:choose>
			<c:when test="${isAnonymousUser == true}">
				<a href="${myAccQuotePageUrlLink}">
					<button class="primary-button primary-button__default primary-button__home"><spring:theme code="homepage.viewquotescomponent.anonymoususer.button.label"/></button>
				</a>
			</c:when>

			<c:otherwise>
				<c:set value="${component.numberOfQuotesToDisplay}" var="maxItems" />
				<c:choose>
					<c:when test="${not empty quotes}">
						<div id="myQuotesList" class="my-quotes">
							<h2 class="my-quotes__title"><spring:theme code="text.home.retrieveQuotes" text="Retrieve quotes"/></h2>
							<ul>
								<spring:url var="retrieveQuoteUrl" value="/checkout/multi/retrieveQuote" htmlEscape="false"/>

								<c:forEach items="${quotes}" begin="0" end="${maxItems - 1}" var="quote">
									<c:set var="thumbnail_img" value=""/>
									<c:set var="expiredCSS" value=""/>
									<c:forEach items="${quote.quoteImages}" var="image">
										<c:if test="${image.format == '40Wx40H_quote_responsive'}">
											<c:set var="thumbnail_img" value="${image}"/>
										</c:if>
									</c:forEach>
									<c:set var="canProgress" value="${!(quote.isExpired or quote.quoteWorkflowStatus eq 'REJECTED')}"/>
									<c:if test="${!canProgress}">
										<c:set var="expiredCSS" value="expired"/>
									</c:if>
									<c:if test="${canProgress}">
										<form action="${retrieveQuoteUrl}" method="POST">
										<input name="code" value="${quote.cartCode}" type="hidden"/>
										<input type="hidden" name="CSRFToken" value="${CSRFToken.token}">
										<a href="" type="submit" class="js-retrieveBtn">
									</c:if>
									<li class="my-quotes__my-quote">
										<div class="my-quotes__data-container">
											<div class="images images__wrapper">
												<c:if test="${not empty thumbnail_img}"><img class="images images__size" src="${thumbnail_img.url}" alt=""/></c:if>
											</div>
											<div class="my-quotes__name-number">
												<span class="my-quotes__name">${fn:escapeXml(quote.planName)}</span>
												<span class="my-quotes__number">${fn:escapeXml(quote.quoteId)}</span>
											</div>
											<div class="my-quotes__add-infos ${fn:escapeXml(expiredCSS)}">
												<c:choose>
													<c:when test="${quote.quoteWorkflowStatus eq 'REJECTED'}">
														<spring:theme code="homepage.viewquotescomponent.quote.rejected.text" />
													</c:when>
													<c:otherwise>
														<c:choose>
															<c:when test="${quote.isExpired}">
																<spring:theme code="homepage.viewquotescomponent.expires.text"/>&nbsp;${fn:escapeXml(quote.formattedExpiryDate)}
															</c:when>
															<c:otherwise>
																<c:choose>
																	<c:when test="${quote.state eq 'BIND' and quote.quoteWorkflowStatus eq 'APPROVED'}">
																		<spring:theme code="homepage.viewquotescomponent.expires.text"/>&nbsp;${fn:escapeXml(quote.formattedExpiryDate)}
																	</c:when>
																	<c:otherwise>
																		<spring:theme code="homepage.viewquotescomponent.unfinished.text"/>
																	</c:otherwise>
																</c:choose>
															</c:otherwise>
														</c:choose>
													</c:otherwise>
												</c:choose>
											</div>
										</div>
									</li>
									<c:if test="${canProgress}">
										</a></form>
									</c:if>
								</c:forEach>
							</ul>
							<c:if test="${quotes.size() gt maxItems}">
								<a href="${myAccQuotePageUrlLink}"><button class="primary-button primary-button__default primary-button__home"><spring:theme code="homepage.viewquotescomponent.too.many" /></button></a>
							</c:if>
						</div>
					</c:when>
					<c:otherwise>
						<div class="none-quote">
							<h2 class="none-quote__title"><spring:theme code="text.home.retrieveQuotes" text="Retrieve quotes"/></h2>
							<p class="none-quote__content"><spring:theme code="homepage.viewquotescomponent.empty.quotes.title"/></p>
						</div>
					</c:otherwise>
				</c:choose>
			</c:otherwise>

		</c:choose>
		<financialMyAccount:confirmRetrieveQuoteActionPopup/>
	</div>
</c:if>

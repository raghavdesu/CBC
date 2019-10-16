/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.pages.checkout.steps;

import de.hybris.platform.acceleratorstorefrontcommons.annotations.PreValidateCheckoutStep;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.checkout.steps.CheckoutStep;
import de.hybris.platform.acceleratorstorefrontcommons.checkout.steps.validation.CheckoutStepValidator;
import de.hybris.platform.acceleratorstorefrontcommons.checkout.steps.validation.ValidationResults;
import de.hybris.platform.acceleratorstorefrontcommons.constants.WebConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.ContentPageModel;
import de.hybris.platform.commerceservices.order.CommerceCartModificationException;
import de.hybris.platform.commerceservices.order.CommerceSaveCartException;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import de.hybris.platform.financialfacades.facades.InsuranceCartFacade;
import de.hybris.platform.financialfacades.facades.InsuranceQuoteFacade;
import de.hybris.platform.financialservices.enums.QuoteBindingState;
import de.hybris.platform.financialservices.enums.QuoteWorkflowStatus;
import de.hybris.platform.servicelayer.exceptions.UnknownIdentifierException;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.io.IOException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;


@Controller
@RequestMapping(value = "/checkout/multi")
public class MultiStepCheckoutController extends AbstractInsuranceCheckoutStepController
{
	protected static final String MULTI = "multi";

	private static final Logger LOGGER = Logger.getLogger(MultiStepCheckoutController.class);
	private static final String QUOTE_RESUMPTION_ERROR = "checkout.error.invalid.quote";
	private static final String PRICE_CALCULATION_ERROR = "checkout.error.price.calculation";
	private static final String HTTP_REQUEST_REFERER = "Referer";

	@Resource(name = "insuranceQuoteFacade")
	InsuranceQuoteFacade quoteFacade;

	@Resource(name = "cartFacade")
	private InsuranceCartFacade insuranceCartFacade;

	@Resource(name = "paymentCheckoutStepValidator")
	private CheckoutStepValidator checkoutStepValidator;

	@Override
	@RequestMapping(method = RequestMethod.GET)
	@PreValidateCheckoutStep(checkoutStep = MULTI)
	public String enterStep(final Model model, final RedirectAttributes redirectAttributes)
			throws CMSItemNotFoundException, CommerceCartModificationException //NOSONAR
	{
		return getCheckoutStep().nextStep();
	}


	@RequestMapping(value = "/isQuoteBind")
	@RequireHardLogIn
	@ResponseBody
	public String isQuoteBind() throws IOException
	{
		Boolean isQuoteBind = Boolean.FALSE;
		final QuoteBindingState state = getQuoteFacade().getQuoteStateFromSessionCart();
		if (QuoteBindingState.BIND.equals(state))
		{
			isQuoteBind = Boolean.TRUE;
		}
		return isQuoteBind.toString();
	}

	@RequestMapping(value = "/termsAndConditions")
	@RequireHardLogIn
	public String getTermsAndConditions(final Model model) throws CMSItemNotFoundException
	{
		final ContentPageModel pageForRequest = getCmsPageService().getPageForLabelOrId("termsAndConditions");
		storeCmsPageInModel(model, pageForRequest);
		setUpMetaDataForContentPage(model, pageForRequest);
		model.addAttribute(WebConstants.BREADCRUMBS_KEY, getContentPageBreadcrumbBuilder().getBreadcrumbs(pageForRequest));
		return ControllerConstants.Views.Fragments.Checkout.TermsAndConditionsPopup;
	}

	@RequestMapping(value = "/express", method = RequestMethod.GET)
	@RequireHardLogIn
	public String performExpressCheckout(final Model model, final RedirectAttributes redirectModel)
			throws CMSItemNotFoundException, CommerceCartModificationException //NOSONAR
	{
		if (getCheckoutFlowFacade().hasValidCart())
		{
			switch (getCheckoutFacade().performExpressCheckout())
			{
				case SUCCESS:
					return REDIRECT_URL_SUMMARY;

				case ERROR_DELIVERY_ADDRESS:
					GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER,
							"checkout.express.error.deliveryAddress");
					return REDIRECT_URL_FORM_METHOD;

				case ERROR_DELIVERY_MODE:
				case ERROR_CHEAPEST_DELIVERY_MODE:
					GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER,
							"checkout.express.error.deliveryMode");
					return REDIRECT_URL_FORM_METHOD;

				case ERROR_PAYMENT_INFO:
					GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER,
							"checkout.express.error.paymentInfo");
					return REDIRECT_PREFIX + getRedirectAddPaymentInfoUrl();

				default:
					GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER,
							"checkout.express.error.notAvailable");
			}
		}

		return enterStep(model, redirectModel);
	}

	@RequestMapping(value = "/bindQuote", method = RequestMethod.POST)
	@RequireHardLogIn
	@ResponseBody
	public Boolean bindQuote(final Model model, final RedirectAttributes redirectAttributes)
	{

		final QuoteBindingState quoteStateFromSessionCart = getQuoteFacade().getQuoteStateFromSessionCart();
		final ValidationResults validationResult = checkoutStepValidator.validateOnEnter(redirectAttributes);
		if (!validationResult.equals(ValidationResults.SUCCESS))
		{
			// Unbind the quote, If its not valid
			if (QuoteBindingState.BIND.equals(quoteStateFromSessionCart))
			{
				getInsuranceCartFacade().unbindQuoteInSessionCart();
			}
			return false;
		}

		if (QuoteBindingState.UNBIND.equals(quoteStateFromSessionCart))
		{
			return getInsuranceCartFacade().bindQuoteInSessionCart();
		}

		return false;
	}

	@RequestMapping(value = "/isQuoteReferred")
	@RequireHardLogIn
	@ResponseBody
	public Boolean checkIfQuoteIsReferred(final Model model, final RedirectAttributes redirectAttributes)
	{
		return QuoteWorkflowStatus.REFERRED.equals(quoteFacade.getQuoteWorkflowStatus());
	}

	@RequestMapping(value = "/retrieveQuote", method = { RequestMethod.POST, RequestMethod.GET })
	@RequireHardLogIn
	public String retrieveQuoteToSessionCart(@RequestParam(value = "code") final String code,
			@RequestParam(value = "isSaveCart", required = false, defaultValue = "false") final boolean isSaveCart,
			final RedirectAttributes redirectModel, final HttpServletRequest request)
	{
		try
		{
			getInsuranceCartFacade().restoreCart(code, isSaveCart);
		}
		catch (final CommerceSaveCartException e)
		{
			LOGGER.error(e);
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER,
					"save.cart.failed.exception.message");
		}
		catch (final UnknownIdentifierException e)
		{
			LOGGER.error(e.getMessage());
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER,
					QUOTE_RESUMPTION_ERROR);
			return REDIRECT_PREFIX + request.getHeader(HTTP_REQUEST_REFERER);
		}
		catch (final HttpClientErrorException | IllegalStateException e)
		{
			LOGGER.error(e.getMessage());
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER,
					PRICE_CALCULATION_ERROR);
			return REDIRECT_PREFIX + request.getHeader(HTTP_REQUEST_REFERER);
		}
		return REDIRECT_URL_QUOTE_REVIEW;
	}

	@RequestMapping(value = "/back", method = RequestMethod.GET)
	@RequireHardLogIn
	@Override
	public String back(final RedirectAttributes redirectAttributes)
	{
		return getCheckoutStep().previousStep();
	}

	@RequestMapping(value = "/next", method = RequestMethod.GET)
	@RequireHardLogIn
	@Override
	public String next(final RedirectAttributes redirectAttributes)
	{
		return getCheckoutStep().nextStep();
	}

	@Override
	protected CheckoutStep getCheckoutStep()
	{
		return getCheckoutStep(MULTI);
	}

	protected InsuranceQuoteFacade getQuoteFacade()
	{
		return quoteFacade;
	}

	protected InsuranceCartFacade getInsuranceCartFacade()
	{
		return insuranceCartFacade;
	}
}

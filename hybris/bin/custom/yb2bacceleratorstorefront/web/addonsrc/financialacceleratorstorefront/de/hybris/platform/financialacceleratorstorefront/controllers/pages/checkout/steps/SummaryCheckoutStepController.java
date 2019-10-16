/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.pages.checkout.steps;

import de.hybris.platform.acceleratorservices.enums.CheckoutPciOptionEnum;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.PreValidateCheckoutStep;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.checkout.steps.CheckoutStep;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.acceleratorstorefrontcommons.forms.PlaceOrderForm;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.commercefacades.order.data.CartData;
import de.hybris.platform.commercefacades.order.data.OrderData;
import de.hybris.platform.commercefacades.order.data.OrderEntryData;
import de.hybris.platform.commercefacades.product.ProductOption;
import de.hybris.platform.commercefacades.product.data.ProductData;
import de.hybris.platform.commerceservices.order.CommerceCartModificationException;
import de.hybris.platform.financialacceleratorstorefront.constants.WebConstants;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import de.hybris.platform.financialfacades.facades.InsuranceCartFacade;
import de.hybris.platform.financialservices.exception.FSAssistedServiceInvalidCartException;
import de.hybris.platform.order.InvalidCartException;
import de.hybris.platform.payment.AdapterException;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Arrays;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;


@Controller
@RequestMapping(value = "/checkout/multi/summary")
public class SummaryCheckoutStepController extends AbstractInsuranceCheckoutStepController
{
	protected static final String SUMMARY = "summary";

	private static final Logger LOGGER = Logger.getLogger(SummaryCheckoutStepController.class);
	private static final String ASSISTED_SERVICE_CHECKOUT_ERROR = "checkout.error.assisted.service";
	private static final String REDIRECT_TO_HOMEPAGE = REDIRECT_PREFIX + "/";

	@Resource(name = "cartFacade")
	private InsuranceCartFacade cartFacade;

	@RequestMapping(value = "/view", method = RequestMethod.GET)
	@RequireHardLogIn
	@Override
	@PreValidateCheckoutStep(checkoutStep = SUMMARY)
	public String enterStep(final Model model, final RedirectAttributes redirectAttributes)
			throws CMSItemNotFoundException, CommerceCartModificationException //NOSONAR
	{
		final CartData cartData = getCheckoutFacade().getCheckoutCart();
		if (cartData.getEntries() != null && !cartData.getEntries().isEmpty())
		{
			for (final OrderEntryData entry : cartData.getEntries())
			{
				final String productCode = entry.getProduct().getCode();
				final ProductData product = getProductFacade().getProductForCodeAndOptions(productCode,
						Arrays.asList(ProductOption.BASIC, ProductOption.PRICE));
				entry.getProduct().setPrice(product.getPrice());
			}
		}
		model.addAttribute("cartData", cartData);
		model.addAttribute("allItems", cartData.getEntries());
		model.addAttribute("deliveryAddress", cartData.getDeliveryAddress());
		model.addAttribute("deliveryMode", cartData.getDeliveryMode());
		model.addAttribute("paymentInfo", cartData.getPaymentInfo());
		model.addAttribute("addPaymentMethodUrl", getRedirectAddPaymentInfoUrl());

		// Only request the security code if the SubscriptionPciOption is set to Default.
		final boolean requestSecurityCode = CheckoutPciOptionEnum.DEFAULT.equals(
				getCheckoutFlowFacade().getSubscriptionPciOption());
		model.addAttribute("requestSecurityCode", requestSecurityCode);

		model.addAttribute(new PlaceOrderForm());

		storeCmsPageInModel(model, getContentPageForLabelOrId(MULTI_CHECKOUT_SUMMARY_CMS_PAGE_LABEL));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(MULTI_CHECKOUT_SUMMARY_CMS_PAGE_LABEL));
		model.addAttribute(WebConstants.BREADCRUMBS_KEY,
				getResourceBreadcrumbBuilder().getBreadcrumbs("checkout.multi.summary.breadcrumb"));
		model.addAttribute("metaRobots", "noindex,nofollow");
		setCheckoutStepLinksForModel(model, getCheckoutStep());

		return ControllerConstants.Views.Pages.MultiStepCheckout.CheckoutSummaryPage;
	}


	@RequestMapping(value = "/placeOrder")
	@RequireHardLogIn
	public String placeOrder(@ModelAttribute("placeOrderForm") final PlaceOrderForm placeOrderForm, final Model model,
			final HttpServletRequest request, final RedirectAttributes redirectModel)
			throws CMSItemNotFoundException, InvalidCartException, CommerceCartModificationException //NOSONAR
	{
		if (validateOrderForm(placeOrderForm, model))
		{
			return enterStep(model, redirectModel);
		}

		//Validate the cart
		if (validateCart(redirectModel))
		{
			// Invalid cart. Bounce back to the cart page.
			return REDIRECT_PREFIX + "/cart";
		}

		if (isPaymentEnabledForCurrentSite(getCheckoutFacade().getCheckoutCart()) && !isPaymentAuthorized(placeOrderForm))
		{
			GlobalMessages.addErrorMessage(model, "checkout.error.authorization.failed");
			return enterStep(model, redirectModel);
		}

		final OrderData orderData;
		try
		{
			orderData = getCheckoutFacade().placeOrder();
		}
		catch (final FSAssistedServiceInvalidCartException e)
		{
			LOGGER.error(e.getMessage(), e);
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER,
					ASSISTED_SERVICE_CHECKOUT_ERROR);
			return REDIRECT_TO_HOMEPAGE;
		}
		catch (final Exception e)
		{
			LOGGER.error("Failed to place Order", e);
			GlobalMessages.addErrorMessage(model, "checkout.placeOrder.failed");
			return enterStep(model, redirectModel);
		}

		return redirectToOrderConfirmationPage(orderData);
	}

	/**
	 * Validates the order form before to filter out invalid order states
	 *
	 * @param placeOrderForm The spring form of the order being submitted
	 * @param model          A spring Model
	 * @return True if the order form is invalid and false if everything is valid.
	 */
	protected boolean validateOrderForm(final PlaceOrderForm placeOrderForm, final Model model)
	{
		final String securityCode = placeOrderForm.getSecurityCode();
		boolean invalid = false;

		if (!placeOrderForm.isTermsCheck())
		{
			GlobalMessages.addErrorMessage(model, "checkout.error.terms.not.accepted");
			invalid = true;
			return invalid;
		}

		final CartData cartData = getCheckoutFacade().getCheckoutCart();

		if (getCheckoutFlowFacade().hasNoDeliveryAddress())
		{
			GlobalMessages.addErrorMessage(model, "checkout.deliveryAddress.notSelected");
			invalid = true;
		}
		if (isPaymentEnabledForCurrentSite(cartData))
		{
			if (getCheckoutFlowFacade().hasNoPaymentInfo())
			{
				GlobalMessages.addErrorMessage(model, "checkout.paymentMethod.notSelected");
				invalid = true;
			}
			else
			{
				// Only require the Security Code to be entered on the summary page if the SubscriptionPciOption is set to
				// Default.

				if (CheckoutPciOptionEnum.DEFAULT.equals(getCheckoutFlowFacade().getSubscriptionPciOption()) && StringUtils
						.isBlank(securityCode))
				{
					GlobalMessages.addErrorMessage(model, "checkout.paymentMethod.noSecurityCode");
					invalid = true;
				}
			}
		}


		if (!getCheckoutFacade().containsTaxValues())
		{
			LOGGER.error(String.format(
					"Cart %s does not have any tax values, which means the tax calcuation was not properly done, placement of "
							+ "order can't continue",
					cartData.getCode()));
			GlobalMessages.addErrorMessage(model, "checkout.error.tax.missing");
			invalid = true;
		}

		if (!cartData.isCalculated())
		{
			LOGGER.error(String.format("Cart %s has a calculated flag of FALSE, placement of order can't continue",
					cartData.getCode()));
			GlobalMessages.addErrorMessage(model, "checkout.error.cart.notcalculated");
			invalid = true;
		}

		return invalid;
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
		return getCheckoutStep(SUMMARY);
	}

	protected boolean isPaymentAuthorized(PlaceOrderForm placeOrderForm)
	{
		// authorize, if failure occurs don't allow to place the order
		boolean isPaymentAuthorized = false;
		try
		{
			isPaymentAuthorized = getCheckoutFacade().authorizePayment(placeOrderForm.getSecurityCode());
		}
		catch (final AdapterException ae)
		{
			// handle a case where a wrong paymentProvider configurations on the store see getCommerceCheckoutService()
			// .getPaymentProvider()
			LOGGER.error(ae.getMessage(), ae);
		}
		return isPaymentAuthorized;
	}

}

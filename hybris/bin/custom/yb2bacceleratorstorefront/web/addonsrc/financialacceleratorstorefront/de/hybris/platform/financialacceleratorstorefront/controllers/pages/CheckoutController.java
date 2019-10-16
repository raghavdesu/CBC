/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.pages;

import de.hybris.platform.acceleratorfacades.flow.impl.SessionOverrideCheckoutFlowFacade;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.forms.GuestRegisterForm;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import de.hybris.platform.financialacceleratorstorefront.controllers.imported.AcceleratorCheckoutController;
import de.hybris.platform.financialacceleratorstorefront.controllers.imported.AcceleratorControllerConstants;
import de.hybris.platform.servicelayer.exceptions.UnknownIdentifierException;
import org.apache.log4j.Logger;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * CheckoutController.
 */
public class CheckoutController extends AcceleratorCheckoutController
{
	/**
	 * We use this suffix pattern because of an issue with Spring 3.1 where a Uri value is incorrectly extracted if it
	 * contains on or more '.' characters. Please see https://jira.springsource.org/browse/SPR-6164 for a discussion on
	 * the issue and future resolution.
	 */
	private static final Logger LOGGER = Logger.getLogger(CheckoutController.class);

	@Override
	@RequestMapping(value = "/orderConfirmation/" + ORDER_CODE_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
	@RequireHardLogIn
	public String orderConfirmation(@PathVariable("orderCode") final String orderCode, final HttpServletRequest request,
			final Model model) throws CMSItemNotFoundException
	{
		// override destination of orderConfirmationPage
		SessionOverrideCheckoutFlowFacade.resetSessionOverrides();
		final String redirect = super.processOrderCode(orderCode, model, request);

		if (redirect.equals(AcceleratorControllerConstants.Views.Pages.Checkout.CheckoutLoginPage))
		{
			return ControllerConstants.Views.Pages.Checkout.CheckoutConfirmationPage;
		}
		return redirect;
	}

	@Override
	@RequestMapping(value = "/orderConfirmation/" + ORDER_CODE_PATH_VARIABLE_PATTERN, method = RequestMethod.POST)
	public String orderConfirmation(final GuestRegisterForm form, final BindingResult bindingResult, final Model model,
			final HttpServletRequest request, final HttpServletResponse response, final RedirectAttributes redirectModel)
			throws CMSItemNotFoundException
	{
		// override destination of orderConfirmationPage
		super.getGuestRegisterValidator().validate(form, bindingResult);
		final String redirect = processRegisterGuestUserRequest(form, bindingResult, model, request, response, redirectModel);

		if (redirect.equals(AcceleratorControllerConstants.Views.Pages.Checkout.CheckoutLoginPage))
		{
			return ControllerConstants.Views.Pages.Checkout.CheckoutConfirmationPage;
		}
		return redirect;
	}

	@ExceptionHandler(UnknownIdentifierException.class)
	public String handleUnknownIdentifierException(final UnknownIdentifierException exception, final HttpServletRequest request)
	{
		request.setAttribute("message", exception.getMessage());
		LOGGER.warn(exception.getMessage());
		return FORWARD_PREFIX + "/404";
	}
}

/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.pages.checkout.steps;

import de.hybris.platform.acceleratorstorefrontcommons.annotations.PreValidateCheckoutStep;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.checkout.steps.CheckoutStep;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.acceleratorstorefrontcommons.forms.PlaceOrderForm;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.commerceservices.order.CommerceCartModificationException;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import de.hybris.platform.financialservices.enums.IdentificationType;
import de.hybris.platform.order.InvalidCartException;
import org.apache.commons.lang3.BooleanUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;


@Controller
@RequestMapping(value = "/checkout/user-identification")
public class UserIdentificationCheckoutStepController extends AbstractInsuranceCheckoutStepController
{
	public static final String TERMS_CHECKED = "termsChecked";
	public static final String CHECK_TERMS_FORM = "checkTermsForm";
	public static final String NEAREST_BRANCH = "nearestBranch";
	public static final String LEGAL_IDENTIFICATION = "legalIdentification";
	public static final String VIDEO_IDENTIFICATION = "videoIdentification";
	protected static final String USER_IDENTIFICATION = "user-identification";
	private static final String REDIRECT_STRING = "redirect:";

	@RequestMapping(method = RequestMethod.GET)
	@RequireHardLogIn
	@PreValidateCheckoutStep(checkoutStep = USER_IDENTIFICATION)
	public String enterStep(final Model model, final RedirectAttributes redirectAttributes)
			throws CMSItemNotFoundException, CommerceCartModificationException // NOSONAR
	{

		final boolean termsCheckedInSession = BooleanUtils.isTrue(getSessionService().getAttribute(TERMS_CHECKED));
		final PlaceOrderForm placeOrderForm = new PlaceOrderForm();

		if (model.containsAttribute(TERMS_CHECKED))
		{
			final boolean termsChecked = (boolean) model.asMap().get(TERMS_CHECKED);
			placeOrderForm.setTermsCheck(termsChecked);
			getSessionService().setAttribute(TERMS_CHECKED, termsChecked);
		}
		else if (termsCheckedInSession)
		{
			placeOrderForm.setTermsCheck(termsCheckedInSession);
		}

		model.addAttribute(placeOrderForm);

		prepareDataForPage(model);
		storeCmsPageInModel(model, getContentPageForLabelOrId(USER_IDENTIFICATION_PAGE_LABEL));
		setCheckoutStepLinksForModel(model, getCheckoutStep());
		return ControllerConstants.Views.Pages.Checkout.UserIdentificationPage;
	}

	@RequestMapping(value = "/identifyUser")
	@PreValidateCheckoutStep(checkoutStep = USER_IDENTIFICATION)
	@RequireHardLogIn
	public String identifyUser(final Model model, final RedirectAttributes redirectAttributes,
			@ModelAttribute("placeOrderForm") final PlaceOrderForm placeOrderForm, final HttpServletRequest request)
			throws CMSItemNotFoundException, InvalidCartException, CommerceCartModificationException // NOSONAR
	{
		if (!placeOrderForm.isTermsCheck())
		{
			GlobalMessages.addErrorMessage(model, "checkout.error.allTerms.not.accepted");
			return REDIRECT_STRING + getCheckoutStep().previousStep();
		}

		final String identificationTypeName = request.getParameter(USER_IDENTIFICATION);
		if (identificationTypeName == null)
		{
			GlobalMessages.addErrorMessage(model, "checkout.error.identification.not.selected");
			return enterStep(model, redirectAttributes);
		}
		IdentificationType identificationType = null;
		if (identificationTypeName.equals(LEGAL_IDENTIFICATION))
		{
			identificationType = IdentificationType.LEGAL_IDENTIFICATION;
		}
		else if (identificationTypeName.equals(NEAREST_BRANCH))
		{
			identificationType = IdentificationType.NEAREST_BRANCH;
		}
		else if (identificationTypeName.equals(VIDEO_IDENTIFICATION))
		{
			identificationType = IdentificationType.VIDEO_IDENTIFICATION;
		}

		getCartFacade().setUserIdentificationType(identificationType);

		redirectAttributes.addFlashAttribute(placeOrderForm);

		getSessionService().removeAttribute(TERMS_CHECKED);

		return REDIRECT_STRING + "/checkout/multi/summary/placeOrder";
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
		return getCheckoutStep(USER_IDENTIFICATION);
	}
}

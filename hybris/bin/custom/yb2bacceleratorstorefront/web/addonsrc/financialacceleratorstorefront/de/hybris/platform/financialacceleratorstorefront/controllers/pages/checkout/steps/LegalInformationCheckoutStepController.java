/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.pages.checkout.steps;

import de.hybris.platform.acceleratorstorefrontcommons.annotations.PreValidateCheckoutStep;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.checkout.steps.CheckoutStep;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.commerceservices.order.CommerceCartModificationException;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import de.hybris.platform.financialacceleratorstorefront.forms.CheckTermsForm;
import de.hybris.platform.financialfacades.facades.InsuranceCartFacade;
import de.hybris.platform.order.InvalidCartException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;


/**
 * LegalInformationCheckoutStepController
 */
@Controller
@RequestMapping(value = "/checkout/legal-information")
public class LegalInformationCheckoutStepController extends AbstractInsuranceCheckoutStepController
{
	public static final String TERMS_CHECKED = "termsChecked";
	public static final String CHECK_TERMS_FORM = "checkTermsForm";
	protected static final String LEGAL_INFORMATION = "legal-information";
	@Resource(name = "cartFacade")
	private InsuranceCartFacade cartFacade;

	@RequestMapping(method = RequestMethod.GET)
	@RequireHardLogIn
	@PreValidateCheckoutStep(checkoutStep = LEGAL_INFORMATION)
	public String enterStep(final Model model, final RedirectAttributes redirectAttributes)
			throws CMSItemNotFoundException, CommerceCartModificationException //NOSONAR
	{
		model.addAttribute("pdfDocuments", cartFacade.getPdfDocumentsFromSessionCart());

		if (!model.containsAttribute(CHECK_TERMS_FORM))
		{
			model.addAttribute(new CheckTermsForm());
		}
		prepareDataForPage(model);
		storeCmsPageInModel(model, getContentPageForLabelOrId(LEGAL_INFORMATION_PAGE_LABEL));
		setCheckoutStepLinksForModel(model, getCheckoutStep());

		return ControllerConstants.Views.Pages.Checkout.LegalInformationPage;
	}

	@RequestMapping(value = "/termsCheck")
	@RequireHardLogIn
	public String placeOrder(@ModelAttribute(CHECK_TERMS_FORM) final CheckTermsForm checkTermsForm, final Model model,
			final HttpServletRequest request, final RedirectAttributes redirectAttributes)
			throws CMSItemNotFoundException, InvalidCartException, CommerceCartModificationException // NOSONAR
	{
		if (!(checkTermsForm.isTerm1checked() && checkTermsForm.isTerm2checked() && checkTermsForm
				.isTerm3checked() && checkTermsForm.isTerm4checked()))
		{
			GlobalMessages.addErrorMessage(model, "checkout.error.allTerms.not.accepted");
			model.addAttribute(checkTermsForm);
			return enterStep(model, redirectAttributes);
		}

		redirectAttributes.addFlashAttribute(TERMS_CHECKED, true);
		return "redirect:" + getCheckoutStep().nextStep();
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
		return getCheckoutStep(LEGAL_INFORMATION);
	}
}

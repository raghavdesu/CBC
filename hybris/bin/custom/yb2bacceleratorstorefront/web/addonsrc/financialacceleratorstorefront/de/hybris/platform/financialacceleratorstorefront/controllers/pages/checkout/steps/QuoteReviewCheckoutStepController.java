/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.pages.checkout.steps;

import com.google.common.collect.Maps;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.PreValidateCheckoutStep;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.checkout.steps.CheckoutStep;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.ContentPageModel;
import de.hybris.platform.commercefacades.insurance.data.InsuranceQuoteReviewData;
import de.hybris.platform.commerceservices.order.CommerceCartModificationException;
import de.hybris.platform.commerceservices.order.CommerceSaveCartException;
import de.hybris.platform.financialacceleratorstorefront.checkout.step.FinancialServicesCheckoutGroup;
import de.hybris.platform.financialacceleratorstorefront.checkout.step.FinancialServicesCheckoutStep;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import de.hybris.platform.financialfacades.facades.InsuranceQuoteFacade;
import de.hybris.platform.financialfacades.facades.InsuranceQuoteReviewFacade;
import de.hybris.platform.financialservices.enums.QuoteBindingState;
import de.hybris.platform.financialservices.enums.QuoteWorkflowStatus;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping(value = "/checkout/multi/quote")
public class QuoteReviewCheckoutStepController extends AbstractInsuranceCheckoutStepController
{
	protected static final String QUOTE_REVIEW = "quote-review";
	protected static final String CHECKOUT_ERROR = "checkout.error.quote.review.invalid";
	protected static final String CHECKOUT_QUOTE_WORKFLOW_PENDING = "checkout.quote.review.workflow.status.pending";
	protected static final String CHECKOUT_QUOTE_WORKFLOW_PENDING_UPDATE_PROFILE = "checkout.quote.review.workflow.status.pending.update.profile";
	protected static final String CHECKOUT_QUOTE_WORKFLOW_ERROR = "checkout.quote.review.workflow.status.error";
	protected static final String CHECKOUT_QUOTE_WORKFLOW_REJECTED = "checkout.quote.review.workflow.status.rejected";
	private static final Logger LOG = Logger.getLogger(QuoteReviewCheckoutStepController.class);
	@Resource
	private InsuranceQuoteReviewFacade insuranceQuoteReviewFacade;

	@Resource
	private InsuranceQuoteFacade insuranceQuoteFacade;

	@Override
	@RequestMapping(value = "/review", method = RequestMethod.GET)
	@RequireHardLogIn
	@PreValidateCheckoutStep(checkoutStep = QUOTE_REVIEW)
	public String enterStep(final Model model, final RedirectAttributes redirectAttributes)
			throws CMSItemNotFoundException, CommerceCartModificationException //NOSONAR
	{
		final ContentPageModel contentPage = getContentPageForLabelOrId(MULTI_CHECKOUT_SUMMARY_CMS_PAGE_LABEL);
		storeCmsPageInModel(model, contentPage);
		setUpMetaDataForContentPage(model, contentPage);
		setCheckoutStepLinksForModel(model, getCheckoutStep());
		setupDeliveryAddress();
		insuranceQuoteReviewFacade.updateInsuranceQuoteInSessionCart();
		prepareQuoteReview(model);

		try
		{
			getCartFacade().saveCurrentUserCart();
		}
		catch (final CommerceSaveCartException e)
		{
			LOG.error(e);
			LOG.error("Save cart error.");
		}

		return ControllerConstants.Views.Pages.MultiStepCheckout.QuoteReviewPage;
	}

	@Override
	protected void setCheckoutStepLinksForModel(final Model model, final CheckoutStep checkoutStep)
	{
		super.setCheckoutStepLinksForModel(model, checkoutStep);
		if (QuoteBindingState.UNBIND.equals(insuranceQuoteFacade.getQuoteStateFromSessionCart()))
		{
			model.addAttribute("nextStepUrl", StringUtils.remove(checkoutStep.currentStep(), "redirect:"));
		}
	}

	protected void prepareQuoteReview(final Model model)
	{
		model.addAttribute("cartData", getCartFacade().getSessionCart());
		final List<InsuranceQuoteReviewData> insuranceQuoteReviews = insuranceQuoteReviewFacade.getInsuranceQuoteReviews();
		model.addAttribute("insuranceQuoteReviews", insuranceQuoteReviews);

		boolean isValidQuote = ((FinancialServicesCheckoutStep) getCheckoutStep()).isValid();
		for (final InsuranceQuoteReviewData reviewData : insuranceQuoteReviews)
		{
			final Map<String, Boolean> validationMap = Maps.newHashMap();
			if (getCheckoutStep().getCheckoutGroup() instanceof FinancialServicesCheckoutGroup)
			{
				final Map<String, FinancialServicesCheckoutStep> progressBar = ((FinancialServicesCheckoutGroup) getCheckoutStep()
						.getCheckoutGroup())
						.getFinancialServicesCheckoutProgressBar();
				for (final Map.Entry<String, FinancialServicesCheckoutStep> step : progressBar.entrySet())
				{
					validationMap.put(step.getKey(), step.getValue().isValid());
					isValidQuote = isValidQuote(isValidQuote, step);
				}
			}
			reviewData.setValidation(validationMap);
		}

		final QuoteWorkflowStatus workflowStatus = getInsuranceQuoteFacade().getQuoteWorkflowStatus();

		prepareGlobalMessage(model, isValidQuote, workflowStatus);

		model.addAttribute("isValidQuote",
				isValidQuote && (QuoteWorkflowStatus.APPROVED.equals(workflowStatus) || QuoteWorkflowStatus.REFERRED
						.equals(workflowStatus) || QuoteWorkflowStatus.ERROR.equals(workflowStatus)));
	}

	/**
	 * Check if quote valid.
	 */
	private boolean isValidQuote(boolean isValidQuote, Map.Entry<String, FinancialServicesCheckoutStep> step)
	{
		return isValidQuote && !step.getValue().isValid() ? Boolean.FALSE : isValidQuote;
	}

	/**
	 * Prepare the global message for the quote review page.
	 */
	protected void prepareGlobalMessage(final Model model, final boolean isValidQuote, final QuoteWorkflowStatus workflowStatus)
	{
		if (!isValidQuote)
		{
			GlobalMessages.addErrorMessage(model, CHECKOUT_ERROR);
		}
		else if (QuoteWorkflowStatus.PENDING.equals(workflowStatus))
		{
			String message = CHECKOUT_QUOTE_WORKFLOW_PENDING;
			if (getInsuranceQuoteFacade().shouldProfileBeUpdated())
			{
				message = CHECKOUT_QUOTE_WORKFLOW_PENDING_UPDATE_PROFILE;
			}
			GlobalMessages.addConfMessage(model, message);
		}
		else if (QuoteWorkflowStatus.REJECTED.equals(workflowStatus))
		{
			GlobalMessages.addErrorMessage(model, CHECKOUT_QUOTE_WORKFLOW_REJECTED);
		}
		else if (QuoteWorkflowStatus.ERROR.equals(workflowStatus))
		{
			GlobalMessages.addErrorMessage(model, CHECKOUT_QUOTE_WORKFLOW_ERROR);
		}
	}


	@RequestMapping(value = "/back", method = RequestMethod.GET)
	@RequireHardLogIn
	@Override
	public String back(final RedirectAttributes redirectAttributes)
	{
		if (getCartFacade() != null)
		{
			final boolean isUpdatedFromBindToUnbind = getCartFacade().unbindQuoteInSessionCart();
			if (isUpdatedFromBindToUnbind)
			{
				return getCheckoutStep().currentStep();
			}
		}
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
		return getCheckoutStep(QUOTE_REVIEW);
	}

	protected InsuranceQuoteFacade getInsuranceQuoteFacade()
	{
		return insuranceQuoteFacade;
	}

	public void setInsuranceQuoteFacade(final InsuranceQuoteFacade insuranceQuoteFacade)
	{
		this.insuranceQuoteFacade = insuranceQuoteFacade;
	}
}

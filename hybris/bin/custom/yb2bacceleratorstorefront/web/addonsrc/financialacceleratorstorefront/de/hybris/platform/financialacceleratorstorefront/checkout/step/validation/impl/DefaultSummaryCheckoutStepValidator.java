/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.checkout.step.validation.impl;

import de.hybris.platform.acceleratorstorefrontcommons.checkout.steps.validation.AbstractCheckoutStepValidator;
import de.hybris.platform.acceleratorstorefrontcommons.checkout.steps.validation.ValidationResults;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.commercefacades.order.data.CartData;
import de.hybris.platform.financialfacades.facades.InsuranceCheckoutFacade;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Required;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;


public class DefaultSummaryCheckoutStepValidator extends AbstractCheckoutStepValidator
{
	private static final Logger LOGGER = Logger.getLogger(DefaultSummaryCheckoutStepValidator.class);
	private InsuranceCheckoutFacade insuranceCheckoutFacade;

	@Override
	public ValidationResults validateOnEnter(final RedirectAttributes redirectAttributes)
	{
		if (!getCheckoutFlowFacade().hasValidCart())
		{
			LOGGER.info("Missing, empty or unsupported cart");
			return ValidationResults.FAILED;
		}

		if (!getInsuranceCheckoutFacade().orderEntryHasValidFormData())
		{
			GlobalMessages.addFlashMessage(redirectAttributes, GlobalMessages.INFO_MESSAGES_HOLDER,
					"checkout.multi.form.notprovided");
			return ValidationResults.REDIRECT_TO_DUMMY_STEP;
		}

		if (getCheckoutFlowFacade().hasNoDeliveryAddress())
		{
			GlobalMessages.addFlashMessage(redirectAttributes, GlobalMessages.INFO_MESSAGES_HOLDER,
					"checkout.multi.deliveryAddress.notprovided");
			return ValidationResults.REDIRECT_TO_DUMMY_STEP;
		}

		if (getCheckoutFlowFacade().hasNoPaymentInfo())
		{
			GlobalMessages.addFlashMessage(redirectAttributes, GlobalMessages.INFO_MESSAGES_HOLDER,
					"checkout.multi.paymentDetails.notprovided");
			return ValidationResults.REDIRECT_TO_PAYMENT_METHOD;
		}

		final CartData cartData = getCheckoutFacade().getCheckoutCart();

		if (!getCheckoutFacade().hasShippingItems())
		{
			cartData.setDeliveryAddress(null);
		}

		return ValidationResults.SUCCESS;
	}

	protected InsuranceCheckoutFacade getInsuranceCheckoutFacade()
	{
		return insuranceCheckoutFacade;
	}

	@Required
	public void setInsuranceCheckoutFacade(final InsuranceCheckoutFacade insuranceCheckoutFacade)
	{
		this.insuranceCheckoutFacade = insuranceCheckoutFacade;
	}

}

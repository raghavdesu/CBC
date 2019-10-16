/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.checkout.step.validation.impl;

import de.hybris.platform.acceleratorstorefrontcommons.checkout.steps.validation.AbstractCheckoutStepValidator;
import de.hybris.platform.acceleratorstorefrontcommons.checkout.steps.validation.ValidationResults;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import org.apache.log4j.Logger;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;


public class DefaultUserIdentificationStepValidator extends AbstractCheckoutStepValidator
{
	private static final Logger LOG = Logger.getLogger(DefaultUserIdentificationStepValidator.class);

	@Override
	public ValidationResults validateOnEnter(final RedirectAttributes redirectAttributes)
	{
		if (!getCheckoutFlowFacade().hasValidCart())
		{
			LOG.info("Failed to enter in User Identification Checkout Step - invalid cart.");
			GlobalMessages.addFlashMessage(redirectAttributes, GlobalMessages.ERROR_MESSAGES_HOLDER,
					"checkout.multi.expired.checkout");
			return ValidationResults.FAILED;
		}

		return ValidationResults.SUCCESS;
	}
}

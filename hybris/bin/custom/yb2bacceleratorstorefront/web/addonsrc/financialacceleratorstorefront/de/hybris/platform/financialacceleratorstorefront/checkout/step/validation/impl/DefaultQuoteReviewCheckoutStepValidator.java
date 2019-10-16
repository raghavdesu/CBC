/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.checkout.step.validation.impl;

import de.hybris.platform.acceleratorstorefrontcommons.checkout.steps.validation.AbstractCheckoutStepValidator;
import de.hybris.platform.acceleratorstorefrontcommons.checkout.steps.validation.ValidationResults;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;


public class DefaultQuoteReviewCheckoutStepValidator extends AbstractCheckoutStepValidator
{
	@Override
	public ValidationResults validateOnEnter(final RedirectAttributes redirectAttributes)
	{
		return ValidationResults.SUCCESS;
	}
}

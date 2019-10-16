/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.strategies.impl;

import de.hybris.platform.financialacceleratorstorefront.checkout.step.FinancialServicesCheckoutStep;
import de.hybris.platform.financialacceleratorstorefront.strategies.StepTransitionStrategy;
import org.apache.commons.lang3.StringUtils;


public class DefaultStepTransitionStrategy implements StepTransitionStrategy
{

	@Override
	public void setVisited(final FinancialServicesCheckoutStep checkoutStep, final String currentURL)
	{
		final String activeUrl = checkoutStep.getActiveStep();
		final String alternativeUrl = checkoutStep.getAlternativeActiveStep();
		if ((StringUtils.isNotEmpty(activeUrl) && currentURL.contains(activeUrl))
				|| (StringUtils.isNotEmpty(alternativeUrl) && currentURL.contains(alternativeUrl)))
		{
			setVisited(checkoutStep);
		}
	}

	@Override
	public void setVisited(final FinancialServicesCheckoutStep checkoutStep)
	{
		checkoutStep.setVisited(true);
	}

}

/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.strategies;

import de.hybris.platform.financialacceleratorstorefront.checkout.step.FinancialServicesCheckoutStep;


public interface StepTransitionStrategy
{
	/**
	 * Set visited flag on the checkout step if the step is active by indicated current url.
	 */
	void setVisited(FinancialServicesCheckoutStep checkoutStep, String currentURL);

	void setVisited(FinancialServicesCheckoutStep checkoutStep);
}

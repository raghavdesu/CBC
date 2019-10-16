/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.checkout.step;

import de.hybris.platform.acceleratorstorefrontcommons.checkout.steps.CheckoutGroup;
import org.springframework.beans.factory.annotation.Required;

import java.util.Map;


public class FinancialServicesCheckoutGroup extends CheckoutGroup
{
	private Map<String, FinancialServicesCheckoutStep> financialServicesCheckoutProgressBar;

	public Map<String, FinancialServicesCheckoutStep> getFinancialServicesCheckoutProgressBar()
	{
		return financialServicesCheckoutProgressBar;
	}

	@Required
	public void setFinancialServicesCheckoutProgressBar(
			final Map<String, FinancialServicesCheckoutStep> financialServicesCheckoutProgressBar)
	{
		this.financialServicesCheckoutProgressBar = financialServicesCheckoutProgressBar;
	}
}

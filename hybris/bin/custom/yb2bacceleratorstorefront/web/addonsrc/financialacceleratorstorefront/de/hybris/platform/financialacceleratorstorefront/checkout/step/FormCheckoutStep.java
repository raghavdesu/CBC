/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.checkout.step;

public class FormCheckoutStep extends FinancialServicesCheckoutStep
{

	private String formPageId;

	public String getFormPageId()
	{
		return formPageId;
	}

	public void setFormPageId(final String formPageId)
	{
		this.formPageId = formPageId;
	}
}

/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.forms;

import de.hybris.platform.acceleratorstorefrontcommons.forms.UpdateProfileForm;


public class FSUpdateProfileForm extends UpdateProfileForm
{
	private String dateOfBirth;

	/**
	 * @return the dateOfBirth
	 */
	public String getDateOfBirth()
	{
		return dateOfBirth;
	}

	/**
	 * @param dateOfBirth the dateOfBirth to set
	 */
	public void setDateOfBirth(String dateOfBirth)
	{
		this.dateOfBirth = dateOfBirth;
	}
}

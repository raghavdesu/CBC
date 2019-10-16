/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.forms.validation;

import de.hybris.platform.acceleratorstorefrontcommons.forms.validation.ProfileValidator;
import de.hybris.platform.financialacceleratorstorefront.forms.FSUpdateProfileForm;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;

import javax.annotation.Resource;


@Component("fsProfileValidator")
public class FSProfileValidator extends ProfileValidator
{

	@Resource
	private FSDateOfBirthValidator fsDateOfBirthValidator;

	@Override
	public void validate(final Object object, final Errors errors)
	{
		final FSUpdateProfileForm updateProfileForm = (FSUpdateProfileForm) object;
		final String dateOfBirth = updateProfileForm.getDateOfBirth();

		getDateOfBirthValidator().validate(dateOfBirth, errors);
		super.validate(object, errors);

	}

	protected FSDateOfBirthValidator getDateOfBirthValidator()
	{
		return fsDateOfBirthValidator;
	}
}

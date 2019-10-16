/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.forms.validation;

import de.hybris.platform.acceleratorstorefrontcommons.forms.validation.RegistrationValidator;
import de.hybris.platform.financialacceleratorstorefront.forms.FSRegisterForm;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;

import javax.annotation.Resource;


/**
 * Validates fsRegistration forms.
 */
@Component("fsRegistrationValidator")
public class FSRegistrationValidator extends RegistrationValidator
{

	private static final Logger LOGGER = Logger.getLogger(FSRegistrationValidator.class);
	@Resource
	private FSDateOfBirthValidator fsDateOfBirthValidator;

	@Override
	public void validate(final Object object, final Errors errors)
	{
		if (object instanceof FSRegisterForm)
		{
			final FSRegisterForm registerForm = (FSRegisterForm) object;
			final String dateOfBirth = registerForm.getDateOfBirth();

			getDateOfBirthValidator().validate(dateOfBirth, errors);
			super.validate(object, errors);
		}
		else
		{
			super.validate(object, errors);
			LOGGER.warn("Not proper type of form used for registration.");
		}
	}

	protected FSDateOfBirthValidator getDateOfBirthValidator()
	{
		return fsDateOfBirthValidator;
	}

}

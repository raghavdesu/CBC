/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.forms.validation;

import de.hybris.platform.servicelayer.config.ConfigurationService;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import javax.annotation.Resource;
import java.time.DateTimeException;
import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeFormatter;


/**
 * Validator for DateOfBirth
 */
@Component("fsDateOfBirthValidator")
public class FSDateOfBirthValidator implements Validator
{
	private static final int DEFAULT_AGE_MIN = 18;
	private static final String AGE_MIN = "customer.age.minimum";
	private static final String DATE_FORMAT = "global.date.format";

	private static final Logger LOGGER = Logger.getLogger(FSDateOfBirthValidator.class);

	@Resource
	private ConfigurationService configurationService;


	@Override
	public boolean supports(final Class<?> aClass)
	{
		return FSDateOfBirthValidator.class.equals(aClass);
	}

	@Override
	public void validate(final Object object, final Errors errors)
	{
		final String dateOfBirth = (String) object;
		final DateTimeFormatter formatter = DateTimeFormatter
				.ofPattern(getConfigurationService().getConfiguration().getString(DATE_FORMAT));

		try
		{
			final LocalDate dateOfBirthConverted = LocalDate.parse(dateOfBirth, formatter);
			final LocalDate today = LocalDate.now();
			final Period period = Period.between(dateOfBirthConverted, today);
			if (period.getYears() < getConfigurationService().getConfiguration().getInt(AGE_MIN, DEFAULT_AGE_MIN))
			{
				errors.rejectValue("dateOfBirth", "profile.dateOfBirth.invalid.range");
			}
		}
		catch (DateTimeException e)
		{
			LOGGER.warn("dateOfBirth failed: ", e);
			errors.rejectValue("dateOfBirth", "profile.dateOfBirth.invalid.format");
		}
	}

	protected ConfigurationService getConfigurationService()
	{
		return configurationService;
	}
}

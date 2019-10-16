/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialb2baddon.security;

import de.hybris.platform.acceleratorstorefrontcommons.security.AbstractAcceleratorAuthenticationProvider;
import de.hybris.platform.b2b.model.B2BCustomerModel;
import de.hybris.platform.core.model.user.UserModel;
import org.apache.commons.lang.StringUtils;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.userdetails.UserDetails;


/**
 * FSAcceleratorAuthenticationProvider handles additional authentication checks for active status of customer
 */
public class FSAcceleratorAuthenticationProvider extends AbstractAcceleratorAuthenticationProvider
{
	@Override
	protected void additionalAuthenticationChecks(final UserDetails details, final AbstractAuthenticationToken authentication)
	{
		super.additionalAuthenticationChecks(details, authentication);
		final UserModel userModel = getUserService().getUserForUID(StringUtils.lowerCase(details.getUsername()));
		if (userModel instanceof B2BCustomerModel && !((B2BCustomerModel) userModel).getActive())
		{
			throw new DisabledException(messages.getMessage("text.company.manage.units.disabled"));
		}
	}
}

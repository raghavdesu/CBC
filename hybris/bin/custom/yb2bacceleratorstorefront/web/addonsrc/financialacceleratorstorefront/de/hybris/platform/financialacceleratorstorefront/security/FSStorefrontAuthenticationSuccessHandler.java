/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.security;

import de.hybris.platform.acceleratorstorefrontcommons.security.StorefrontAuthenticationSuccessHandler;
import org.springframework.security.core.Authentication;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

import static de.hybris.platform.financialacceleratorstorefront.constants.WebConstants.USER_PERSONAL_DETAILS_CHECK;


/**
 * Success handler initializing user settings, restoring or merging the cart and ensuring the cart is handled correctly.
 * Cart restoration is stored in the session since the request coming in is that to j_spring_security_check and will be
 * redirected.
 */
public class FSStorefrontAuthenticationSuccessHandler extends StorefrontAuthenticationSuccessHandler
{
	@Override
	public void onAuthenticationSuccess(final HttpServletRequest request, final HttpServletResponse response,
			final Authentication authentication) throws IOException, ServletException
	{
		request.getSession().setAttribute(USER_PERSONAL_DETAILS_CHECK, Boolean.TRUE);
		super.onAuthenticationSuccess(request, response, authentication);
	}
}

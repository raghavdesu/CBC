/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.filters;

import de.hybris.platform.financialacceleratorstorefront.restrictions.FSPathRestrictionEvaluator;
import org.springframework.beans.factory.annotation.Required;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


/**
 * Default FS filter. Used for applying restrictions to storefront paths for FS related stuff.
 */
public class DefaultFSPathFilter extends OncePerRequestFilter
{
	private FSPathRestrictionEvaluator fsPathRestrictionEvaluator;

	@Override
	protected void doFilterInternal(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse,
			FilterChain filterChain) throws ServletException, IOException
	{
		if (getFSPathRestrictionEvaluator().evaluate(httpServletRequest, httpServletResponse))
		{
			filterChain.doFilter(httpServletRequest, httpServletResponse);
		}
	}

	protected FSPathRestrictionEvaluator getFSPathRestrictionEvaluator()
	{
		return fsPathRestrictionEvaluator;
	}

	@Required
	public void setFsPathRestrictionEvaluator(FSPathRestrictionEvaluator fsPathRestrictionEvaluator)
	{
		this.fsPathRestrictionEvaluator = fsPathRestrictionEvaluator;
	}
}

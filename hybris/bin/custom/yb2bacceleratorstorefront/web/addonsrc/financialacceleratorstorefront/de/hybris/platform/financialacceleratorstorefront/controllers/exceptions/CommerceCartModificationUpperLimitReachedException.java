/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.exceptions;

import de.hybris.platform.commerceservices.order.CommerceCartModificationException;


/**
 * The class of CommerceCartModificationUpperLimitRearchedException.
 */
public class CommerceCartModificationUpperLimitReachedException extends CommerceCartModificationException //NOSONAR
{
	public CommerceCartModificationUpperLimitReachedException(final String message, final Throwable cause)
	{
		super(message, cause);
	}
}

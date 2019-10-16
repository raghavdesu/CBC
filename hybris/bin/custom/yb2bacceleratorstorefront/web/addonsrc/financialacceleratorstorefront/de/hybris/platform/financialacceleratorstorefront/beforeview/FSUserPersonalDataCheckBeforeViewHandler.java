/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.beforeview;

import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessage;
import de.hybris.platform.acceleratorstorefrontcommons.interceptors.BeforeViewHandler;
import de.hybris.platform.assistedservicestorefront.security.impl.AssistedServiceAuthenticationToken;
import de.hybris.platform.commercefacades.customer.CustomerFacade;
import de.hybris.platform.commercefacades.user.UserFacade;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static de.hybris.platform.financialacceleratorstorefront.constants.WebConstants.USER_PERSONAL_DETAILS_CHECK;


/**
 * The type Fs user personal data check before view handler.
 */
public class FSUserPersonalDataCheckBeforeViewHandler implements BeforeViewHandler
{
	private static final String USER_PERSONAL_DETAILS_NOT_COMPLETED_PLACEHOLDER = "error.user.personalDetails.notCompleted";
	private static final String INFO_MESSAGES_HOLDER = "accInfoMsgs";
	private CustomerFacade customerFacade;
	private UserFacade userFacade;

	protected static GlobalMessage buildMessage(final String messageKey, final Object[] attributes)
	{
		final GlobalMessage message = new GlobalMessage();
		message.setCode(messageKey);
		message.setAttributes(attributes != null ? Arrays.asList(attributes) : Collections.emptyList());

		return message;
	}

	@Override
	public void beforeView(final HttpServletRequest request, final HttpServletResponse response, final ModelAndView modelAndView)
			throws Exception
	{
		if (!getUserFacade().isAnonymousUser()
				&& (Boolean.TRUE.equals(request.getSession().getAttribute(USER_PERSONAL_DETAILS_CHECK))
				|| isUserEmulatingFromASM(request))
				&& customerPersonalDetailsAreNotCompleted())
		{
			final GlobalMessage globalInfoMessage = buildMessage(USER_PERSONAL_DETAILS_NOT_COMPLETED_PLACEHOLDER, null);
			final List<GlobalMessage> messages = new ArrayList<>();
			if (modelAndView.getModelMap().get(INFO_MESSAGES_HOLDER) != null)
			{
				messages.addAll((List<GlobalMessage>) modelAndView.getModelMap().get(INFO_MESSAGES_HOLDER));
			}
			messages.add(globalInfoMessage);
			modelAndView.getModelMap().put(INFO_MESSAGES_HOLDER, messages);
		}
	}

	protected boolean isUserEmulatingFromASM(HttpServletRequest request)
	{
		return (request.getUserPrincipal() instanceof AssistedServiceAuthenticationToken)
				&& ((AssistedServiceAuthenticationToken) request.getUserPrincipal()).isEmulating();
	}

	protected boolean customerPersonalDetailsAreNotCompleted()
	{
		return getCustomerFacade().getCurrentCustomer().getDateOfBirth() == null
				|| getCustomerFacade().getCurrentCustomer().getTitle() == null;
	}

	protected CustomerFacade getCustomerFacade()
	{
		return customerFacade;
	}

	public void setCustomerFacade(CustomerFacade customerFacade)
	{
		this.customerFacade = customerFacade;
	}

	protected UserFacade getUserFacade()
	{
		return userFacade;
	}

	public void setUserFacade(UserFacade userFacade)
	{
		this.userFacade = userFacade;
	}
}

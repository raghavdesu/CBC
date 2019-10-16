/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.misc;

import de.hybris.platform.acceleratorstorefrontcommons.controllers.AbstractController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.servicelayer.services.CMSComponentService;
import de.hybris.platform.constants.FinancialacceleratorstorefrontConstants;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import de.hybris.platform.financialservices.model.components.CMSComparisonTabComponentModel;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;


/**
 * SwitchComparisonTabController
 */
@Controller("SwitchComparisonTabController")
public class SwitchComparisonTabController extends AbstractController
{
	protected static final String COMPONENT_UID_PATH_VARIABLE_PATTERN = "{componentUid:.*}";
	@Resource(name = "cmsComponentService")
	private CMSComponentService cmsComponentService;

	@RequestMapping(value = "/c/tab/" + COMPONENT_UID_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
	public String getComparisonTab(final HttpServletRequest request, @PathVariable final String componentUid, final Model model)
			throws CMSItemNotFoundException
	{
		if (!isValidRequest(request))
		{
			model.addAttribute("isSessionExpires", true);

			return ControllerConstants.Views.Fragments.Catalog.SwitchComparisonTabFragment;
		}

		final CMSComparisonTabComponentModel component = cmsComponentService
				.getSimpleCMSComponent(componentUid);
		model.addAttribute("component", component);
		return ControllerConstants.Views.Fragments.Catalog.SwitchComparisonTabFragment;
	}

	protected boolean isValidRequest(final HttpServletRequest request)
	{
		boolean isValid = true;

		final HttpSession session = request.getSession();

		if (session.isNew() || session.getAttribute(FinancialacceleratorstorefrontConstants.TRIP_PROPERTIES) == null)
		{
			isValid = false;
		}

		return isValid;
	}

}

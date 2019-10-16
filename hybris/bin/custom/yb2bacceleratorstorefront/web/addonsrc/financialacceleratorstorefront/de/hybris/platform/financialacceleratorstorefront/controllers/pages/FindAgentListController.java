/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import de.hybris.platform.financialfacades.facades.AgentFacade;
import de.hybris.platform.financialfacades.facades.InsuranceCartFacade;
import de.hybris.platform.financialfacades.findagent.data.AgentData;
import de.hybris.platform.xyformsservices.exception.YFormServiceException;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Required;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.naming.directory.InvalidAttributeValueException;
import javax.servlet.http.HttpServletRequest;


/**
 * Controller for agent list.
 */
@Controller
@Scope("tenant")
@RequestMapping(value = "/find-agent")
public class FindAgentListController extends AbstractPageController
{

	// CMS Pages
	private static final String AGENT_LIST_CMS_PAGE = "find-agent";
	private static final String AGENT_DATA = "agentData";
	private static final String ACTIVE_CATEGORY = "activeCategory";
	private AgentFacade agentFacade;
	private InsuranceCartFacade cartFacade;

	@ExceptionHandler(CMSItemNotFoundException.class)
	public String handleCMSItemNotFoundException(final CMSItemNotFoundException exception, final HttpServletRequest request)
	{
		request.setAttribute("message", exception.getMessage());
		return FORWARD_PREFIX + "/404";
	}

	@RequestMapping(method = RequestMethod.GET)
	public String showList(@RequestParam(value = ACTIVE_CATEGORY, required = false) final String activeCategory,
			@RequestParam(value = "agent", required = false) final String agentId, final Model model)
			throws CMSItemNotFoundException, YFormServiceException, InvalidAttributeValueException //NOSONAR
	{
		storeCmsPageInModel(model, getContentPageForLabelOrId(AGENT_LIST_CMS_PAGE));

		if (StringUtils.isBlank(activeCategory) && cartFacade.getSelectedInsuranceCategory() != null)
		{
			model.addAttribute(ACTIVE_CATEGORY, cartFacade.getSelectedInsuranceCategory().getCode());
		}
		else
		{
			model.addAttribute(ACTIVE_CATEGORY, StringEscapeUtils.escapeJavaScript(activeCategory));
		}

		if (StringUtils.isNotBlank(agentId))
		{
			final AgentData agent = getAgentFacade().getAgentByUid(agentId);
			model.addAttribute(AGENT_DATA, agent);
		}

		return ControllerConstants.Views.Pages.Agent.AgentList;
	}

	public AgentFacade getAgentFacade()
	{
		return agentFacade;
	}

	@Required
	public void setAgentFacade(final AgentFacade agentFacade)
	{
		this.agentFacade = agentFacade;
	}

	public InsuranceCartFacade getCartFacade()
	{
		return cartFacade;
	}

	@Required
	public void setCartFacade(final InsuranceCartFacade cartFacade)
	{
		this.cartFacade = cartFacade;
	}
}

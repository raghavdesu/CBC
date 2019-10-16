/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.cms;

import de.hybris.platform.commercefacades.product.data.CategoryData;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import de.hybris.platform.financialfacades.facades.AgentFacade;
import de.hybris.platform.financialfacades.findagent.data.AgentData;
import de.hybris.platform.financialservices.model.components.CMSAgentRootComponentModel;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;


@Controller("CMSAgentRootComponentController")
@Scope("tenant")
@RequestMapping(value = ControllerConstants.Actions.Cms.CMSAgentRootComponent)
public class CMSAgentRootComponentController extends SubstitutingCMSAddOnComponentController<CMSAgentRootComponentModel>
{
	private static final String ACTIVE_CATEGORY = "activeCategory";
	private static final Logger LOG = Logger.getLogger(CMSAgentRootComponentController.class);

	@Resource(name = "agentFacade")
	private AgentFacade agentFacade;

	@Override
	protected void fillModel(final HttpServletRequest request, final Model model, final CMSAgentRootComponentModel component)
	{
		if (StringUtils.isNotEmpty(component.getAgentRootCategory()))
		{
			try
			{
				final List<AgentData> agents = getAgentFacade().getAgentsByCategory(component.getAgentRootCategory());

				if (CollectionUtils.isNotEmpty(agents))
				{
					model.addAttribute("agents", agents);
					final CategoryData categoryData = agents.stream().findFirst().get().getCategories().stream()
							.filter(c -> component.getAgentRootCategory().equals(c.getCode())).findFirst().get();
					model.addAttribute("category", categoryData);
				}

				final boolean isActiveCategory = request.getAttribute(ACTIVE_CATEGORY) != null &&
						StringUtils.equals(request.getAttribute(ACTIVE_CATEGORY).toString(), component.getAgentRootCategory());
				model.addAttribute("isActiveCategory", isActiveCategory);
			}
			catch (IllegalArgumentException ex)
			{
				LOG.warn(ex.getMessage(), ex);
			}
		}
	}

	protected AgentFacade getAgentFacade()
	{
		return agentFacade;
	}
}

/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.cms;

import de.hybris.platform.cms2.model.contents.components.CMSImageComponentModel;
import de.hybris.platform.cms2.model.contents.components.SimpleCMSComponentModel;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import de.hybris.platform.financialservices.model.components.CMSComparisonTabComponentModel;
import de.hybris.platform.financialservices.model.components.CMSMultiComparisonTabContainerModel;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;


/**
 * CMS Multi Comparison Tab Container Controller
 */
@Controller("CMSMultiComparisonTabContainerController")
@Scope("tenant")
@RequestMapping(value = ControllerConstants.Actions.Cms.CMSMultiComparisonTabContainer)
public class CMSMultiComparisonTabContainerController
		extends SubstitutingCMSAddOnComponentController<CMSMultiComparisonTabContainerModel>
{
	@Override
	protected void fillModel(final HttpServletRequest request, final Model model,
			final CMSMultiComparisonTabContainerModel component)
	{
		final List<SimpleCMSComponentModel> simpleCMSComponentModels = component.getSimpleCMSComponents();

		if (CollectionUtils.isEmpty(simpleCMSComponentModels))
		{
			return;
		}

		final List<SimpleCMSComponentModel> tabComponents = new ArrayList<>();

		for (final SimpleCMSComponentModel tabComponent : simpleCMSComponentModels)
		{
			if (tabComponent instanceof CMSComparisonTabComponentModel)
			{
				tabComponents.add(tabComponent);
			}
			else if (tabComponent instanceof CMSImageComponentModel)
			{
				model.addAttribute("imageComponent", tabComponent);
			}
		}
		model.addAttribute("tabComponents", tabComponents);
	}

}

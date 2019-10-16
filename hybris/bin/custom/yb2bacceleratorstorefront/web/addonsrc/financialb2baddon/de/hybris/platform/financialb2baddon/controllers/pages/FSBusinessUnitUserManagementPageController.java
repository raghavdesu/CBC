/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialb2baddon.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.Breadcrumb;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.commercefacades.user.data.CustomerData;
import de.hybris.platform.commerceorgaddon.controllers.pages.BusinessUnitUserManagementPageController;
import de.hybris.platform.financialb2baddon.ControllerConstants;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;


/**
 * Controller defines routes to manage Business Unit Users within My Company section.
 */
@RequestMapping(value = "/my-company/organization-management/manage-units")
public class FSBusinessUnitUserManagementPageController extends BusinessUnitUserManagementPageController
{
	@Override
	protected String manageUserDetail(@RequestParam("user") final String userId, final Model model) throws CMSItemNotFoundException
	{
		final CustomerData customerData = b2bUserFacade.getCustomerForUid(userId);
		model.addAttribute("customerData", customerData);
		storeCmsPageInModel(model, getContentPageForLabelOrId(ORGANIZATION_MANAGEMENT_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(ORGANIZATION_MANAGEMENT_CMS_PAGE));
		final List<Breadcrumb> breadcrumbs = myCompanyBreadcrumbBuilder.createManageUserDetailsBreadcrumb(userId);
		model.addAttribute("breadcrumbs", breadcrumbs);

		if (!customerData.getUnit().isActive())
		{
			GlobalMessages.addInfoMessage(model, "text.parentunit.disabled.warning");
		}
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
		return ControllerConstants.Views.Pages.MyCompany.MyCompanyManageUserDetailPage;
	}
}

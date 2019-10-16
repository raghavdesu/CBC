/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialb2baddon.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.Breadcrumb;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractSearchPageController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.b2b.model.B2BCustomerModel;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.commercefacades.user.data.CustomerData;
import de.hybris.platform.commerceorgaddon.controllers.pages.UserManagementPageController;
import de.hybris.platform.financialb2baddon.ControllerConstants;
import de.hybris.platform.commerceservices.search.pagedata.PageableData;
import de.hybris.platform.commerceservices.search.pagedata.SearchPageData;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;


/**
 * Controller defines routes to manage Users within My Company section.
 */
@RequestMapping("/my-company/organization-management/manage-users")
public class FSUserManagementPageController extends UserManagementPageController
{
	protected static final String MANAGE_USERS_BREADCRUMB = "text.company.manageUsers";
	protected static final String MANAGE_USERS_BREADCRUMB_URL = "/my-company/organization-management/manage-users";

	@Override
	@RequestMapping(method = RequestMethod.GET)
	@RequireHardLogIn
	public String manageUsers(@RequestParam(value = "page", defaultValue = "0") final int page,
			@RequestParam(value = "show", defaultValue = "Page") final AbstractSearchPageController.ShowMode showMode,
			@RequestParam(value = "sort", defaultValue = B2BCustomerModel.NAME) final String sortCode, final Model model)
			throws CMSItemNotFoundException
	{
		final PageableData pageableData = createPageableData(page, getSearchPageSize(), sortCode, showMode);
		final SearchPageData<CustomerData> searchPageData = b2bUserFacade.getPagedCustomers(pageableData);
		populateModel(model, searchPageData, showMode);
		storeCmsPageInModel(model, getContentPageForLabelOrId(MY_COMPANY_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(MY_COMPANY_CMS_PAGE));
		final List<Breadcrumb> breadcrumbs = myCompanyBreadcrumbBuilder.getBreadcrumbs(null);
		breadcrumbs.add(new Breadcrumb(MANAGE_USERS_BREADCRUMB_URL, getMessageSource().getMessage(
				MANAGE_USERS_BREADCRUMB, null, getI18nService().getCurrentLocale()), null));
		model.addAttribute("breadcrumbs", breadcrumbs);
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
		return ControllerConstants.Views.Pages.MyCompany.MyCompanyManageUsersPage;
	}

	@Override
	@RequestMapping(value = "/details", method = RequestMethod.GET)
	@RequireHardLogIn
	public String manageUserDetail(@RequestParam("user") final String userId, final Model model) throws CMSItemNotFoundException
	{
		model.addAttribute("action", "manageUsers");
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

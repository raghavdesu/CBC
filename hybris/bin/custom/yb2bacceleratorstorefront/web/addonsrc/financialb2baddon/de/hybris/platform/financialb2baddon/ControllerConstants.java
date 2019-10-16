/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialb2baddon;

public interface ControllerConstants //NOSONAR
{
	String ADDON_PREFIX = "addon:/financialb2baddon/";

	interface Views
	{
		interface Pages
		{
			interface MyCompany // NOSONAR
			{
				String ManageUnitsDetailsPage = ADDON_PREFIX + "pages/company/myCompanyManageUnitDetailsPage"; //NOSONAR
				String MyCompanyManageUserDetailPage = ADDON_PREFIX + "pages/company/myCompanyManageUserDetailPage"; //NOSONAR
				String MyCompanyManageUnitProductListPage =	ADDON_PREFIX + "pages/company/myCompanyManageUnitProductListPage"; //NOSONAR
				String MyCompanyManageProductDetailPage = ADDON_PREFIX + "pages/company/myCompanyManageUnitAddEditFormPage"; //NOSONAR
				String MyCompanyManageUsersPage = ADDON_PREFIX + "pages/company/myCompanyManageUsersPage"; //NOSONAR
			}
			interface Error // NOSONAR
			{
				String ErrorNotFoundPage = "pages/error/errorNotFoundPage"; // NOSONAR
			}
		}
	}
}

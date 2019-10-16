/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialb2baddon.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.Breadcrumb;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.b2bcommercefacades.company.data.B2BSelectionData;
import de.hybris.platform.b2bcommercefacades.company.data.B2BUnitData;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.commercefacades.product.data.ProductData;
import de.hybris.platform.commerceorgaddon.controllers.pages.BusinessUnitManagementPageController;
import de.hybris.platform.commerceservices.customer.DuplicateUidException;
import de.hybris.platform.core.servicelayer.data.SearchPageData;
import de.hybris.platform.financialb2baddon.ControllerConstants;
import de.hybris.platform.financialb2baddon.controllers.FSB2BControllerUtils;
import de.hybris.platform.financialb2bfacades.data.FSProductAssignmentData;
import de.hybris.platform.financialb2bfacades.facades.FSProductAssignmentFacade;
import de.hybris.platform.servicelayer.exceptions.AmbiguousIdentifierException;
import de.hybris.platform.servicelayer.exceptions.ModelRemovalException;
import de.hybris.platform.servicelayer.exceptions.ModelSavingException;
import de.hybris.platform.servicelayer.exceptions.UnknownIdentifierException;
import de.hybris.platform.servicelayer.search.paginated.constants.SearchConstants;
import de.hybris.platform.servicelayer.search.paginated.util.PaginatedSearchUtils;
import org.apache.log4j.Logger;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;


/**
 * Controller defines routes to manage Business Units within My Company section.
 */
@RequestMapping("/my-company/organization-management/manage-units")
public class FSBusinessUnitManagementPageController extends BusinessUnitManagementPageController
{

	private static final Logger LOG = Logger.getLogger(FSBusinessUnitManagementPageController.class);
	private static final String SYSTEM_ERROR_PAGE_NOT_FOUND = "system.error.page.not.found";

	protected static final String PAGINATION_NUMBER_OF_RESULTS_COUNT = "pagination.number.results.count";
	protected static final String PRODUCTS_BREADCRUMB = "text.company.manage.units.products";
	protected static final String PRODUCTS_BREADCRUMB_PATH = "/my-company/organization-management/manage-units/products?unit=%s&role=%s";
	protected static final String ASSIGN_PRODUCTS_BREADCRUMB = "text.company.manage.unit.addproducts.breadcrumb";
	protected static final String ASSIGN_PRODUCTS_BREADCRUMB_PATH = "/my-company/organization-management/manage-units/addproducts/?unit=%s&role=%s";
	protected static final int DEFAULT_PAGINATION_NUMBER = 5;
	protected static final String BREADCRUMBS = "breadcrumbs";
	protected static final String PRODUCTS = "products";

	@Resource
	private FSProductAssignmentFacade fsProductAssignmentFacade;

	@Override
	@RequestMapping(value = "/details", method = RequestMethod.GET)
	@RequireHardLogIn
	public String unitDetails(@RequestParam("unit") final String unit, final Model model) throws CMSItemNotFoundException
	{
		storeCmsPageInModel(model, getContentPageForLabelOrId(MANAGE_UNITS_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(MANAGE_UNITS_CMS_PAGE));
		final List<Breadcrumb> breadcrumbs = myCompanyBreadcrumbBuilder.createManageUnitsDetailsBreadcrumbs(unit);
		model.addAttribute(BREADCRUMBS, breadcrumbs);

		B2BUnitData unitData = b2bUnitFacade.getUnitForUid(unit);
		if (unitData == null)
		{
			unitData = new B2BUnitData();
			GlobalMessages.addErrorMessage(model, "b2bunit.notfound");
		}
		else if (!unitData.isActive())
		{
			GlobalMessages.addInfoMessage(model, "b2bunit.disabled.infomsg");
		}

		try
		{
			final List<ProductData> activeProducts = getFsProductAssignmentFacade().getActiveProductsForUnit(unit);
			model.addAttribute(PRODUCTS, activeProducts);
		}
		catch (UnknownIdentifierException | IllegalArgumentException e)
		{
			LOG.error(e.getMessage(), e);
			model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
			GlobalMessages.addErrorMessage(model, SYSTEM_ERROR_PAGE_NOT_FOUND);
			return ControllerConstants.Views.Pages.Error.ErrorNotFoundPage;
		}

		model.addAttribute("isUserAdminOfUnit", getFsProductAssignmentFacade().isUserAdminOfUnit(unit));
		model.addAttribute("unit", unitData);
		model.addAttribute("user", customerFacade.getCurrentCustomer());
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
		return ControllerConstants.Views.Pages.MyCompany.ManageUnitsDetailsPage;
	}

	@RequestMapping(value = "/products", method = RequestMethod.GET)
	public String getPagedProductsForUnit(@RequestParam(value = "page", defaultValue = "0") final int page,
			@RequestParam(value = "show", defaultValue = "Page") final ShowMode showMode,
			@RequestParam(value = "sort", defaultValue = "name") final String sortCode,
			@RequestParam("unit") final String unit, @RequestParam("role") final String role, final Model model,
			final HttpServletRequest request) throws CMSItemNotFoundException
	{
		storeCmsPageInModel(model, getContentPageForLabelOrId(MY_COMPANY_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(MANAGE_UNITS_CMS_PAGE));

		final List<Breadcrumb> breadcrumbs = myCompanyBreadcrumbBuilder.createManageUnitsDetailsBreadcrumbs(unit);
		breadcrumbs.add(new Breadcrumb(String.format(PRODUCTS_BREADCRUMB_PATH, urlEncode(unit), urlEncode(role)),
				getMessageSource().getMessage(PRODUCTS_BREADCRUMB, new Object[] { unit }, getI18nService().getCurrentLocale()),
				null));
		model.addAttribute(BREADCRUMBS, breadcrumbs);
		model.addAttribute("unit", b2bUnitFacade.getUnitForUid(unit));

		final SearchPageData searchPageData = PaginatedSearchUtils.createSearchPageDataWithPaginationAndSorting(
				getSearchPageSize(), page, true, FSB2BControllerUtils.createSortMap(sortCode, SearchConstants.ASCENDING));
		final SearchPageData<FSProductAssignmentData> searchPageResults = getFsProductAssignmentFacade().getPagedProductsForUnit(
				searchPageData, unit);
		FSB2BControllerUtils.populateModel(model, searchPageResults, showMode,
				getSiteConfigService().getInt(PAGINATION_NUMBER_OF_RESULTS_COUNT, DEFAULT_PAGINATION_NUMBER));
		model.addAttribute("action", PRODUCTS);
		model.addAttribute("baseUrl", MANAGE_UNITS_BASE_URL);
		model.addAttribute("cancelUrl", getCancelUrl(MANAGE_UNIT_DETAILS_URL, request.getContextPath(), unit));
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
		return ControllerConstants.Views.Pages.MyCompany.MyCompanyManageUnitProductListPage;
	}

	@ResponseBody
	@RequestMapping(value = "/products/select", method = { RequestMethod.GET, RequestMethod.POST })
	public B2BSelectionData activateProductForUnit(@RequestParam("unit") final String unit,
			@RequestParam("product") final String product, final Model model) throws CMSItemNotFoundException
	{
		return getFsProductAssignmentFacade().setProductAssignmentActiveStatus(unit, product, true);
	}

	@ResponseBody
	@RequestMapping(value = "/products/deselect", method = { RequestMethod.GET, RequestMethod.POST })
	public B2BSelectionData deactivateProductForUnit(@RequestParam("unit") final String unit,
			@RequestParam("product") final String product, final Model model) throws CMSItemNotFoundException
	{
		return getFsProductAssignmentFacade().setProductAssignmentActiveStatus(unit, product, false);
	}

	@RequestMapping(value = "/products/add", method = RequestMethod.GET)
	@RequireHardLogIn
	public String addProductForUnit(@RequestParam("unit") final String unit,
			@RequestParam("role") final String role, final Model model, final RedirectAttributes redirectModel)
			throws CMSItemNotFoundException
	{
		if (getFsProductAssignmentFacade().isUserAdminOfUnit(unit))
		{
			LOG.warn("Attempted to load assign products page of unit where current user is administrator.");
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, SYSTEM_ERROR_PAGE_NOT_FOUND, null);
			return REDIRECT_PREFIX + ROOT;
		}
		else
		{
			storeCmsPageInModel(model, getContentPageForLabelOrId(MANAGE_UNITS_CMS_PAGE));
			setUpMetaDataForContentPage(model, getContentPageForLabelOrId(MANAGE_UNITS_CMS_PAGE));
			final List<Breadcrumb> breadcrumbs = myCompanyBreadcrumbBuilder.createManageUnitsDetailsBreadcrumbs(unit);
			model.addAttribute(BREADCRUMBS, breadcrumbs);
			breadcrumbs.add(new Breadcrumb(String.format(ASSIGN_PRODUCTS_BREADCRUMB_PATH, urlEncode(unit), urlEncode(role)),
					getMessageSource().getMessage(ASSIGN_PRODUCTS_BREADCRUMB, null, getI18nService().getCurrentLocale()), null));

			B2BUnitData unitData = b2bUnitFacade.getUnitForUid(unit);
			if (unitData == null)
			{
				unitData = new B2BUnitData();
				GlobalMessages.addErrorMessage(model, "b2bunit.notfound");
			}
			else if (!unitData.isActive())
			{
				GlobalMessages.addInfoMessage(model, "b2bunit.disabled.infomsg");
			}

			try
			{
				model.addAttribute("assignedProducts", getFsProductAssignmentFacade().getAssignedProductsForUnit(unit));
				model.addAttribute("notAssignedProducts", getFsProductAssignmentFacade().getPotentialProductsForUnit(unit));
				model.addAttribute(PRODUCTS, getFsProductAssignmentFacade().getActiveProductsForUnit(unit));
			}
			catch (UnknownIdentifierException | IllegalArgumentException e)
			{
				LOG.error(e.getMessage(), e);
				model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
				GlobalMessages.addErrorMessage(model, SYSTEM_ERROR_PAGE_NOT_FOUND);
				return ControllerConstants.Views.Pages.Error.ErrorNotFoundPage;
			}

			model.addAttribute("unit", unitData);
			model.addAttribute("user", customerFacade.getCurrentCustomer());
			model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
			return ControllerConstants.Views.Pages.MyCompany.MyCompanyManageProductDetailPage;
		}
	}

	@ResponseBody
	@RequestMapping(value = "/products/assign", method = RequestMethod.POST)
	@RequireHardLogIn
	public ResponseEntity<String> assignProductToUnit(@RequestParam("product") final String product,
			@RequestParam("unit") final String unit) throws CMSItemNotFoundException
	{
		try
		{
			getFsProductAssignmentFacade().assignProductToUnit(product, unit);
		}
		catch (final IllegalArgumentException e)
		{
			LOG.error("Attempt to assign product is not successful.", e);
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		catch (final ModelSavingException | DuplicateUidException | AmbiguousIdentifierException e)
		{
			LOG.error("Failed to create fsProductAssignment for product " + product + " and unit " + unit + ".", e);
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		return new ResponseEntity<>(HttpStatus.OK);
	}

	@ResponseBody
	@RequestMapping(value = "/products/deassign", method = RequestMethod.POST)
	@RequireHardLogIn
	public ResponseEntity<String> deassignProductOfUnit(@RequestParam("product") final String product,
			@RequestParam("unit") final String unit) throws CMSItemNotFoundException
	{
		try
		{
			getFsProductAssignmentFacade().deassignProductOfUnit(product, unit);
		}
		catch (final IllegalArgumentException e)
		{
			LOG.error("Invalid product or unit input for product assignment removal.", e);
			return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
		catch (final ModelRemovalException e)
		{
			LOG.error("Failed to remove fsProductAssignment for product " + product + " and unit " + unit + ".", e);
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		return new ResponseEntity<>(HttpStatus.OK);
	}

	protected FSProductAssignmentFacade getFsProductAssignmentFacade()
	{
		return fsProductAssignmentFacade;
	}
}

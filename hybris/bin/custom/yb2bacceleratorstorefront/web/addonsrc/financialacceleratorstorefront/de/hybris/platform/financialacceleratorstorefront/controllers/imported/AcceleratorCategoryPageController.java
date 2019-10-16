/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.imported;

import de.hybris.platform.acceleratorservices.controllers.page.PageType;
import de.hybris.platform.acceleratorservices.customer.CustomerLocationService;
import de.hybris.platform.acceleratorservices.data.RequestContextData;
import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.impl.SearchBreadcrumbBuilder;
import de.hybris.platform.acceleratorstorefrontcommons.constants.WebConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractSearchPageController;
import de.hybris.platform.acceleratorstorefrontcommons.util.MetaSanitizerUtil;
import de.hybris.platform.acceleratorstorefrontcommons.util.XSSFilterUtil;
import de.hybris.platform.catalog.model.KeywordModel;
import de.hybris.platform.category.model.CategoryModel;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.CategoryPageModel;
import de.hybris.platform.cms2.servicelayer.services.CMSPageService;
import de.hybris.platform.commercefacades.product.data.CategoryData;
import de.hybris.platform.commercefacades.product.data.ProductData;
import de.hybris.platform.commercefacades.search.ProductSearchFacade;
import de.hybris.platform.commercefacades.search.data.SearchQueryData;
import de.hybris.platform.commercefacades.search.data.SearchStateData;
import de.hybris.platform.commerceservices.category.CommerceCategoryService;
import de.hybris.platform.commerceservices.search.facetdata.BreadcrumbData;
import de.hybris.platform.commerceservices.search.facetdata.FacetData;
import de.hybris.platform.commerceservices.search.facetdata.FacetRefinement;
import de.hybris.platform.commerceservices.search.facetdata.ProductCategorySearchPageData;
import de.hybris.platform.commerceservices.search.pagedata.PageableData;
import de.hybris.platform.commerceservices.url.UrlResolver;
import de.hybris.platform.constants.FinancialacceleratorstorefrontConstants;
import de.hybris.platform.servicelayer.exceptions.UnknownIdentifierException;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.context.annotation.Scope;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;


/**
 * Controller for a category page
 */
@Scope("tenant")
@RequestMapping(value = "/**/c")
public class AcceleratorCategoryPageController extends AbstractSearchPageController
{

	private static final Logger LOGGER = Logger.getLogger(AcceleratorCategoryPageController.class);
	private static final String PRODUCT_GRID_PAGE = "category/productGridPage";
	/**
	 * We use this suffix pattern because of an issue with Spring 3.1 where a Uri value is incorrectly extracted if it
	 * contains on or more '.' characters. Please see https://jira.springsource.org/browse/SPR-6164 for a discussion on
	 * the issue and future resolution.
	 */
	private static final String CATEGORY_CODE_PATH_VARIABLE_PATTERN = "/{categoryCode:.*}";

	@Resource(name = "productSearchFacade")
	private ProductSearchFacade<ProductData> productSearchFacade;

	@Resource(name = "cmsPageService")
	private CMSPageService cmsPageService;

	@Resource(name = "commerceCategoryService")
	private CommerceCategoryService commerceCategoryService;

	@Resource(name = "searchBreadcrumbBuilder")
	private SearchBreadcrumbBuilder searchBreadcrumbBuilder;

	@Resource(name = "categoryModelUrlResolver")
	private UrlResolver<CategoryModel> categoryModelUrlResolver;

	@Resource(name = "customerLocationService")
	private CustomerLocationService customerLocationService;

	@Resource(name= "viewOnlyCategories")
	private Set<String> viewOnlyCategories;

	@RequestMapping(value = CATEGORY_CODE_PATH_VARIABLE_PATTERN, method = RequestMethod.GET) //NOSONAR
	public String category(@PathVariable("categoryCode") final String categoryCode, //NOSONAR
			@RequestParam(value = "q", required = false) final String searchQuery, //NOSONAR
			@RequestParam(value = "page", defaultValue = "0") final int page, //NOSONAR
			@RequestParam(value = "show", defaultValue = "Page") final ShowMode showMode, //NOSONAR
			@RequestParam(value = "sort", required = false) final String sortCode, final Model model, //NOSONAR
			final HttpServletRequest request, final HttpServletResponse response) throws UnsupportedEncodingException //NOSONAR
	{
		try
		{
			final CategoryModel category = commerceCategoryService.getCategoryForCode(categoryCode);

			final String redirection = checkRequestUrl(request, response, categoryModelUrlResolver.resolve(category));
			if (StringUtils.isNotEmpty(redirection))
			{
				return redirection;
			}

			final CategoryPageModel categoryPage = getCategoryPage(category);

			final CategorySearchEvaluator categorySearch = new CategorySearchEvaluator(categoryCode,
					XSSFilterUtil.filter(searchQuery), page, showMode, sortCode, categoryPage);
			categorySearch.doSearch();

			final ProductCategorySearchPageData<SearchStateData, ProductData, CategoryData> searchPageData = categorySearch
					.getSearchPageData();
			final boolean showCategoriesOnly = categorySearch.isShowCategoriesOnly();

			storeCmsPageInModel(model, categorySearch.categoryPage);
			storeContinueUrl(request);

			populateModel(model, searchPageData, showMode);
			model.addAttribute(WebConstants.BREADCRUMBS_KEY, searchBreadcrumbBuilder.getBreadcrumbs(categoryCode, searchPageData));
			model.addAttribute("showCategoriesOnly", showCategoriesOnly);
			model.addAttribute(FinancialacceleratorstorefrontConstants.CATEGORY_NAME_MODEL_VAR, category.getName());
			model.addAttribute(FinancialacceleratorstorefrontConstants.CATEGORY_CODE_MODEL_VAR, category.getCode());
			model.addAttribute("pageType", PageType.CATEGORY.name());
			model.addAttribute("userLocation", customerLocationService.getUserLocation());
			model.addAttribute("isViewOnly", viewOnlyCategories.contains(categoryCode));
			updatePageTitle(category, searchPageData.getBreadcrumbs(), model);
			final RequestContextData requestContextData = getRequestContextData(request);
			requestContextData.setCategory(category);
			requestContextData.setSearch(searchPageData);

			if (searchQuery != null)
			{
				model.addAttribute("metaRobots", "noindex,follow");
			}

			final List<String> keywords = category.getKeywords().stream().map(KeywordModel::getKeyword).collect(Collectors.toList());
			final String metaKeywords = MetaSanitizerUtil.sanitizeKeywords(keywords);
			final String metaDescription = MetaSanitizerUtil.sanitizeDescription(category.getDescription());
			setUpMetaData(model, metaKeywords, metaDescription);
			return getViewPage(categorySearch.categoryPage);
		}
		catch (IllegalStateException e)
		{
			LOGGER.warn(e);
			return REDIRECT_PREFIX + ROOT;
		}
	}

	@ResponseBody
	@RequestMapping(value = CATEGORY_CODE_PATH_VARIABLE_PATTERN + "/facets", method = RequestMethod.GET)
	public FacetRefinement<SearchStateData> getFacets(@PathVariable("categoryCode") final String categoryCode,
			@RequestParam(value = "q", required = false) final String searchQuery,
			@RequestParam(value = "page", defaultValue = "0") final int page,
			@RequestParam(value = "show", defaultValue = "Page") final ShowMode showMode,
			@RequestParam(value = "sort", required = false) final String sortCode) throws UnsupportedEncodingException
	{
		final CategoryModel category = commerceCategoryService.getCategoryForCode(categoryCode);
		final CategoryPageModel categoryPage = getCategoryPage(category);
		final CategorySearchEvaluator categorySearch = new CategorySearchEvaluator(categoryCode, searchQuery, page, showMode,
				sortCode, categoryPage);
		categorySearch.doSearch();

		final ProductCategorySearchPageData<SearchStateData, ProductData, CategoryData> searchPageData = categorySearch
				.getSearchPageData();

		final List<FacetData<SearchStateData>> facets = refineFacets(searchPageData.getFacets(),
				convertBreadcrumbsToFacets(searchPageData.getBreadcrumbs()));
		final FacetRefinement<SearchStateData> refinement = new FacetRefinement<>();
		refinement.setFacets(facets);
		refinement.setCount(searchPageData.getPagination().getTotalNumberOfResults());
		refinement.setBreadcrumbs(searchPageData.getBreadcrumbs());
		return refinement;
	}

	@ResponseBody
	@RequestMapping(value = CATEGORY_CODE_PATH_VARIABLE_PATTERN + "/results", method = RequestMethod.GET)
	public SearchResultsData<ProductData> getResults(@PathVariable("categoryCode") final String categoryCode,
			@RequestParam(value = "q", required = false) final String searchQuery,
			@RequestParam(value = "page", defaultValue = "0") final int page,
			@RequestParam(value = "show", defaultValue = "Page") final ShowMode showMode,
			@RequestParam(value = "sort", required = false) final String sortCode) throws UnsupportedEncodingException
	{
		final CategoryModel category = commerceCategoryService.getCategoryForCode(categoryCode);
		final CategoryPageModel categoryPage = getCategoryPage(category);
		final CategorySearchEvaluator categorySearch = new CategorySearchEvaluator(categoryCode, searchQuery, page, showMode,
				sortCode, categoryPage);
		categorySearch.doSearch();

		final ProductCategorySearchPageData<SearchStateData, ProductData, CategoryData> searchPageData = categorySearch
				.getSearchPageData();

		final SearchResultsData<ProductData> searchResultsData = new SearchResultsData<>();
		searchResultsData.setResults(searchPageData.getResults());
		searchResultsData.setPagination(searchPageData.getPagination());
		return searchResultsData;
	}

	protected boolean categoryHasDefaultPage(final CategoryPageModel categoryPage)
	{
		return Boolean.TRUE.equals(categoryPage.getDefaultPage());
	}

	protected CategoryPageModel getCategoryPage(final CategoryModel category)
	{
		try
		{
			return cmsPageService.getPageForCategory(category);
		}
		catch (final CMSItemNotFoundException e)
		{
			LOGGER.info("Could not find Category with code [" + category.getCode() + "]; " + e.getMessage());
		}
		return null;
	}

	protected CategoryPageModel getDefaultCategoryPage()
	{
		try
		{
			return cmsPageService.getPageForCategory(null);
		}
		catch (final CMSItemNotFoundException e)
		{
			LOGGER.info("Could not find the default Category Page; " + e.getMessage());
		}
		return null;
	}

	protected <QUERY> void updatePageTitle(final CategoryModel category, final List<BreadcrumbData<QUERY>> appliedFacets,
			final Model model)
	{
		storeContentPageTitleInModel(model, getPageTitleResolver().resolveCategoryPageTitle(category));
	}

	protected String getViewPage(final CategoryPageModel categoryPage)
	{
		if (categoryPage != null)
		{
			final String targetPage = getViewForPage(categoryPage);
			if (targetPage != null && !targetPage.isEmpty())
			{
				return targetPage;
			}
		}
		return PAGE_ROOT + PRODUCT_GRID_PAGE;
	}

	@ExceptionHandler(UnknownIdentifierException.class)
	public String handleUnknownIdentifierException(final UnknownIdentifierException exception, final HttpServletRequest request)
	{
		request.setAttribute("message", exception.getMessage());
		return FORWARD_PREFIX + "/404";
	}

	private class CategorySearchEvaluator
	{
		private final String categoryCode;
		private final SearchQueryData searchQueryData = new SearchQueryData();
		private final int page;
		private final ShowMode showMode;
		private final String sortCode;
		private CategoryPageModel categoryPage;
		private boolean showCategoriesOnly;
		private ProductCategorySearchPageData<SearchStateData, ProductData, CategoryData> searchPageData;

		public CategorySearchEvaluator(final String categoryCode, final String searchQuery, final int page,
				final ShowMode showMode, final String sortCode, final CategoryPageModel categoryPage)
		{
			this.categoryCode = categoryCode;
			this.searchQueryData.setValue(searchQuery);
			this.page = page;
			this.showMode = showMode;
			this.sortCode = sortCode;
			this.categoryPage = categoryPage;
		}

		public boolean isShowCategoriesOnly()
		{
			return showCategoriesOnly;
		}

		public ProductCategorySearchPageData<SearchStateData, ProductData, CategoryData> getSearchPageData()
		{
			return searchPageData;
		}

		public void doSearch()
		{
			showCategoriesOnly = false;
			if (searchQueryData.getValue() == null)
			{
				// Direct category link without filtering
				searchPageData = productSearchFacade.categorySearch(categoryCode);
				if (categoryPage != null)
				{
					showCategoriesOnly = !categoryHasDefaultPage(categoryPage) && CollectionUtils.isNotEmpty(
							searchPageData.getSubCategories());
				}
			}
			else
			{
				// We have some search filtering
				if (categoryPage == null || !categoryHasDefaultPage(categoryPage))
				{
					// Load the default category page
					categoryPage = getDefaultCategoryPage();
				}

				final SearchStateData searchState = new SearchStateData();
				searchState.setQuery(searchQueryData);

				final PageableData pageableData = createPageableData(page, getSearchPageSize(), sortCode, showMode);
				searchPageData = productSearchFacade.categorySearch(categoryCode, searchState, pageableData);
			}
		}
	}
}

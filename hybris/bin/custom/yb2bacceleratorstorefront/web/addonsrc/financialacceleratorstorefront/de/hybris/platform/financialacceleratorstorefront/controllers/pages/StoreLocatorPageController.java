/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.Breadcrumb;
import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.impl.StorefinderBreadcrumbBuilder;
import de.hybris.platform.acceleratorstorefrontcommons.constants.WebConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractSearchPageController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.acceleratorstorefrontcommons.forms.StoreFinderForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.StorePositionForm;
import de.hybris.platform.acceleratorstorefrontcommons.util.MetaSanitizerUtil;
import de.hybris.platform.acceleratorstorefrontcommons.util.XSSFilterUtil;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.AbstractPageModel;
import de.hybris.platform.cms2.model.pages.ContentPageModel;
import de.hybris.platform.commerceservices.store.data.GeoPoint;
import de.hybris.platform.core.servicelayer.data.SearchPageData;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import de.hybris.platform.financialacceleratorstorefront.controllers.FSControllerUtils;
import de.hybris.platform.financialfacades.facades.AgentFacade;
import de.hybris.platform.financialfacades.findagent.data.AgentData;
import de.hybris.platform.servicelayer.config.ConfigurationService;
import de.hybris.platform.servicelayer.search.paginated.util.PaginatedSearchUtils;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;


/**
 * Controller for store locator search and detail pages.
 */
@Controller
@RequestMapping(value = "/agent-locator")
public class StoreLocatorPageController extends AbstractSearchPageController
{
	private static final Logger LOG = Logger.getLogger(StoreLocatorPageController.class);

	private static final String PAGINATION_NUMBER_OF_RESULTS_COUNT = "pagination.number.results.count";
	private static final String PAGINATION_PAGE_SIZE = "store.locator.pagination.pageSize";

	private static final String AGENT_LOCATOR_CMS_PAGE_LABEL = "agent-locator";
	private static final String GOOGLE_API_KEY_ID = "googleApiKey";
	private static final String GOOGLE_API_VERSION = "googleApiVersion";
	private static final String GEO_POINT = "geoPoint";
	protected static final int DEFAULT_PAGINATION_NUMBER = 5;

	@Resource(name = "configurationService")
	private ConfigurationService configurationService;

	@Resource(name = "storefinderBreadcrumbBuilder")
	private StorefinderBreadcrumbBuilder storefinderBreadcrumbBuilder;

	@Resource(name = "agentFacade")
	private AgentFacade agentFacade;

	@ModelAttribute("googleApiVersion")
	public String getGoogleApiVersion()
	{
		return configurationService.getConfiguration().getString(GOOGLE_API_VERSION);
	}

	@ModelAttribute("googleApiKey")
	public String getGoogleApiKey(final HttpServletRequest request)
	{
		final String googleApiKey = getHostConfigService().getProperty(GOOGLE_API_KEY_ID, request.getServerName());
		if (StringUtils.isEmpty(googleApiKey))
		{
			LOG.warn("No Google API key found for server: " + request.getServerName());
		}
		return googleApiKey;
	}

	@ModelAttribute("pageSize")
	public int getPageSize()
	{
		return Math.abs(configurationService.getConfiguration().getInt(PAGINATION_PAGE_SIZE, 10));
	}

	@ExceptionHandler(CMSItemNotFoundException.class)
	public String handleCMSItemNotFoundException(final CMSItemNotFoundException exception, final HttpServletRequest request)
	{
		request.setAttribute("message", exception.getMessage());
		return FORWARD_PREFIX + "/404";
	}

	// Method to get the empty search form
	@RequestMapping(method = RequestMethod.GET)
	public String getStoreLocatorPage(final Model model) throws CMSItemNotFoundException
	{
		setUpPageForms(model);
		model.addAttribute(WebConstants.BREADCRUMBS_KEY, storefinderBreadcrumbBuilder.getBreadcrumbs());
		storeCmsPageInModel(model, getStoreLocatorPage());
		setUpMetaDataForContentPage(model, (ContentPageModel) getStoreLocatorPage());
		return getViewForPage(model);
	}

	@RequestMapping(method = RequestMethod.GET, params = "q")
	public String findStores(@RequestParam(value = "page", defaultValue = "0") final int page,
			@RequestParam(value = "q") final String agentQuery,
			@RequestParam(value = "latitude", required = false) final Double latitude,
			@RequestParam(value = "longitude", required = false) final Double longitude,
			final Model model) throws CMSItemNotFoundException
	{

		final SearchPageData searchPageData = PaginatedSearchUtils.createSearchPageDataWithPagination(getPageSize(), page, true);
		final String sanitizedSearchQuery = XSSFilterUtil.filter(agentQuery);
		final int numberOfPagesShown = getSiteConfigService().getInt(PAGINATION_NUMBER_OF_RESULTS_COUNT, DEFAULT_PAGINATION_NUMBER);
		
		if (latitude != null && longitude != null)
		{
			final GeoPoint geoPoint = new GeoPoint();
			geoPoint.setLatitude(latitude.doubleValue());
			geoPoint.setLongitude(longitude.doubleValue());

			if (StringUtils.isBlank(sanitizedSearchQuery))
			{
				setUpSearchResultsForAllAgents(geoPoint, searchPageData, model, numberOfPagesShown);
			}
			else
			{
				setUpSearchResultsForAgentQuery(geoPoint, agentQuery, searchPageData, model, numberOfPagesShown);
				setUpMetaData(sanitizedSearchQuery, model);
				setUpPageTitle(sanitizedSearchQuery, model);
			}
		}
		else
		{
			setUpSearchResultsForAgentQuery(null, sanitizedSearchQuery, searchPageData, model, numberOfPagesShown);
			setUpMetaData(sanitizedSearchQuery, model);
			setUpPageTitle(sanitizedSearchQuery, model);
			GlobalMessages.addErrorMessage(model, "agentlocator.error.no.results.subtitle");
			model.addAttribute(WebConstants.BREADCRUMBS_KEY,
					storefinderBreadcrumbBuilder.getBreadcrumbsForLocationSearch(sanitizedSearchQuery));
		}
		setUpPageForms(model);
		storeCmsPageInModel(model, getStoreLocatorPage());

		return ControllerConstants.Views.Pages.StoreFinder.StoreFinderSearchPage;
	}

	// setup methods to populate the model
	protected void setUpMetaData(final String agentQuery, final Model model)
	{
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_FOLLOW);
		final String metaKeywords = MetaSanitizerUtil.sanitizeKeywords(agentQuery);
		final String metaDescription = MetaSanitizerUtil.sanitizeDescription(getSiteName()
				+ " "
				+ getMessageSource().getMessage("storeFinder.meta.description.results", null, "storeFinder.meta.description.results",
				getI18nService().getCurrentLocale()) + " " + agentQuery);
		super.setUpMetaData(model, metaKeywords, metaDescription);
	}

	protected void setUpNoResultsErrorMessage(final Model model, final SearchPageData<AgentData> searchResult)
	{
		if (searchResult.getResults().isEmpty())
		{
			GlobalMessages.addErrorMessage(model, "agentlocator.error.no.results.subtitle");
		}
	}

	protected void setUpPageData(final Model model, final SearchPageData<AgentData> searchResult,
			final List<Breadcrumb> breadCrumbsList, final int numberOfPagesShown)
	{
		FSControllerUtils.populateModel(model, searchResult, ShowMode.Page, numberOfPagesShown);
		model.addAttribute(WebConstants.BREADCRUMBS_KEY, breadCrumbsList);
	}

	protected void setUpSearchResultsForAllAgents(final GeoPoint geoPoint, final SearchPageData searchPageData, final Model model,
			final int numberOfPagesShown)
	{
		final SearchPageData<AgentData> searchResultAgents = getAgentFacade().searchAllAgentsWithPos(searchPageData, geoPoint);
		model.addAttribute(GEO_POINT, geoPoint);
		FSControllerUtils.populateModel(model, searchResultAgents, ShowMode.Page, numberOfPagesShown);
		setUpNoResultsErrorMessage(model, searchResultAgents);

	}

	protected void setUpSearchResultsForAgentQuery(final GeoPoint geoPoint, final String agentQuery,
			final SearchPageData searchPageData, final Model model, final int numberOfPagesShown)
	{
		SearchPageData<AgentData> searchResultAgents = getAgentFacade()
				.searchAgentsByQueryWithPos(agentQuery, searchPageData, geoPoint);

		if (CollectionUtils.isEmpty(searchResultAgents.getResults()))
		{
			searchResultAgents = getAgentFacade().searchAllAgentsWithPos(searchPageData, geoPoint);
		}

		model.addAttribute(GEO_POINT, geoPoint);
		FSControllerUtils.populateModel(model, searchResultAgents, ShowMode.Page, numberOfPagesShown);
		setUpPageData(model, searchResultAgents, storefinderBreadcrumbBuilder.getBreadcrumbsForLocationSearch(agentQuery), numberOfPagesShown);
		setUpNoResultsErrorMessage(model, searchResultAgents);
	}

	protected void setUpPageForms(final Model model)
	{
		final StoreFinderForm storeFinderForm = new StoreFinderForm();
		final StorePositionForm storePositionForm = new StorePositionForm();
		model.addAttribute("storeFinderForm", storeFinderForm);
		model.addAttribute("storePositionForm", storePositionForm);
	}

	protected void setUpPageTitle(final String searchText, final Model model)
	{
		storeContentPageTitleInModel(
				model,
				getPageTitleResolver().resolveContentPageTitle(
						getMessageSource().getMessage("storeFinder.meta.title", null, "storeFinder.meta.title",
								getI18nService().getCurrentLocale())
								+ " " + searchText));
	}

	protected AbstractPageModel getStoreLocatorPage() throws CMSItemNotFoundException
	{
		return getContentPageForLabelOrId(AGENT_LOCATOR_CMS_PAGE_LABEL);
	}

	protected AgentFacade getAgentFacade()
	{
		return agentFacade;
	}
}

/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialb2baddon.controllers;

import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractSearchPageController;
import de.hybris.platform.core.servicelayer.data.SearchPageData;
import org.springframework.ui.Model;

import java.util.HashMap;
import java.util.Map;


/**
 * Utils Controller for handling SearchPageData.
 */
public class FSB2BControllerUtils extends AbstractSearchPageController
{
	public static void populateModel(final Model model, final SearchPageData<?> searchPageData,
			final ShowMode showMode, final int numberOfPagesShown)
	{
		model.addAttribute("numberPagesShown", Integer.valueOf(numberOfPagesShown));
		model.addAttribute("searchPageData", searchPageData);
		model.addAttribute("isShowAllAllowed", calculateShowAll(searchPageData, showMode));
		model.addAttribute("isShowPageAllowed", calculateShowPaged(searchPageData, showMode));
	}

	protected static boolean calculateShowAll(final SearchPageData<?> searchPageData,
			final ShowMode showMode)
	{
		return (showMode != ShowMode.All && searchPageData.getPagination().getTotalNumberOfResults() >
				searchPageData.getPagination().getPageSize()) && isShowAllAllowed(searchPageData);
	}

	protected static boolean calculateShowPaged(final SearchPageData<?> searchPageData,
			final ShowMode showMode)
	{
		return showMode == ShowMode.All && (searchPageData.getPagination()
				.getNumberOfPages() > 1 || searchPageData.getPagination()
				.getPageSize() == AbstractSearchPageController.MAX_PAGE_LIMIT);
	}

	protected static boolean isShowAllAllowed(final SearchPageData<?> searchPageData)
	{
		return searchPageData.getPagination().getNumberOfPages() > 1 && searchPageData.getPagination()
				.getTotalNumberOfResults() < MAX_PAGE_LIMIT;
	}

	public static Map<String, String> createSortMap(final String sortCode, final String sortOrder)
	{
		final Map sortMap = new HashMap<String, String>();
		sortMap.put(sortCode, sortOrder);
		return sortMap;
	}
}

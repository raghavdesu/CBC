/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.ResourceBreadcrumbBuilder;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractSearchPageController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.constants.FinancialacceleratorstorefrontConstants;
import de.hybris.platform.core.servicelayer.data.SearchPageData;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import de.hybris.platform.financialacceleratorstorefront.controllers.FSControllerUtils;
import de.hybris.platform.financialfacades.facades.FSSiteMessageFacade;
import de.hybris.platform.notificationfacades.data.SiteMessageData;
import de.hybris.platform.servicelayer.exceptions.ModelSavingException;
import de.hybris.platform.servicelayer.exceptions.UnknownIdentifierException;
import de.hybris.platform.servicelayer.search.paginated.constants.SearchConstants;
import de.hybris.platform.servicelayer.search.paginated.util.PaginatedSearchUtils;
import org.apache.log4j.Logger;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

import javax.annotation.Resource;

/**
 * Controller for site messages page
 */
@Controller
@RequestMapping("/my-account/inbox")
public class FSInboxController extends AbstractSearchPageController
{
	private static final Logger LOG = Logger.getLogger(FSInboxController.class);
	private static final String BREADCRUMBS_ATTR = "breadcrumbs";
	private static final String META_ROBOTS = "metaRobots";
	private static final String NOINDEX_NOFOLLOW = "noindex,nofollow";
	private static final String INBOX_CMS_PAGE = "inbox";

	@Resource(name = "accountBreadcrumbBuilder")
	private ResourceBreadcrumbBuilder accountBreadcrumbBuilder;

	@Resource(name = "fsSiteMessageFacade")
	private FSSiteMessageFacade fsSiteMessageFacade;

	@RequestMapping(method = RequestMethod.GET)
	@RequireHardLogIn
	public String inbox(final Model model) throws CMSItemNotFoundException
	{
		storeCmsPageInModel(model, getContentPageForLabelOrId(INBOX_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(INBOX_CMS_PAGE));
		model.addAttribute(BREADCRUMBS_ATTR, getAccountBreadcrumbBuilder().getBreadcrumbs("text.account.inbox"));
		model.addAttribute(META_ROBOTS, NOINDEX_NOFOLLOW);
		return getViewForPage(model);
	}

	@RequestMapping(value = "/tab", method = RequestMethod.GET)
	@RequireHardLogIn
	public String fetchInboxMessages(@RequestParam(value = "page", defaultValue = "0") final int page,
			@RequestParam(value = "show", defaultValue = "Page") final ShowMode showMode,
			@RequestParam(value = "messageGroup", defaultValue = "") final String messageGroup,
			@RequestParam(value = "sortCode", defaultValue = "sentDate") final String sortCode,
			@RequestParam(value = "sortOrder", defaultValue = SearchConstants.DESCENDING) final String sortOrder, final Model model)
	{
		final int pageSize = getSiteConfigService().getInt(FinancialacceleratorstorefrontConstants.SITE_MESSAGE_PAGE_SIZE, 5);
		final SearchPageData searchPageData = PaginatedSearchUtils.createSearchPageDataWithPaginationAndSorting(pageSize, page,
				true, FSControllerUtils.createSortMap(sortCode, sortOrder));
		final SearchPageData<SiteMessageData> searchPageResults = getFSSiteMessageFacade()
				.findPaginatedMessagesForCustomerByMessageGroup(messageGroup, searchPageData);
		final int numberOfPagesShown = getSiteConfigService().getInt(
				FinancialacceleratorstorefrontConstants.SITE_MESSAGE_PAGE_NUMBER, 3);
		FSControllerUtils.populateModel(model, searchPageResults, showMode, numberOfPagesShown);
		return ControllerConstants.Views.Fragments.Inbox.SiteMessagesFragment;
	}

	@ResponseBody
	@RequestMapping(value = "/messages/read-unread", method = RequestMethod.POST)
	@RequireHardLogIn
	public ResponseEntity<String> readUnreadMessage(@RequestParam("messages") final List<String> messages,
			@RequestParam("read") final Boolean read)
			throws CMSItemNotFoundException
	{
		try
		{
			getFSSiteMessageFacade().setMessageReadStatus(messages, read);
		}
		catch (final IllegalArgumentException e)
		{
			LOG.error("Attempt to read/unread messages is not successful.", e);
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		catch (final IllegalStateException | UnknownIdentifierException | ModelSavingException e)
		{
			LOG.error("Failed to read/unread messages by code.", e);
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		return new ResponseEntity<>(HttpStatus.OK);
	}

	protected ResourceBreadcrumbBuilder getAccountBreadcrumbBuilder()
	{
		return accountBreadcrumbBuilder;
	}

	protected FSSiteMessageFacade getFSSiteMessageFacade()
	{
		return fsSiteMessageFacade;
	}

}

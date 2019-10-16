/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.ResourceBreadcrumbBuilder;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractSearchPageController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.bankingfacades.data.FSBankAccountData;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.commercefacades.customer.CustomerFacade;
import de.hybris.platform.commercefacades.insurance.data.InsurancePolicyData;
import de.hybris.platform.commercefacades.order.data.CartData;
import de.hybris.platform.commercefacades.quotation.InsuranceQuoteData;
import de.hybris.platform.commercefacades.user.data.CustomerData;
import de.hybris.platform.commerceservices.customer.DuplicateUidException;
import de.hybris.platform.core.servicelayer.data.PaginationData;
import de.hybris.platform.core.servicelayer.data.SearchPageData;
import de.hybris.platform.financialacceleratorstorefront.banking.facades.FSBankAccountFacade;
import de.hybris.platform.financialacceleratorstorefront.forms.FSUpdateProfileForm;
import de.hybris.platform.financialacceleratorstorefront.forms.validation.FSProfileValidator;
import de.hybris.platform.financialfacades.facades.DocumentGenerationFacade;
import de.hybris.platform.financialfacades.facades.FSClaimFacade;
import de.hybris.platform.financialfacades.facades.InsuranceCartFacade;
import de.hybris.platform.financialfacades.facades.InsurancePolicyFacade;
import de.hybris.platform.financialfacades.facades.InsuranceQuoteFacade;
import de.hybris.platform.financialfacades.insurance.data.FSClaimData;
import de.hybris.platform.servicelayer.exceptions.UnknownIdentifierException;
import de.hybris.platform.servicelayer.search.paginated.util.PaginatedSearchUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * Extended Controller for home page - adds functionality to AccountPageController
 */
@Controller
@RequestMapping("/my-account")
public class FSAccountPageController extends AbstractSearchPageController
{
	// Financial CMS Pages
	protected static final String MY_POLICIES_CMS_PAGE = "my-policies";
	protected static final String POLICY_DETAILS_CMS_PAGE = "policy-details";
	protected static final String MY_QUOTES_CMS_PAGE = "my-quotes";
	protected static final String MY_CLAIMS_CMS_PAGE = "my-claims";
	protected static final String PREMIUM_CALENDAR_CMS_PAGE = "premium-calendar";
	protected static final String ACCOUNT_OVERVIEW_CMS_PAGE = "bank-account-overview";
	private static final String POLICY_ID_PATH_VARIABLE_PATTERN = "{policyId:.*}";
	private static final String CONTRACT_ID_PATH_VARIABLE_PATTERN = "{contractId:.*}";
	private static final String REDIRECT_TO_MY_POLICIES_PAGE = REDIRECT_PREFIX + "/my-account/my-policies";
	private static final String META_ROBOTS = "metaRobots";
	private static final String NOINDEX_NOFOLLOW = "noindex,nofollow";
	private static final String FORM_GLOBAL_ERROR = "form.global.error";

	// CMS Pages
	private static final String UPDATE_PROFILE_CMS_PAGE = "fs-update-profile";
	private static final String BREADCRUMBS_ATTR = "breadcrumbs";
	private static final String TITLE_DATA_ATTR = "titleData";
	private static final String TEXT_ACCOUNT_PROFILE = "text.account.profile";

	// Internal Redirects
	private static final String REDIRECT_TO_UPDATE_PROFILE = REDIRECT_PREFIX + "/my-account/fs-update-profile";

	private static final String UPDATE_PROFILE_FORM = "updateProfileForm";

	private static final Logger LOG = Logger.getLogger(FSAccountPageController.class);
	private static final String URL_SEPARATOR = "/";

	@Resource(name = "documentGenerationFacade")
	private DocumentGenerationFacade documentGenerationFacade;
	@Resource(name = "bankAccountFacade")
	FSBankAccountFacade bankAccountFacade;
	@Resource(name = "accountBreadcrumbBuilder")
	private ResourceBreadcrumbBuilder accountBreadcrumbBuilder;
	@Resource(name = "policyFacade")
	private InsurancePolicyFacade insurancePolicyFacade;
	@Resource(name = "fsClaimFacade")
	private FSClaimFacade fsClaimFacade;
	@Resource(name = "insuranceQuoteFacade")
	private InsuranceQuoteFacade quoteFacade;
	@Resource(name = "cartFacade")
	private InsuranceCartFacade cartFacade;
	@Resource(name = "customerFacade")
	private CustomerFacade customerFacade;
	@Resource(name = "fsProfileValidator")
	private FSProfileValidator fsProfileValidator;

	private SimpleDateFormat simpleDateFormat;
	@Resource(name = "globalDateFormat")
	private String dateFormatForDisplay;

	@RequestMapping(value = "/fs-update-profile", method = RequestMethod.GET)
	@RequireHardLogIn
	public String editProfile(final Model model) throws CMSItemNotFoundException
	{
		model.addAttribute(TITLE_DATA_ATTR, getUserFacade().getTitles());

		final CustomerData customerData = customerFacade.getCurrentCustomer();
		final FSUpdateProfileForm updateProfileForm = new FSUpdateProfileForm();

		updateProfileForm.setTitleCode(customerData.getTitleCode());
		updateProfileForm.setFirstName(customerData.getFirstName());
		updateProfileForm.setLastName(customerData.getLastName());

		if ((customerData.getDateOfBirth() != null))
		{
			updateProfileForm.setDateOfBirth(getSimpleDateFormat().format(customerData.getDateOfBirth()));
		}
		else
		{
			updateProfileForm.setDateOfBirth(StringUtils.EMPTY);
		}

		model.addAttribute(UPDATE_PROFILE_FORM, updateProfileForm);

		storeCmsPageInModel(model, getContentPageForLabelOrId(UPDATE_PROFILE_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(UPDATE_PROFILE_CMS_PAGE));

		model.addAttribute(BREADCRUMBS_ATTR, accountBreadcrumbBuilder.getBreadcrumbs(TEXT_ACCOUNT_PROFILE));
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
		return getViewForPage(model);
	}

	@RequestMapping(value = "/fs-update-profile", method = RequestMethod.POST)
	@RequireHardLogIn
	public String updateProfile(@ModelAttribute(UPDATE_PROFILE_FORM) final FSUpdateProfileForm updateProfileForm,
			final BindingResult bindingResult, final Model model,
			final RedirectAttributes redirectAttributes) throws CMSItemNotFoundException
	{
		getFsProfileValidator().validate(updateProfileForm, bindingResult);

		String returnAction = REDIRECT_TO_UPDATE_PROFILE;
		final CustomerData currentCustomerData = customerFacade.getCurrentCustomer();
		final CustomerData customerData = new CustomerData();
		customerData.setTitleCode(updateProfileForm.getTitleCode());
		customerData.setFirstName(updateProfileForm.getFirstName());
		customerData.setLastName(updateProfileForm.getLastName());
		customerData.setUid(currentCustomerData.getUid());
		customerData.setDisplayUid(currentCustomerData.getDisplayUid());

		if (StringUtils.isNotEmpty(currentCustomerData.getExternalId()))
		{
			customerData.setExternalId(currentCustomerData.getExternalId());
		}

		model.addAttribute(TITLE_DATA_ATTR, getUserFacade().getTitles());

		storeCmsPageInModel(model, getContentPageForLabelOrId(UPDATE_PROFILE_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(UPDATE_PROFILE_CMS_PAGE));

		if (bindingResult.hasErrors())
		{
			returnAction = setErrorMessagesAndCMSPage(model, UPDATE_PROFILE_CMS_PAGE);
		}
		else
		{
			try
			{
				customerData.setDateOfBirth(getSimpleDateFormat().parse(updateProfileForm.getDateOfBirth()));
				customerFacade.updateProfile(customerData);

				GlobalMessages.addFlashMessage(redirectAttributes, GlobalMessages.CONF_MESSAGES_HOLDER,
						"text.account.profile.confirmationUpdated", null);
			}
			catch (final DuplicateUidException e)
			{
				bindingResult.rejectValue("email", "registration.error.account.exists.title");
				returnAction = setErrorMessagesAndCMSPage(model, UPDATE_PROFILE_CMS_PAGE);
			}
			catch (ParseException e)
			{
				bindingResult.rejectValue("dateOfBirth", "profile.dateOfBirth.invalid");
				returnAction = setErrorMessagesAndCMSPage(model, UPDATE_PROFILE_CMS_PAGE);
			}
		}

		model.addAttribute(BREADCRUMBS_ATTR, accountBreadcrumbBuilder.getBreadcrumbs(TEXT_ACCOUNT_PROFILE));
		return returnAction;
	}

	@ExceptionHandler(CMSItemNotFoundException.class)
	public String handleCMSItemNotFoundException(final CMSItemNotFoundException exception, final HttpServletRequest request)
	{
		request.setAttribute("message", exception.getMessage());
		return FORWARD_PREFIX + "/404";
	}

	@ExceptionHandler(UnknownIdentifierException.class)
	public String handleUnknownIdentifierException(final UnknownIdentifierException exception, final HttpServletRequest request)
	{
		request.setAttribute("message", exception.getMessage());
		return FORWARD_PREFIX + "/404";
	}

	@RequestMapping(value = "/my-policies", method = RequestMethod.GET)
	@RequireHardLogIn
	public String myPolicies(final Model model) throws CMSItemNotFoundException
	{
		storeCmsPageInModel(model, getContentPageForLabelOrId(MY_POLICIES_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(MY_POLICIES_CMS_PAGE));
		model.addAttribute(BREADCRUMBS_ATTR, getAccountBreadcrumbBuilder().getBreadcrumbs("text.account.myPolicies"));
		model.addAttribute(META_ROBOTS, NOINDEX_NOFOLLOW);
		final List<InsurancePolicyData> policies = getInsurancePolicyFacade().getEffectivePoliciesForCurrentCustomer();
		model.addAttribute("policies", policies);
		return getViewForPage(model);
	}

	@RequestMapping(value = "/policy/" + POLICY_ID_PATH_VARIABLE_PATTERN + URL_SEPARATOR
			+ CONTRACT_ID_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
	@RequireHardLogIn
	public String policy(@PathVariable("policyId") final String policyId, @PathVariable("contractId") final String contractId,
			final HttpServletResponse response, final Model model,
			final RedirectAttributes redirectModel) throws CMSItemNotFoundException
	{
		try
		{
			final InsurancePolicyData policy = getInsurancePolicyFacade()
					.findEffectivePolicyForCurrentCustomerByPolicyAndContractId(policyId, contractId);
			if (policy == null)
			{
				throw new UnknownIdentifierException("Insurance policy with policy id " + policyId + " and contract id " + contractId + " doesn't exist.");
			}
			model.addAttribute("policy", policy);
		}
		catch (final UnknownIdentifierException e)
		{
			LOG.warn("Attempted to load a policy that does not exist or is not visible", e);
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "policy.item.not.found", null);
			return REDIRECT_TO_MY_POLICIES_PAGE;
		}
		storeCmsPageInModel(model, getContentPageForLabelOrId(POLICY_DETAILS_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(POLICY_DETAILS_CMS_PAGE));
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
		return getViewForPage(model);
	}

	@RequestMapping(value = "/my-financial-applications", method = RequestMethod.GET)
	@RequireHardLogIn
	public String myQuotes(final Model model) throws CMSItemNotFoundException
	{
		storeCmsPageInModel(model, getContentPageForLabelOrId(MY_QUOTES_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(MY_QUOTES_CMS_PAGE));
		model.addAttribute(BREADCRUMBS_ATTR, getAccountBreadcrumbBuilder().getBreadcrumbs("text.account.myQuotes"));
		model.addAttribute(META_ROBOTS, NOINDEX_NOFOLLOW);

		final List<CartData> carts = getCartFacade().getSavedCartsForCurrentUser();
		final List<InsuranceQuoteData> quotes = getQuoteFacade().getQuotesForCartList(carts);
		model.addAttribute("quotes", quotes);
		return getViewForPage(model);
	}

	@RequestMapping(value = "/my-insurance-claims", method = RequestMethod.GET)
	@RequireHardLogIn
	public String myClaims(final Model model) throws CMSItemNotFoundException
	{
		storeCmsPageInModel(model, getContentPageForLabelOrId(MY_CLAIMS_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(MY_CLAIMS_CMS_PAGE));
		model.addAttribute(BREADCRUMBS_ATTR, getAccountBreadcrumbBuilder().getBreadcrumbs("text.account.myClaims"));
		model.addAttribute(META_ROBOTS, NOINDEX_NOFOLLOW);

		final List<FSClaimData> claims = getFsClaimFacade().getClaimListForCurrentCustomer();
		model.addAttribute("claims", claims);

		return getViewForPage(model);
	}

	@RequestMapping(value = "/premium-calendar", method = RequestMethod.GET)
	@RequireHardLogIn
	public String premiumCalendar(final Model model) throws CMSItemNotFoundException
	{
		storeCmsPageInModel(model, getContentPageForLabelOrId(PREMIUM_CALENDAR_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(PREMIUM_CALENDAR_CMS_PAGE));
		model.addAttribute(BREADCRUMBS_ATTR, getAccountBreadcrumbBuilder().getBreadcrumbs("text.account.premiumCalendar"));
		model.addAttribute(META_ROBOTS, NOINDEX_NOFOLLOW);

		final List<InsurancePolicyData> policies = getInsurancePolicyFacade().getPoliciesAndPremiumsForCurrentCustomer();
		model.addAttribute("policies", policies);

		return getViewForPage(model);
	}
	
	@RequestMapping(value = "/pdf/print/" + POLICY_ID_PATH_VARIABLE_PATTERN + URL_SEPARATOR
			+ CONTRACT_ID_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
	public void pdfPrint(@PathVariable("policyId") final String policyId, @PathVariable("contractId") final String contractId,
			final HttpServletResponse response) throws IOException
	{
		final InsurancePolicyData insurancePolicy = getInsurancePolicyFacade()
				.findEffectivePolicyForCurrentCustomerByPolicyAndContractId(policyId, contractId);
		if (insurancePolicy != null)
		{
			LOG.info("Started pdf printing.");
			documentGenerationFacade.generate(DocumentGenerationFacade.PDF_DOCUMENT, insurancePolicy, response);
		}
	}

	/**
	 * Responsible for getting list of current customer's Bank account details based on account category selected and
	 * handle pagination and sorting of this list as well
	 *
	 * @param model
	 * @param currentPage
	 * @param pageSize
	 * @param showMode
	 * @param accountType
	 */
	@RequestMapping(value = "/bank-account-overview", method = RequestMethod.GET)
	@RequireHardLogIn
	public String fetchBankAccountDetails(final Model model,
			@RequestParam(required = false, defaultValue = "0") final int currentPage,
			@RequestParam(required = false, defaultValue = "0") int pageSize,
			@RequestParam(value = "show", defaultValue = "All", required = false) final ShowMode showMode,
			@RequestParam(value = "accountType", defaultValue = "all") final String accountType) throws CMSItemNotFoundException
	{
		if (ShowMode.All == showMode)
		{
			pageSize = MAX_PAGE_LIMIT;
		}

		final PaginationData paginationData = PaginatedSearchUtils.createPaginationData(pageSize, currentPage, true);
		final SearchPageData<FSBankAccountData> bankAccountDetails = getBankAccountFacade()
				.getBankAccountListForCurrentCustomer(accountType, paginationData);
		storeCmsPageInModel(model, getContentPageForLabelOrId(ACCOUNT_OVERVIEW_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(ACCOUNT_OVERVIEW_CMS_PAGE));
		model.addAttribute(META_ROBOTS, NOINDEX_NOFOLLOW);
		model.addAttribute("bankAccountDetails", bankAccountDetails);
		return getViewForPage(model);
	}

	protected ResourceBreadcrumbBuilder getAccountBreadcrumbBuilder()
	{
		return accountBreadcrumbBuilder;
	}

	public void setAccountBreadcrumbBuilder(final ResourceBreadcrumbBuilder accountBreadcrumbBuilder)
	{
		this.accountBreadcrumbBuilder = accountBreadcrumbBuilder;
	}

	protected InsurancePolicyFacade getInsurancePolicyFacade()
	{
		return insurancePolicyFacade;
	}

	protected FSProfileValidator getFsProfileValidator()
	{
		return fsProfileValidator;
	}

	protected InsuranceQuoteFacade getQuoteFacade()
	{
		return quoteFacade;
	}

	public void setQuoteFacade(final InsuranceQuoteFacade quoteFacade)
	{
		this.quoteFacade = quoteFacade;
	}

	protected InsuranceCartFacade getCartFacade()
	{
		return cartFacade;
	}

	public void setCartFacade(final InsuranceCartFacade cartFacade)
	{
		this.cartFacade = cartFacade;
	}

	protected FSClaimFacade getFsClaimFacade()
	{
		return fsClaimFacade;
	}

	public void setFsClaimFacade(final FSClaimFacade fsClaimFacade)
	{
		this.fsClaimFacade = fsClaimFacade;
	}

	protected FSBankAccountFacade getBankAccountFacade()
	{
		return bankAccountFacade;
	}

	public void setBankAccountFacade(final FSBankAccountFacade bankAccountFacade)
	{
		this.bankAccountFacade = bankAccountFacade;
	}

	protected String getDateFormatForDisplay()
	{
		return dateFormatForDisplay;
	}

	protected String setErrorMessagesAndCMSPage(final Model model, final String cmsPageLabelOrId) throws CMSItemNotFoundException
	{
		GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
		storeCmsPageInModel(model, getContentPageForLabelOrId(cmsPageLabelOrId));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(cmsPageLabelOrId));
		model.addAttribute(BREADCRUMBS_ATTR, accountBreadcrumbBuilder.getBreadcrumbs(TEXT_ACCOUNT_PROFILE));
		return getViewForPage(model);
	}

	protected SimpleDateFormat getSimpleDateFormat()
	{
		if (simpleDateFormat == null)
		{
			simpleDateFormat = new SimpleDateFormat(this.dateFormatForDisplay);
		}
		return simpleDateFormat;
	}

}

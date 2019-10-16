/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.commercefacades.insurance.data.InsurancePolicyData;
import de.hybris.platform.financialacceleratorstorefront.forms.FSCreateClaimForm;
import de.hybris.platform.financialfacades.facades.FSClaimFacade;
import de.hybris.platform.financialfacades.facades.InsurancePolicyFacade;
import de.hybris.platform.financialfacades.insurance.data.FSClaimData;
import de.hybris.platform.servicelayer.exceptions.UnknownIdentifierException;
import org.apache.log4j.Logger;
import org.springframework.context.annotation.Scope;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import org.apache.commons.lang.StringUtils;


@Controller
@Scope("tenant")
@RequestMapping("claims")
public class FSClaimsController extends AbstractPageController
{
	protected static final String CLAIMS_PAGE = "claimsPage";
	protected static final String CREATE_CLAIM_FORM = "createClaimForm";
	protected static final String CLAIMS_CONFIRMATION_PAGE = "claimConfirmation";
	private static final String REDIRECT_TO_MY_CLAIMS_PAGE = REDIRECT_PREFIX + "/my-account/my-insurance-claims";
	private static final String REDIRECT_TO_MY_POLICY_PAGE = REDIRECT_PREFIX + "/my-account/my-policies";
	private static final String CATEGORY_CODE_VARIABLE_PATTERN = "{categoryCode:.*}";
	private static final String REQUEST_ID_PATH_VARIABLE_PATTERN = "{requestId:.*}";
	private static final Logger LOG = Logger.getLogger(FSClaimsController.class);
	@Resource(name = "policyFacade")
	private InsurancePolicyFacade insurancePolicyFacade;
	@Resource(name = "fsClaimFacade")
	private FSClaimFacade fsClaimFacade;

	@ExceptionHandler(CMSItemNotFoundException.class)
	public String handleCMSItemNotFoundException(final CMSItemNotFoundException exception, final HttpServletRequest request)
	{
		request.setAttribute("message", exception.getMessage());
		return FORWARD_PREFIX + "/404";
	}

	@RequestMapping(value = "/" + CATEGORY_CODE_VARIABLE_PATTERN, method = RequestMethod.GET)
	@PreAuthorize("hasRole('ROLE_CUSTOMERGROUP')")
	public String claims(@PathVariable("categoryCode") final String categoryCode, final HttpServletResponse response,
			final Model model,
			final RedirectAttributes redirectModel) throws CMSItemNotFoundException
	{
		storeCmsPageInModel(model, getContentPageForLabelOrId(CLAIMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(CLAIMS_PAGE));
		try
		{
			if (!getFsClaimFacade().isClaimAllowedForCategory(categoryCode))
			{
				GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "claims.not.allowed", null);
				return REDIRECT_TO_MY_POLICY_PAGE;
			}

			final List<InsurancePolicyData> policies = getInsurancePolicyFacade()
					.getValidPoliciesByCategoryCodeForCurrentCustomer(categoryCode);
			model.addAttribute("policies", policies);
			if (!model.containsAttribute(CREATE_CLAIM_FORM))
			{
				model.addAttribute(CREATE_CLAIM_FORM, new FSCreateClaimForm());
			}
		}
		catch (final UnknownIdentifierException e)
		{
			LOG.warn("You must supply valid category.", e);
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "policy.item.not.found", null);
			return REDIRECT_TO_MY_POLICY_PAGE;
		}
		return getViewForPage(model);
	}

	@RequireHardLogIn
	@RequestMapping(value = "/create", method = RequestMethod.POST)
	public String createClaim(@ModelAttribute(CREATE_CLAIM_FORM) final FSCreateClaimForm createClaimForm,
			final RedirectAttributes redirectModel, final HttpServletRequest request)
	{
		if (!createClaimForm.getConfirmation() || StringUtils.isEmpty(createClaimForm.getPolicyId()) || StringUtils.isEmpty(createClaimForm.getContractId()))
		{
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER,
					"claims.entry.missing.values");
			return REDIRECT_PREFIX + ROOT;
		}

		final FSClaimData fsClaimData = getFsClaimFacade().createClaimForPolicy(createClaimForm.getPolicyId(), createClaimForm.getContractId());
		if (fsClaimData == null)
		{
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER,
					"claim.item.policy.not.found");
			return REDIRECT_PREFIX + ROOT;
		}
		redirectModel.addAttribute("requestId", fsClaimData.getRequestId());
		redirectModel.addAttribute("categoryCode", fsClaimData.getInsurancePolicy().getCategoryData().getCode());
		return REDIRECT_PREFIX + "/fsStepGroup/start";
	}

	@RequireHardLogIn
	@RequestMapping(value = "/confirmation/" + REQUEST_ID_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
	public String claimConfirmation(@PathVariable("requestId") final String requestId, final HttpServletResponse request,
			final Model model, final RedirectAttributes redirectModel) throws CMSItemNotFoundException
	{
		try
		{
			final FSClaimData claim = getFsClaimFacade().getClaimByRequestIdForCurrentUser(requestId);
			model.addAttribute("claim", claim);
		}
		catch (final UnknownIdentifierException e)
		{
			LOG.warn("Attempted to load a claim that does not exist or is not visible", e);
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "claim.item.not.found", null);
			return REDIRECT_TO_MY_CLAIMS_PAGE;
		}
		storeCmsPageInModel(model, getContentPageForLabelOrId(CLAIMS_CONFIRMATION_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(CLAIMS_CONFIRMATION_PAGE));
		return getViewForPage(model);
	}

	@RequireHardLogIn
	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public String deleteClaim(@RequestParam(value = "claimNumber", required = true) final String claimNumber,
			final RedirectAttributes redirectModel)
	{
		try
		{
			getFsClaimFacade().deleteClaim(claimNumber);
		}
		catch (final UnknownIdentifierException | IllegalArgumentException e)
		{
			LOG.warn("Attempted to delete claim is not successful", e);
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "claim.item.not.deleted", null);
		}

		return REDIRECT_TO_MY_CLAIMS_PAGE;
	}

	protected InsurancePolicyFacade getInsurancePolicyFacade()
	{
		return insurancePolicyFacade;
	}

	protected FSClaimFacade getFsClaimFacade()
	{
		return fsClaimFacade;
	}

}

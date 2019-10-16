/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.cms;

import de.hybris.platform.commercefacades.user.UserFacade;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import de.hybris.platform.financialfacades.facades.InsuranceCartFacade;
import de.hybris.platform.financialfacades.facades.InsurancePolicyFacade;
import de.hybris.platform.commercefacades.insurance.data.InsurancePolicyData;
import de.hybris.platform.financialservices.model.components.CMSViewPoliciesComponentModel;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;


@Controller("CMSViewPoliciesComponentController")
@Scope("tenant")
@RequestMapping(value = ControllerConstants.Actions.Cms.CMSViewPoliciesComponent)
public class CMSViewPoliciesComponentController extends SubstitutingCMSAddOnComponentController<CMSViewPoliciesComponentModel>
{
	@Resource(name = "userFacade")
	private UserFacade userFacade;

	@Resource(name = "policyFacade")
	private InsurancePolicyFacade insurancePolicyFacade;

	@Resource(name = "cartFacade")
	private InsuranceCartFacade cartFacade;

	@Override
	protected void fillModel(final HttpServletRequest request, final Model model, final CMSViewPoliciesComponentModel component)
	{
		if (getUserFacade().isAnonymousUser())
		{
			model.addAttribute("isAnonymousUser", true);
		}
		else
		{
			final List<InsurancePolicyData> policiesForCurrentCustomer = getInsurancePolicyFacade()
					.getEffectivePoliciesForCurrentCustomer();

			model.addAttribute("numDisplayablePolicies", component.getNumberOfPoliciesToDisplay());
			model.addAttribute("policies", policiesForCurrentCustomer);
			model.addAttribute("quotesExists",
					CollectionUtils.isNotEmpty(getCartFacade().getSavedCartsForCurrentUser()) && getCartFacade().hasEntries());
		}
	}

	protected UserFacade getUserFacade()
	{
		return userFacade;
	}

	protected InsurancePolicyFacade getInsurancePolicyFacade()
	{
		return insurancePolicyFacade;
	}

	protected InsuranceCartFacade getCartFacade()
	{
		return cartFacade;
	}
}

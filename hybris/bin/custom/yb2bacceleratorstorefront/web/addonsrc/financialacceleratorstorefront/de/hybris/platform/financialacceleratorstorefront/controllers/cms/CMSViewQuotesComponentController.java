/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.cms;

import de.hybris.platform.commercefacades.order.data.CartData;
import de.hybris.platform.commercefacades.quotation.InsuranceQuoteData;
import de.hybris.platform.commercefacades.user.UserFacade;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import de.hybris.platform.financialfacades.facades.InsuranceCartFacade;
import de.hybris.platform.financialfacades.facades.InsuranceQuoteFacade;
import de.hybris.platform.financialservices.model.components.CMSViewQuotesComponentModel;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import java.util.ArrayList;
import java.util.List;


@Controller("CMSViewQuotesComponentController")
@Scope("tenant")
@RequestMapping(value = ControllerConstants.Actions.Cms.CMSViewQuotesComponent)
public class CMSViewQuotesComponentController extends SubstitutingCMSAddOnComponentController<CMSViewQuotesComponentModel>
{
	@Resource(name = "userFacade")
	private UserFacade userFacade;

	@Resource(name = "insuranceQuoteFacade")
	private InsuranceQuoteFacade quoteFacade;

	@Resource(name = "cartFacade")
	private InsuranceCartFacade cartFacade;

	@Override
	protected void fillModel(final HttpServletRequest request, final Model model, final CMSViewQuotesComponentModel component)
	{
		if (getUserFacade().isAnonymousUser())
		{
			model.addAttribute("isAnonymousUser", true);
			return;
		}

		final CartData sessionCart = getCartFacade().getSessionCart();
		final List<CartData> cartDataList = new ArrayList<>();
		cartDataList.addAll(getCartFacade().getSavedCartsForCurrentUser());

		if (getCartFacade().hasEntries())
		{
			final boolean foundCode = cartDataList.stream().filter(cartData -> cartData.getCode() != null)
					.anyMatch(cartData -> cartData.getCode().equals(sessionCart.getCode()));

			if (!foundCode)
			{
				cartDataList.add(sessionCart);
			}
		}

		final List<InsuranceQuoteData> quotes = getQuoteFacade().getQuotesForCartList(cartDataList);
		model.addAttribute("quotes", quotes);
	}

	protected UserFacade getUserFacade()
	{
		return userFacade;
	}

	public void setUserFacade(final UserFacade userFacade)
	{
		this.userFacade = userFacade;
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
}

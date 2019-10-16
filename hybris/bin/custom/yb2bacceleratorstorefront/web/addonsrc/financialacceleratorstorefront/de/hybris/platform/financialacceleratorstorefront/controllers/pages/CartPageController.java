/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.pages;

import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.commercefacades.product.data.CategoryData;
import de.hybris.platform.commerceservices.order.CommerceCartModificationException;
import de.hybris.platform.constants.FinancialacceleratorstorefrontConstants;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import de.hybris.platform.financialacceleratorstorefront.controllers.imported.AcceleratorCartPageController;
import de.hybris.platform.financialfacades.facades.InsuranceCartFacade;
import org.apache.log4j.Logger;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.annotation.Resource;


/**
 * Controller for cart page
 */
public class CartPageController extends AcceleratorCartPageController
{

	public static final String HIDE_CART_BILLING_EVENTS_OPTIONS = "storefront.hide.cart.billing.events";
	private static final Logger LOGGER = Logger.getLogger(CartPageController.class);
	@Resource(name = "cartFacade")
	private InsuranceCartFacade cartFacade;

	/*
	 * Display the cart page
	 */
	@Override
	@RequestMapping(method = RequestMethod.GET)
	public String showCart(final Model model) throws CMSItemNotFoundException, CommerceCartModificationException //NOSONAR
	{
		LOGGER.debug("In the FinancialAcceleratorStoreFront GET for /cart");
		super.prepareDataForPage(model);
		final CategoryData categoryData = cartFacade.getSelectedInsuranceCategory();
		if (categoryData != null)
		{
			model.addAttribute(FinancialacceleratorstorefrontConstants.CATEGORY_NAME_MODEL_VAR, categoryData.getName());
			model.addAttribute(FinancialacceleratorstorefrontConstants.CATEGORY_CODE_MODEL_VAR, categoryData.getCode());
		}

		return ControllerConstants.Views.Pages.Cart.CartPage;
	}

	@ModelAttribute("hideCartBillingEvents")
	public boolean isHideCartBillingEvents()
	{
		return getSiteConfigService().getBoolean(HIDE_CART_BILLING_EVENTS_OPTIONS, true);
	}

}

/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.pages;

import de.hybris.platform.commercefacades.order.CartFacade;
import de.hybris.platform.commercefacades.order.data.CartData;
import de.hybris.platform.financialacceleratorstorefront.controllers.imported.AcceleratorCategoryPageController;
import org.springframework.web.bind.annotation.ModelAttribute;

import javax.annotation.Resource;


/**
 * Category Page Controller
 */
public class CategoryPageController extends AcceleratorCategoryPageController
{

	@Resource(name = "cartFacade")
	private CartFacade cartFacade;

	@ModelAttribute("cartData")
	public CartData getCartData()
	{
		return cartFacade.getSessionCart();
	}

}

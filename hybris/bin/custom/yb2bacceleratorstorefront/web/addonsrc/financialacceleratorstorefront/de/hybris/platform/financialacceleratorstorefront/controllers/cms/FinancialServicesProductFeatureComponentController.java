/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.cms;

import de.hybris.platform.acceleratorcms.model.components.ProductFeatureComponentModel;
import de.hybris.platform.commercefacades.product.ProductFacade;
import de.hybris.platform.commercefacades.product.ProductOption;
import de.hybris.platform.commercefacades.product.data.ProductData;
import de.hybris.platform.core.model.product.ProductModel;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.List;


/**
 * Controller for providing custom view for ProductFeatureComponent
 */
@Controller("FinancialServicesProductFeatureComponentController")
@RequestMapping(value = ControllerConstants.Actions.Cms.FinancialServicesProductFeatureComponent)
public class FinancialServicesProductFeatureComponentController
		extends SubstitutingCMSAddOnComponentController<ProductFeatureComponentModel>
{
	protected static final List<ProductOption> PRODUCT_OPTIONS = Arrays.asList(ProductOption.BASIC, ProductOption.PRICE,
			ProductOption.SUMMARY);

	@Resource(name = "productVariantFacade")
	private ProductFacade productFacade;

	@Override
	protected void fillModel(final HttpServletRequest request, final Model model, final ProductFeatureComponentModel component)
	{
		final ProductModel product = component.getProduct();
		if (product != null)
		{
			final ProductData productData = productFacade.getProductForCodeAndOptions(product.getCode(), PRODUCT_OPTIONS);
			model.addAttribute("product", productData);
		}
	}
}

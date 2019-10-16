/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.misc;

import de.hybris.platform.acceleratorstorefrontcommons.controllers.AbstractController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.commercefacades.order.data.CartModificationData;
import de.hybris.platform.commerceservices.order.CommerceCartModificationException;
import de.hybris.platform.commerceservices.order.CommerceSaveCartException;
import de.hybris.platform.financialacceleratorstorefront.constants.WebConstants;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import de.hybris.platform.financialacceleratorstorefront.controllers.exceptions.CommerceCartModificationUpperLimitReachedException;
import de.hybris.platform.financialfacades.facades.InsuranceCartFacade;
import de.hybris.platform.financialservices.enums.QuoteBindingState;
import de.hybris.platform.financialservices.enums.QuoteWorkflowStatus;
import de.hybris.platform.order.InvalidCartException;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Iterator;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;


/**
 * Controller for Add to Cart functionality which is not specific to a certain page.
 */
@Controller("InsuranceAddToCartController")
public class AddToCartController extends AbstractController
{

	/**
	 * This constant value dictates the quantity of the Insurance product to be added in the cart.
	 */
	protected static final String DEFAULT_BUNDLE_NO = "-1";
	protected static final String MODIFIED_CART_DATA = "modifiedCartData";
	protected static final String ERROR_MSG_TYPE = "errorMsg";
	protected static final long PRODUCT_QUANTITY = 1;
	private static final String CART_URL = "/cart";
	private static final String PRICE_CALCULATION_ERROR = "checkout.error.price.calculation";
	private static final String PRODUCT_ADDED = "basket.page.message.add";


	private static final Logger LOGGER = Logger.getLogger(AddToCartController.class);
	@Resource(name = "cartFacade")
	private InsuranceCartFacade cartFacade;

	@RequestMapping(value = "/cart/addSingleProduct", method = RequestMethod.POST)
	public String addToCart(@RequestParam("productCodePost") final String code, final Model model,
			@RequestParam(value = "removeCurrentProducts", defaultValue = "false") final boolean removeCurrentProducts,
			@RequestParam(value = "bundleNo", defaultValue = DEFAULT_BUNDLE_NO) final int bundleNo,
			@RequestParam(value = "bundleTemplateId") final String bundleTemplateId,  final HttpServletRequest request,
			final RedirectAttributes redirectModel)
	{
		try
		{
			final CartModificationData cartModification = cartFacade.addToCart(code, 1, bundleNo);
			cartFacade.saveCurrentUserCart();

			model.addAttribute(MODIFIED_CART_DATA, cartModification);
			model.addAttribute(WebConstants.ADD_TO_CART_SUCCESS, true);
		}
		catch (final CommerceCartModificationUpperLimitReachedException e)
		{
			LOGGER.warn(e);
			model.addAttribute(WebConstants.ADD_TO_CART_SUCCESS, false);
			model.addAttribute("CART_UPPER_LIMIT_REACHED", true);
		}
		catch (CommerceCartModificationException | CommerceSaveCartException e)
		{
			LOGGER.info("Product could not be added to the cart. " + e.getMessage(), e);
		}
		catch (final HttpClientErrorException | IllegalStateException e)
		{
			LOGGER.warn("Product could not be added to the cart." + e.getMessage());
			//should remove optional product from session cart
			cartFacade.removeProductFromCartForCode(code);
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER,
					PRICE_CALCULATION_ERROR);
			model.addAttribute(WebConstants.ADD_TO_CART_SUCCESS, false);
			return REDIRECT_PREFIX + ROOT;
		}
		GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER,
				PRODUCT_ADDED);
		return REDIRECT_PREFIX + CART_URL;
	}


	@RequestMapping(value = "/cart/addBundle", method = RequestMethod.POST, produces = "application/json")
	public String addToCartBundle(@RequestParam("productCodes") final List<String> productCodes,
			@RequestParam("bundleTemplateIds") final List<String> bundleTemplateIds,
			@RequestParam(value = "bundleNo", defaultValue = DEFAULT_BUNDLE_NO) int bundleNo, final Model model,
			@RequestParam(value = "clearOptionalProducts", defaultValue = "false") boolean clearOptionalProducts)
			throws CommerceSaveCartException
	{
		if (cartFacade.hasSessionCart() && cartFacade.getSessionCart().getInsuranceQuote() != null &&
				(QuoteBindingState.BIND.equals(cartFacade.getSessionCart().getInsuranceQuote().getState()) ||
						QuoteWorkflowStatus.ERROR.equals(cartFacade.getSessionCart().getInsuranceQuote().getQuoteWorkflowStatus())))
		{
			cartFacade.removeSessionCart();
		}

		//This is temporary implementation to add multiple products to the cart in a single request. In future this controller
		// method should delegate the method call to facade by passing list of productids and corresponding bundleids.
		// Proper validation and Exception handling should be done based on the contract with facade.
		if (validateAddToCartRequestParams(productCodes, bundleTemplateIds))
		{
			if (clearOptionalProducts)
			{
				cartFacade.removeOptionalProductsFromCart();
			}
			final Iterator productIdIterator = productCodes.iterator();
			final Iterator bundleId = bundleTemplateIds.iterator();

			while (productIdIterator.hasNext() && bundleId.hasNext())
			{
				final String productId = productIdIterator.next().toString();

				try
				{
					final CartModificationData cartModification = cartFacade.addToCart(bundleId.next().toString(), productId, 1);
					cartFacade.saveCurrentUserCart();
					model.addAttribute(MODIFIED_CART_DATA, cartModification);

					if (cartModification.getQuantityAdded() == 0L)
					{
						GlobalMessages.addErrorMessage(model,
								"basket.information.quantity.noItemsAdded." + cartModification.getStatusCode());
						model.addAttribute(ERROR_MSG_TYPE,
								"basket.information.quantity.noItemsAdded." + cartModification.getStatusCode());
					}
					else if (cartModification.getQuantityAdded() < PRODUCT_QUANTITY)
					{
						GlobalMessages.addErrorMessage(model,
								"basket.information.quantity.reducedNumberOfItemsAdded." + cartModification.getStatusCode());
						model.addAttribute(ERROR_MSG_TYPE,
								"basket.information.quantity.reducedNumberOfItemsAdded." + cartModification.getStatusCode());
					}
				}
				catch (final CommerceCartModificationException ex)
				{
					LOGGER.debug(ex);

					model.addAttribute(WebConstants.ADD_TO_CART_SUCCESS, false);
					model.addAttribute(WebConstants.CART_UPPER_LIMIT_REACHED, true);

					populateProductGroupInformation(productId, productCodes.size() == 1, model);

					return ControllerConstants.Views.Fragments.Cart.AddToCartFragment;
				}
				catch (final CommerceSaveCartException e)
				{
					LOGGER.error("Save cart error." + e.getMessage());
				}
			}
		}

		model.addAttribute(WebConstants.ADD_TO_CART_SUCCESS, true);
		return ControllerConstants.Views.Fragments.Cart.AddToCartFragment;
	}

	// Temporary implementation to validate the lists of productCodes and bundleTemplateIds whether they
	//   - are not null or empty lists
	//   - have no null or "" elements
	//   - the product codes size must be equal or less than bundle templates id size.
	//
	//  Later on this should be:
	//	   - moved to the facade layer
	//	   - extended with additional validation that checks the elements of the two lists are consistent (Product belongs to
	// BundleTample)
	protected boolean validateAddToCartRequestParams(final List<String> productCodes, final List<String> bundleTemplateIds)
	{
		return validateAddToCartParameterList(productCodes) && validateAddToCartParameterList(bundleTemplateIds) && productCodes
				.size() <= bundleTemplateIds.size();
	}

	protected boolean validateAddToCartParameterList(final List<String> params)
	{
		return CollectionUtils.isNotEmpty(params) && !params.contains(null) && !params.contains(StringUtils.EMPTY);
	}

	// If the adding product in the same default category as product already in the cart,
	// it should be added without giving warning.
	private void populateProductGroupInformation(final String productId, final boolean isSingleProduct, final Model model)
	{
		try
		{
			final boolean sameProductGroup = cartFacade.isSameInsuranceInSessionCart(productId);
			model.addAttribute(WebConstants.SAME_PRODUCT_GROUP, sameProductGroup);

			if (sameProductGroup)
			{
				model.addAttribute(WebConstants.RECALCULATE_ONLY,
						cartFacade.getProductOrderEntry(productId) != null && isSingleProduct);
			}
		}
		catch (final InvalidCartException e)
		{
			LOGGER.error(e);
			model.addAttribute(WebConstants.ADD_TO_CART_SUCCESS, false);
			model.addAttribute(WebConstants.CART_UPPER_LIMIT_REACHED, false);
		}
	}

}

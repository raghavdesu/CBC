/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.pages;

import de.hybris.platform.acceleratorservices.controllers.page.PageType;
import de.hybris.platform.acceleratorstorefrontcommons.checkout.steps.CheckoutStep;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.AbstractController;
import de.hybris.platform.catalog.enums.ConfiguratorType;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.commercefacades.order.data.CartData;
import de.hybris.platform.commercefacades.order.data.CartModificationData;
import de.hybris.platform.commercefacades.order.data.ConfigurationInfoData;
import de.hybris.platform.commercefacades.order.data.OrderEntryData;
import de.hybris.platform.commercefacades.product.PriceDataFactory;
import de.hybris.platform.commercefacades.product.ProductFacade;
import de.hybris.platform.commercefacades.product.ProductOption;
import de.hybris.platform.commercefacades.product.data.PriceData;
import de.hybris.platform.commercefacades.product.data.PriceDataType;
import de.hybris.platform.commercefacades.product.data.ProductData;
import de.hybris.platform.commerceservices.order.CommerceCartModificationException;
import de.hybris.platform.commerceservices.url.UrlResolver;
import de.hybris.platform.constants.FinancialacceleratorstorefrontConstants;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import de.hybris.platform.financialacceleratorstorefront.controllers.pages.checkout.steps.AbstractInsuranceCheckoutStepController;
import de.hybris.platform.financialfacades.facades.InsuranceCartFacade;
import de.hybris.platform.financialfacades.util.InsuranceCheckoutHelper;
import de.hybris.platform.servicelayer.exceptions.UnknownIdentifierException;
import de.hybris.platform.subscriptionfacades.data.OneTimeChargeEntryData;
import de.hybris.platform.subscriptionfacades.data.SubscriptionPricePlanData;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.util.*;


/**
 * Controller for Product Configuration Page
 */
@Controller
public class ProductConfigurationController extends AbstractInsuranceCheckoutStepController
{
	protected static final String YFORMCONFIGURATOR_TYPE = "YFORM";
	protected static final String PAGE_LABEL = "configure/" + YFORMCONFIGURATOR_TYPE;
	protected static final String DEFAULT_ENTRY_NUMBER = "-1";
	protected static final String SUCCESSFUL_MODIFICATION_CODE = "success";
	private static final Logger LOGGER = Logger.getLogger(ProductConfigurationController.class);
	private static final String CONFIGURE_PRODUCT = "configure-product";
	@Resource
	private ProductFacade productFacade;
	@Resource
	private InsuranceCartFacade cartFacade;
	@Resource
	private UrlResolver<ProductData> productDataUrlResolver;
	@Resource
	private PriceDataFactory priceDataFactory;
	@Resource
	private InsuranceCheckoutHelper insuranceCheckoutHelper;

	@ExceptionHandler(UnknownIdentifierException.class)
	public String handleUnknownIdentifierException(final UnknownIdentifierException exception, final HttpServletRequest request)
	{
		request.setAttribute("message", exception.getMessage());
		return AbstractController.FORWARD_PREFIX + "/404";
	}

	@RequestMapping(value = "/**/p/{productCode}/configuratorPage/" + YFORMCONFIGURATOR_TYPE, method = RequestMethod.GET)
	public String configureProduct(@PathVariable("productCode") final String productCode, HttpServletRequest request,
			HttpServletResponse response, final Model model, final RedirectAttributes redirectAttributes)
			throws CMSItemNotFoundException, UnsupportedEncodingException //NOSONAR
	{
		final ProductData productData = getProductDataForCode(productCode);

		final String redirection = getRedirectionUrl(request, response, productData);
		if (redirection != null)
		{
			return redirection;
		}

		List<ConfigurationInfoData> configurations = new ArrayList<>();
		boolean currentProductInCart = false;

		if (cartFacade.hasEntries())
		{
			final OrderEntryData productEntry = cartFacade.getProductOrderEntry(productCode);

			// If the Product was already added to the cart, get saved configuration from the cart
			if (productEntry != null && CollectionUtils.isNotEmpty(productEntry.getConfigurationInfos()))
			{
				currentProductInCart = true;
				configurations = productEntry.getConfigurationInfos();
				model.addAttribute("entryNumber", productEntry.getEntryNumber());
			}
		}

		// If configurations have not been obtained or the product is not in the cart, try to fetch fresh configuration
		if (CollectionUtils.isEmpty(configurations))
		{
			configurations = getProductFacade().getConfiguratorSettingsForCode(productCode);
		}

		// In case of non-matching configurator, return 404
		if (!hasYFormConfiguratorType(configurations))
		{
			return FORWARD_PREFIX + "/404";
		}

		storePageData(productData, configurations, currentProductInCart, model);
		setCheckoutStepLinksForModel(model, getCheckoutStep());
		return ControllerConstants.Views.Pages.Checkout.ProductConfigurationPage;
	}

	@RequestMapping(value = "/updateConfiguration/" + YFORMCONFIGURATOR_TYPE, method = RequestMethod.POST)
	public String updateConfigurationInEntry(@RequestParam("productCodes") final String productCode,
			@RequestParam("bundleTemplateIds") final String bundleTemplateId,
			@RequestParam(value = "entryNumber", defaultValue = DEFAULT_ENTRY_NUMBER) final int entryNumber,
			HttpServletRequest request, final Model model,
			final RedirectAttributes redirectAttributes) throws CommerceCartModificationException // NOSONAR
	{
		final List<CartModificationData> cartModificationDatas = new ArrayList<>();

		// entryNumber was not supplied - the product doesn't exist in the cart and it is a recalculation request
		if (entryNumber < 0)
		{
			final List<ProductData> products = getCartFacade().getQuotationProductBundleForProductCode(productCode);

			model.addAttribute("configuredProducts", products);
			model.addAttribute("totalPrice", getPriceDataFromValue(calculateTotalPrice(products)));
			final List<ConfigurationInfoData> configurations = getProductFacade().getConfiguratorSettingsForCode(productCode);
			model.addAttribute("configurationDetails", insuranceCheckoutHelper.generateConfigurationItemValues(configurations));
		}
		// entryNumber was supplied - indicating that the product exists in the cart
		else
		{
			try
			{
				final OrderEntryData orderEntry = getOrderEntry(entryNumber, cartFacade.getSessionCart());

				if (orderEntry != null)
				{
					cartModificationDatas.add(cartFacade.updateCartEntry(orderEntry));
				}
			}
			catch (CommerceCartModificationException e)
			{
				LOGGER.warn("Couldn't update product [" + sanitize(productCode) + "] configuration.", e);
			}

			if (cartModificationDatas.stream().filter(
					modification -> !SUCCESSFUL_MODIFICATION_CODE.equals(modification.getStatusCode())).findFirst().isPresent())
			{
				model.addAttribute("error", true);
			}

			model.addAttribute("cartData", cartFacade.getSessionCart());
		}

		return ControllerConstants.Views.Fragments.Cart.CartDisplayFragment;
	}

	private String getRedirectionUrl(final HttpServletRequest request, final HttpServletResponse response,
			final ProductData productData) throws UnsupportedEncodingException
	{
		final String redirection = checkRequestUrl(request, response,
				productDataUrlResolver.resolve(productData) + "/configuratorPage/" + YFORMCONFIGURATOR_TYPE);
		if (StringUtils.isNotEmpty(redirection))
		{
			return redirection;
		}
		return null;
	}

	/**
	 * Choose cover redirect to the Product's default product page if available, or else redirect to Home.
	 */
	@RequestMapping(value = "/**/p/chooseProduct", method = RequestMethod.GET)
	public String redirectToconfigureProductPage(final HttpServletRequest request, final HttpServletResponse response)
			throws CommerceCartModificationException, IOException, ServletException // NOSONAR
	{
		final String redirectUrlOrCart = ROOT;

		if (!cartFacade.hasEntries())
		{
			return REDIRECT_PREFIX + redirectUrlOrCart;
		}

		final CartData sessionCart = cartFacade.getSessionCart();
		for (final OrderEntryData entryData : sessionCart.getEntries())
		{
			// The redirect URL is at this stage picking from the last item in the cart.
			// This should be improved later on when we start to have multiple bundles in the cart from different
			// categories or products.
			final String productCode = entryData.getProduct().getCode();

			if (productCode != null && StringUtils.isNotEmpty(productCode))
			{
				final String redirection = getRedirectionUrl(request, response, entryData.getProduct());

				if (redirection != null)
				{
					return redirection;
				}
			}
		}
		return REDIRECT_PREFIX + redirectUrlOrCart;
	}

	@Override
	public String enterStep(final Model model, final RedirectAttributes redirectAttributes)
			throws CMSItemNotFoundException, CommerceCartModificationException // NOSONAR
	{
		return FORWARD_PREFIX + "/404";
	}

	protected OrderEntryData getOrderEntry(final int entryNumber, final CartData cart) throws CommerceCartModificationException
	{
		final List<OrderEntryData> entries = cart.getEntries();
		if (entries == null)
		{
			throw new CommerceCartModificationException("Cart is empty");
		}
		try
		{
			return entries.stream().filter(e -> e != null).filter(e -> e.getEntryNumber() == entryNumber).findAny().get();
		}
		catch (final NoSuchElementException e)
		{
			throw new CommerceCartModificationException("Cart entry #" + entryNumber + " does not exist", e);
		}
	}

	private ProductData getProductDataForCode(final String productCode)
	{
		final Set<ProductOption> options = new HashSet<>(
				Arrays.asList(ProductOption.BASIC, ProductOption.URL, ProductOption.PRICE, ProductOption.SUMMARY,
						ProductOption.DESCRIPTION, ProductOption.CATEGORIES, ProductOption.BUNDLE));

		return getProductFacade().getProductForCodeAndOptions(productCode, options);
	}

	private boolean hasYFormConfiguratorType(final List<ConfigurationInfoData> config)
	{
		return (CollectionUtils.isNotEmpty(config) && ConfiguratorType.YFORM.equals(config.get(0).getConfiguratorType()));
	}

	protected void storePageData(final ProductData productData, final List<ConfigurationInfoData> configuration,
			boolean currentProductInTheCart, final Model model) throws CMSItemNotFoundException
	{
		model.addAttribute("product", productData);
		model.addAttribute("pageType", PageType.PRODUCT.name());
		storeCmsPageInModel(model, getContentPageForLabelOrId(PAGE_LABEL));
		model.addAttribute("currentProductInTheCart", currentProductInTheCart);

		if (!currentProductInTheCart)
		{
			model.addAttribute(FinancialacceleratorstorefrontConstants.CATEGORY_NAME_MODEL_VAR,
					productData.getDefaultCategory().getName());

			if (configuration.stream().anyMatch(config -> StringUtils.isNotBlank(config.getConfigurationYForm().getContent())))
			{
				final List<ProductData> products = getCartFacade().getQuotationProductBundleForProductCode(productData.getCode());
				model.addAttribute("configuredProducts", products);
				model.addAttribute("totalPrice", getPriceDataFromValue(calculateTotalPrice(products)));
				model.addAttribute("configurationDetails", insuranceCheckoutHelper.generateConfigurationItemValues(configuration));
			}
		}
		else
		{
			model.addAttribute("cartData", cartFacade.getSessionCart());
		}
		model.addAttribute("configurations", insuranceCheckoutHelper.populateYFormConfigurationInlineHTML(configuration));
	}

	protected ProductFacade getProductFacade()
	{
		return productFacade;
	}

	private PriceData getPriceDataFromValue(final double value)
	{
		return priceDataFactory.create(PriceDataType.BUY, BigDecimal.valueOf(value), getCurrentCurrency().getIsocode());
	}

	private double calculateTotalPrice(final List<ProductData> products)
	{
		double totalPrice = 0;

		for (final ProductData p : products)
		{
			final List<OneTimeChargeEntryData> charges = ((SubscriptionPricePlanData) p.getPrice()).getOneTimeChargeEntries();

			if (CollectionUtils.isNotEmpty(charges))
			{
				totalPrice = totalPrice + charges.get(0).getPrice().getValue().doubleValue();
			}
		}
		return totalPrice;
	}

	@Override
	protected CheckoutStep getCheckoutStep()
	{
		return getCheckoutStep(CONFIGURE_PRODUCT);
	}

	@Override
	public String back(final RedirectAttributes redirectAttributes)
	{
		return getCheckoutStep().previousStep();
	}

	@Override
	public String next(final RedirectAttributes redirectAttributes)
	{
		return getCheckoutStep().nextStep();
	}
}

/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers;

import de.hybris.platform.financialservices.model.components.*;


/**
 * ControllerConstants
 */
public interface ControllerConstants // NOSONAR
{
	String ADDON_PREFIX = "addon:/financialacceleratorstorefront/";

	/**
	 * Class with view name constants
	 */
	interface Views
	{
		interface Cms // NOSONAR
		{
			String ComponentPrefix = "cms/"; // NOSONAR
		}

		interface Pages
		{

			interface Cart // NOSONAR
			{
				String CartPage = ADDON_PREFIX + "pages/cart/cartPage";// NOSONAR
			}

			interface Checkout // NOSONAR
			{
				String CheckoutConfirmationPage = ADDON_PREFIX + "pages/checkout/checkoutConfirmationPage";// NOSONAR
				String CheckoutLoginPage = ADDON_PREFIX + "pages/checkout/checkoutLoginPage";//NOSONAR
				String ProductConfigurationPage = ADDON_PREFIX + "pages/checkout/productConfigurationPage";// NOSONAR
				String LegalInformationPage = ADDON_PREFIX + "pages/checkout/legalInformationPage";// NOSONAR
				String UserIdentificationPage = ADDON_PREFIX + "pages/checkout/userIdentificationPage";// NOSONAR
			}

			interface Agent // NOSONAR
			{
				String AgentList = ADDON_PREFIX + "pages/find-agent/findAgentList";// NOSONAR
				String ContactAgentForm = ADDON_PREFIX + "pages/find-agent/contactAgentForm";// NOSONAR
			}

			interface MultiStepCheckout // NOSONAR
			{
				String GetFormPage = ADDON_PREFIX + "pages/checkout/multi/formPage";// NOSONAR
				String QuoteReviewPage = ADDON_PREFIX + "pages/checkout/multi/quoteReviewPage";// NOSONAR
				String CheckoutSummaryPage = ADDON_PREFIX + "pages/checkout/multi/checkoutSummaryPage";// NOSONAR
				String HostedOrderPageErrorPage = ADDON_PREFIX + "pages/checkout/multi/hostedOrderPageErrorPage";// NOSONAR
				String HostedOrderPostPage = ADDON_PREFIX + "pages/checkout/multi/hostedOrderPostPage";// NOSONAR
				String SilentOrderPostPage = ADDON_PREFIX + "pages/checkout/multi/silentOrderPostPage";// NOSONAR

				// Carried from B2C Checkout
				String AddPaymentMethodPage = "pages/checkout/multi/addPaymentMethodPage";// NOSONAR
				String AddEditDeliveryAddressPage = "pages/checkout/multi/addEditDeliveryAddressPage";// NOSONAR
				String ChooseDeliveryMethodPage = "pages/checkout/multi/chooseDeliveryMethodPage";// NOSONAR
				String ChoosePickupLocationPage = "pages/checkout/multi/choosePickupLocationPage";// NOSONAR
			}

			interface StoreFinder //NOSONAR
			{
				String StoreFinderSearchPage = ADDON_PREFIX + "pages/storeFinder/storeFinderSearchPage"; //NOSONAR
				String StoreFinderDetailsPage = ADDON_PREFIX + "pages/storeFinder/storeFinderDetailsPage"; //NOSONAR
				String StoreFinderViewMapPage = ADDON_PREFIX + "pages/storeFinder/storeFinderViewMapPage"; //NOSONAR
			}

			interface Account // NOSONAR
			{
				String AccountLoginPage = ADDON_PREFIX + "pages/account/accountLoginPage"; //NOSONAR
			}

		}

		interface Fragments
		{
			interface Cart // NOSONAR
			{
				String AddToCartFragment = ADDON_PREFIX + "fragments/cart/addToCartFragment";// NOSONAR
				String CheckFormData = ADDON_PREFIX + "fragments/cart/checkFormData";// NOSONAR
				String CartDisplayFragment = ADDON_PREFIX + "fragments/cart/cartDisplay";// NOSONAR
			}

			interface Catalog // NOSONAR
			{
				String SwitchComparisonTabFragment = ADDON_PREFIX + "fragments/catalog/switchComparisonTabFragment";// NOSONAR
			}

			interface Checkout // NOSONAR
			{
				String TermsAndConditionsPopup = ADDON_PREFIX + "fragments/checkout/termsAndConditionsPopup";// NOSONAR
				String BillingAddressForm = ADDON_PREFIX + "fragments/checkout/billingAddressForm";// NOSONAR
			}

			interface Inbox // NOSONAR
			{
				String SiteMessagesFragment = ADDON_PREFIX + "fragments/inbox/siteMessagesFragment"; // NOSONAR
			}
		}
	}

	interface Actions
	{
		interface Cms // NOSONAR
		{
			String _Prefix = "/view/";// NOSONAR
			String _Suffix = "Controller";// NOSONAR

			/**
			 * CMS components that have specific handlers
			 */
			String CMSMultiComparisonTabContainer = _Prefix + CMSMultiComparisonTabContainerModel._TYPECODE + _Suffix; // NOSONAR
			String CMSViewPoliciesComponent = _Prefix + CMSViewPoliciesComponentModel._TYPECODE + _Suffix; // NOSONAR
			String CMSViewQuotesComponent = _Prefix + CMSViewQuotesComponentModel._TYPECODE + _Suffix; // NOSONAR
			String CMSAllOurServicesComponent = _Prefix + CMSAllOurServicesComponentModel._TYPECODE + _Suffix; // NOSONAR
			String CMSLinkImageComponent = _Prefix + CMSLinkImageComponentModel._TYPECODE + _Suffix; // NOSONAR
			String ComparisonPanelCMSComponent = _Prefix + ComparisonPanelCMSComponentModel._TYPECODE + _Suffix; // NOSONAR
			String CMSAgentRootComponent = _Prefix + CMSAgentRootComponentModel._TYPECODE + _Suffix; // NOSONAR
			String EnrichedResponsiveBanerComponent =                                        // NOSONAR
					_Prefix + EnrichedResponsiveBannerComponentModel._TYPECODE + _Suffix; // NOSONAR
			String FinancialServicesProductFeatureComponent =                            // NOSONAR
					_Prefix + FinancialServicesProductFeatureComponentModel._TYPECODE + _Suffix; // NOSONAR
		}
	}
}

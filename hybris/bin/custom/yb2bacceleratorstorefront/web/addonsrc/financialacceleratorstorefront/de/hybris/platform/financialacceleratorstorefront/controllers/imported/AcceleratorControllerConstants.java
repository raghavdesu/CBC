/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.imported;

import de.hybris.platform.acceleratorcms.model.components.*;
import de.hybris.platform.cms2.model.contents.components.CMSLinkComponentModel;
import de.hybris.platform.cms2lib.model.components.ProductCarouselComponentModel;


/**
 */
public interface AcceleratorControllerConstants //NOSONAR
{
	/**
	 * Class with action name constants
	 */
	interface Actions
	{
		interface Cms //NOSONAR
		{
			String _Prefix = "/view/"; //NOSONAR
			String _Suffix = "Controller"; //NOSONAR

			/**
			 * Default CMS component controller
			 */
			String DefaultCMSComponent = _Prefix + "DefaultCMSComponentController"; //NOSONAR

			/**
			 * CMS components that have specific handlers
			 */
			String PurchasedCategorySuggestionComponent =                                 //NOSONAR
					_Prefix + PurchasedCategorySuggestionComponentModel._TYPECODE + _Suffix; //NOSONAR
			String CartSuggestionComponent = _Prefix + CartSuggestionComponentModel._TYPECODE + _Suffix; //NOSONAR
			String ProductReferencesComponent = _Prefix + ProductReferencesComponentModel._TYPECODE + _Suffix; //NOSONAR
			String ProductCarouselComponent = _Prefix + ProductCarouselComponentModel._TYPECODE + _Suffix; //NOSONAR
			String MiniCartComponent = _Prefix + MiniCartComponentModel._TYPECODE + _Suffix;//NOSONAR
			String ProductFeatureComponent = _Prefix + ProductFeatureComponentModel._TYPECODE + _Suffix; //NOSONAR
			String CategoryFeatureComponent = _Prefix + CategoryFeatureComponentModel._TYPECODE + _Suffix; //NOSONAR
			String NavigationBarComponent = _Prefix + NavigationBarComponentModel._TYPECODE + _Suffix; //NOSONAR
			String CMSLinkComponent = _Prefix + CMSLinkComponentModel._TYPECODE + _Suffix; //NOSONAR
			String DynamicBannerComponent = _Prefix + DynamicBannerComponentModel._TYPECODE + _Suffix; //NOSONAR
			String SubCategoryListComponent = _Prefix + SubCategoryListComponentModel._TYPECODE + _Suffix; //NOSONAR
			String SimpleResponsiveBannerComponent = _Prefix + SimpleResponsiveBannerComponentModel._TYPECODE + _Suffix; //NOSONAR
		}
	}

	/**
	 * Class with view name constants
	 */
	interface Views
	{
		interface Cms //NOSONAR
		{
			String ComponentPrefix = "cms/"; //NOSONAR
		}

		interface Pages
		{
			interface Account //NOSONAR
			{
				String AccountLoginPage = "pages/account/accountLoginPage"; //NOSONAR
				String AccountHomePage = "pages/account/accountHomePage"; //NOSONAR
				String AccountOrderHistoryPage = "pages/account/accountOrderHistoryPage"; //NOSONAR
				String AccountOrderPage = "pages/account/accountOrderPage"; //NOSONAR
				String AccountProfilePage = "pages/account/accountProfilePage"; //NOSONAR
				String AccountProfileEditPage = "pages/account/accountProfileEditPage"; //NOSONAR
				String AccountProfileEmailEditPage = "pages/account/accountProfileEmailEditPage"; //NOSONAR
				String AccountChangePasswordPage = "pages/account/accountChangePasswordPage"; //NOSONAR
				String AccountAddressBookPage = "pages/account/accountAddressBookPage"; //NOSONAR
				String AccountEditAddressPage = "pages/account/accountEditAddressPage"; //NOSONAR
				String AccountPaymentInfoPage = "pages/account/accountPaymentInfoPage"; //NOSONAR
				String AccountRegisterPage = "pages/account/accountRegisterPage"; //NOSONAR
			}

			interface Checkout //NOSONAR
			{
				String CheckoutRegisterPage = "pages/checkout/checkoutRegisterPage"; //NOSONAR
				String CheckoutConfirmationPage = "pages/checkout/checkoutConfirmationPage"; //NOSONAR
				String CheckoutLoginPage = "pages/checkout/checkoutLoginPage"; //NOSONAR
			}

			interface Password //NOSONAR
			{
				String PasswordResetChangePage = "pages/password/passwordResetChangePage"; //NOSONAR
				String PasswordResetRequest = "pages/password/passwordResetRequestPage"; //NOSONAR
				String PasswordResetRequestConfirmation = "pages/password/passwordResetRequestConfirmationPage"; //NOSONAR
			}

			interface Error //NOSONAR
			{
				String ErrorNotFoundPage = "pages/error/errorNotFoundPage"; //NOSONAR
			}

			interface Cart //NOSONAR
			{
				String CartPage = "pages/cart/cartPage"; //NOSONAR
			}

			interface StoreFinder //NOSONAR
			{
				String StoreFinderSearchPage = "pages/storeFinder/storeFinderSearchPage"; //NOSONAR
				String StoreFinderDetailsPage = "pages/storeFinder/storeFinderDetailsPage"; //NOSONAR
				String StoreFinderViewMapPage = "pages/storeFinder/storeFinderViewMapPage"; //NOSONAR
			}

			interface Misc //NOSONAR
			{
				String MiscRobotsPage = "pages/misc/miscRobotsPage"; //NOSONAR
				String MiscSiteMapPage = "pages/misc/miscSiteMapPage"; //NOSONAR
			}

			interface Guest //NOSONAR
			{
				String GuestOrderPage = "pages/guest/guestOrderPage"; //NOSONAR
				String GuestOrderErrorPage = "pages/guest/guestOrderErrorPage"; //NOSONAR
			}

			interface Product //NOSONAR
			{
				String WriteReview = "pages/product/writeReview"; //NOSONAR
			}
		}

		interface Fragments
		{
			interface Cart //NOSONAR
			{
				String AddToCartPopup = "fragments/cart/addToCartPopup"; //NOSONAR
				String MiniCartPanel = "fragments/cart/miniCartPanel"; //NOSONAR
				String MiniCartErrorPanel = "fragments/cart/miniCartErrorPanel"; //NOSONAR
				String CartPopup = "fragments/cart/cartPopup"; //NOSONAR
			}

			interface Account //NOSONAR
			{
				String CountryAddressForm = "fragments/address/countryAddressForm"; //NOSONAR
			}

			interface Checkout //NOSONAR
			{
				String TermsAndConditionsPopup = "acceleratoraddon/web/webroot/WEB-INF/views/mobile/fragments/checkout/termsAndConditionsPopup"; //NOSONAR
				String BillingAddressForm = "acceleratoraddon/web/webroot/WEB-INF/views/mobile/fragments/checkout/billingAddressForm"; //NOSONAR
			}

			interface Password //NOSONAR
			{
				String PasswordResetRequestPopup = "fragments/password/passwordResetRequestPopup"; //NOSONAR
				String ForgotPasswordValidationMessage = "fragments/password/forgotPasswordValidationMessage"; //NOSONAR
			}

			interface Product //NOSONAR
			{
				String QuickViewPopup = "fragments/product/quickViewPopup"; //NOSONAR
				String ZoomImagesPopup = "fragments/product/zoomImagesPopup"; //NOSONAR
				String ReviewsTab = "fragments/product/reviewsTab"; //NOSONAR
				String StorePickupSearchResults = "fragments/product/storePickupSearchResults"; //NOSONAR
			}
		}
	}
}

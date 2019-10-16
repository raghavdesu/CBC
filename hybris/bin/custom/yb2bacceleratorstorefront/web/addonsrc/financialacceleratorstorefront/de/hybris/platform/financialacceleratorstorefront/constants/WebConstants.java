/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.constants;

/**
 * Global class for all Insuranceacceleratorstorefront web constants. You can add global constants for your extension
 * into this class.
 */
public final class WebConstants
{

	public static final String CART_UPPER_LIMIT_REACHED = "cartUpperLimitReached";
	public static final String ADD_TO_CART_SUCCESS = "addToCartSuccess";
	public static final String SAME_PRODUCT_GROUP = "sameProductGroup";
	public static final String RECALCULATE_ONLY = "recalculateOnly";

	public static final String QUERY_STRING_SEPERATOR = "?";
	public static final String QUERY_STRING_VIEWSTATUS = "viewStatus=";
	public static final String EDIT_VIEWSTATUS = "edit";
	public static final String VIEW_VIEWSTATUS = "view";

	public static final String MODEL_KEY_ADDITIONAL_BREADCRUMB = "additionalBreadcrumb";
	public static final String BREADCRUMBS_KEY = "breadcrumbs";
	public static final String CONTINUE_URL = "session_continue_url";
	public static final String CART_RESTORATION = "cart_restoration";
	public static final String ANONYMOUS_CHECKOUT = "anonymous_checkout";
	public static final String URL_ENCODING_ATTRIBUTES = "encodingAttributes";
	public static final String LANGUAGE_ENCODING = "languageEncoding";
	public static final String CURRENCY_ENCODING = "currencyEncoding";

	public static final String FINANCIAL_STOREFRONT = "financialacceleratorstorefront";
	public static final String PAYMENT_ENABLED = "paymentEnabled";
	public static final String USER_PERSONAL_DETAILS_CHECK = "user.personalDetails.check";

	private WebConstants()
	{
		//empty to avoid instantiating this constant class
	}

}

/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.tags;

import de.hybris.platform.acceleratorservices.util.SpringHelper;
import de.hybris.platform.commercefacades.product.data.ProductData;
import de.hybris.platform.commerceservices.search.pagedata.SearchPageData;
import de.hybris.platform.financialacceleratorstorefront.comparison.ComparisonTable;
import de.hybris.platform.financialacceleratorstorefront.comparison.ComparisonTableColumn;
import de.hybris.platform.financialacceleratorstorefront.comparison.ComparisonTableFactory;
import de.hybris.platform.subscriptionfacades.data.ChargeEntryData;
import de.hybris.platform.subscriptionfacades.data.OneTimeChargeEntryData;
import de.hybris.platform.subscriptionfacades.data.RecurringChargeEntryData;
import de.hybris.platform.subscriptionfacades.data.SubscriptionPricePlanData;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.web.servlet.tags.HtmlEscapingAwareTag;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import java.math.BigDecimal;
import java.util.Map;


/**
 * Supports the comparison of Insurance products
 */
public class InsuranceComparisonTag extends HtmlEscapingAwareTag
{
	private int scope = PageContext.REQUEST_SCOPE;
	private String tableFactory;
	private String var;
	private SearchPageData searchPageData;

	private static boolean hasRecurringCharge(final ComparisonTable comparisonTable)
	{
		boolean hasRecurringCharge = false;
		final Map<Object, ComparisonTableColumn> map = comparisonTable.getColumns();
		for (final Object key : map.keySet())
		{

			if ("recurringAnnualPrice".equals(key.toString()))
			{
				hasRecurringCharge = true;
				break;
			}
		}
		return hasRecurringCharge;
	}

	@Override
	protected int doStartTagInternal() throws Exception
	{
		return EVAL_BODY_INCLUDE;
	}

	@Override
	public int doEndTag() throws JspException
	{
		if (this.var != null)
		{
			final ComparisonTable comparisonTable = lookupComparisonTableFactory().createTable(getSearchPageData());
			if (!validateTable(comparisonTable))
			{
				pageContext.setAttribute(getVar(), null, getScope());
			}
			else
			{
				pageContext.setAttribute(getVar(), comparisonTable, getScope());
			}
		}
		return EVAL_PAGE;
	}

	protected ComparisonTableFactory lookupComparisonTableFactory()
	{
		return SpringHelper.getSpringBean(pageContext.getRequest(), getTableFactory(), ComparisonTableFactory.class, true);
	}

	protected int getScope()
	{
		return scope;
	}

	public void setScope(final int scope)
	{
		this.scope = scope;
	}

	protected String getTableFactory()
	{
		return tableFactory;
	}

	public void setTableFactory(final String tableFactory)
	{
		this.tableFactory = tableFactory;
	}

	protected String getVar()
	{
		return var;
	}

	public void setVar(final String var)
	{
		this.var = var;
	}

	protected SearchPageData getSearchPageData()
	{
		return searchPageData;
	}

	public void setSearchPageData(final SearchPageData searchPageData)
	{
		this.searchPageData = searchPageData;
	}

	/**
	 * Validates the comparison table based on the logic used in productComparisonItem.tag
	 *
	 * @param comparisonTable
	 * @return true if valid -otherwise false
	 */
	private boolean validateTable(final ComparisonTable comparisonTable)
	{
		boolean isValid = false;

		if (comparisonTable == null)
		{
			return isValid;
		}

		final boolean hasRecurringCharge = hasRecurringCharge(comparisonTable);
		final Map<Object, ComparisonTableColumn> map = comparisonTable.getColumns();

		for (final Object key : map.keySet())
		{
			final SubscriptionPricePlanData price = getSubscriptionPricePlanDataFromMapKey(key);
			if (price == null)
			{
				continue;
			}

			if (hasRecurringCharge && CollectionUtils.isNotEmpty(price.getRecurringChargeEntries()))
			{
				final RecurringChargeEntryData payOnCheckout = price.getRecurringChargeEntries().get(0);

				if (isPayOnCheckoutPriceValid(payOnCheckout))
				{
					isValid = true;
				}
			}
			else if (CollectionUtils.isNotEmpty(price.getOneTimeChargeEntries()))
			{
				final OneTimeChargeEntryData payOnCheckout = price.getOneTimeChargeEntries().get(0);
				if (isPayOnCheckoutTimeValid(payOnCheckout) && isPayOnCheckoutPriceValid(payOnCheckout))
				{
					isValid = true;
				}
			}
		}
		return isValid;
	}

	private boolean isPayOnCheckoutTimeValid(final OneTimeChargeEntryData payOnCheckout)
	{
		return payOnCheckout.getBillingTime() != null && "paynow".equals(payOnCheckout.getBillingTime().getCode());
	}

	private boolean isPayOnCheckoutPriceValid(final ChargeEntryData payOnCheckout)
	{
		return payOnCheckout.getPrice().getValue() != null
				&& payOnCheckout.getPrice().getValue().compareTo(BigDecimal.ZERO) > 0;
	}

	private SubscriptionPricePlanData getSubscriptionPricePlanDataFromMapKey(final Object key)
	{
		if (key instanceof de.hybris.platform.commercefacades.product.data.ProductData)
		{
			final ProductData product = (ProductData) key;
			final SubscriptionPricePlanData price = (SubscriptionPricePlanData) product.getPrice();

			if (price != null)
			{
				return price;
			}
		}
		return null;
	}
}

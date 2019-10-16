/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.checkout.step.strategy;

import de.hybris.platform.commercefacades.order.data.CartData;
import de.hybris.platform.servicelayer.config.ConfigurationService;
import de.hybris.platform.storefront.form.data.FormDetailData;
import de.hybris.platform.xyformsfacades.form.YFormFacade;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;


/**
 * AbstractCheckoutFormsStrategy
 */
public abstract class AbstractCheckoutFormsStrategy implements CheckoutFormsStrategy
{

	private Integer maxCheckoutFormPages;

	@Resource
	private YFormFacade yFormFacade;

	@Resource
	private ConfigurationService configurationService;

	public abstract Map<String, String> getFormPageIdList(final CartData cartData);

	/**
	 * Get maximum display checkout form page from the spring config if it's not set.
	 */
	public Integer getMaxCheckoutFormPages()
	{
		if (maxCheckoutFormPages == null)
		{
			return configurationService.getConfiguration().getInt("insurance.maximum.display.checkout.form.pages", 3);
		}
		else
		{
			return maxCheckoutFormPages;
		}
	}

	/**
	 * Set maximum display checkout form pages.
	 *
	 * @param maxCheckoutFormPages
	 */
	public void setMaximumDisplayCheckoutFormPages(final Integer maxCheckoutFormPages)
	{
		this.maxCheckoutFormPages = maxCheckoutFormPages;
	}

	/**
	 * Get YFormDefinitions By FormPageId. <br/>
	 * FormPageId is the value defined earlier the CartData to represent the different form page from the cart entries.
	 *
	 * @param cartData
	 * @param formPageId
	 */
	public abstract List<FormDetailData> getFormDetailDataByFormPageId(final CartData cartData, final String formPageId);

	protected ConfigurationService getConfigurationService()
	{
		return configurationService;
	}

	public void setConfigurationService(final ConfigurationService configurationService)
	{
		this.configurationService = configurationService;
	}

	protected YFormFacade getYFormFacade()
	{
		return yFormFacade;
	}

	public void setYFormFacade(final YFormFacade yFormFacade)
	{
		this.yFormFacade = yFormFacade;
	}

}

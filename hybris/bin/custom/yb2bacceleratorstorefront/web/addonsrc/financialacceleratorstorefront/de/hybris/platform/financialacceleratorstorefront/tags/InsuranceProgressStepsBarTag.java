/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.tags;

import de.hybris.platform.acceleratorservices.util.SpringHelper;
import de.hybris.platform.financialacceleratorstorefront.checkout.step.FinancialServicesCheckoutStep;
import de.hybris.platform.financialacceleratorstorefront.strategies.StepTransitionStrategy;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.tags.HtmlEscapingAwareTag;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import java.util.Map;


public class InsuranceProgressStepsBarTag extends HtmlEscapingAwareTag
{
	protected static final String CATEGORY_MAPPING = "/c/";

	private int scope = PageContext.REQUEST_SCOPE;
	private String progressStepMapKey;
	private String stepTransitionStrategyKey;
	private String currentUrl;
	private String var;
	private Map<String, FinancialServicesCheckoutStep> progressStepMap;

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
			final Map<String, FinancialServicesCheckoutStep> steps = lookupProgressStepMap();
			processProgressVisited(steps);
			pageContext.setAttribute(getVar(), steps, getScope());
		}
		return EVAL_PAGE;
	}

	protected void processProgressVisited(final Map<String, FinancialServicesCheckoutStep> steps)
	{
		final StepTransitionStrategy strategy = lookupStepTransitionStrategy();
		for (final FinancialServicesCheckoutStep checkoutStep : steps.values())
		{
			setCategoryUrl(checkoutStep);
			strategy.setVisited(checkoutStep, getCurrentUrl());
		}
	}

	protected void setCategoryUrl(final FinancialServicesCheckoutStep checkoutStep)
	{
		final boolean isCategoryMapping = getCurrentUrl().contains(CATEGORY_MAPPING);

		if ((StringUtils.isEmpty(checkoutStep.getCategoryUrl()) && isCategoryMapping) || (isCategoryMapping && !getCurrentUrl()
				.equals(
						checkoutStep.getCategoryUrl())))
		{
			checkoutStep.setCategoryUrl(getCurrentUrl());
		}

		checkoutStep.setCategoryUrl(isCategoryMapping);
	}

	protected Map<String, FinancialServicesCheckoutStep> lookupProgressStepMap()
	{
		return SpringHelper.getSpringBean(pageContext.getRequest(), getProgressStepMapKey(), Map.class, true);
	}

	protected StepTransitionStrategy lookupStepTransitionStrategy()
	{
		String key = "stepTransitionStrategy";
		if (!StringUtils.isEmpty(getStepTransitionStrategyKey()))
		{
			key = getStepTransitionStrategyKey();
		}
		return SpringHelper.getSpringBean(pageContext.getRequest(), key, StepTransitionStrategy.class, true);
	}

	protected int getScope()
	{
		return scope;
	}

	public void setScope(final int scope)
	{
		this.scope = scope;
	}

	protected Map<String, FinancialServicesCheckoutStep> getProgressStepMap()
	{
		return progressStepMap;
	}

	public void setProgressStepMap(final Map<String, FinancialServicesCheckoutStep> progressStepMap)
	{
		this.progressStepMap = progressStepMap;
	}

	protected String getProgressStepMapKey()
	{
		return progressStepMapKey;
	}

	public void setProgressStepMapKey(final String progressStepMapKey)
	{
		this.progressStepMapKey = progressStepMapKey;
	}

	protected String getVar()
	{
		return var;
	}

	public void setVar(final String var)
	{
		this.var = var;
	}

	protected String getStepTransitionStrategyKey()
	{
		return stepTransitionStrategyKey;
	}

	public void setStepTransitionStrategyKey(final String stepTransitionStrategyKey)
	{
		this.stepTransitionStrategyKey = stepTransitionStrategyKey;
	}

	public String getCurrentUrl()
	{
		return currentUrl;
	}

	public void setCurrentUrl(final String currentUrl)
	{
		this.currentUrl = currentUrl;
	}
}

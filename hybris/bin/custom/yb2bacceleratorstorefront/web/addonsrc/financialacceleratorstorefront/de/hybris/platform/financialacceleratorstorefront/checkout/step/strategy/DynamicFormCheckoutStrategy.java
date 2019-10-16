/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.checkout.step.strategy;

import de.hybris.platform.acceleratorstorefrontcommons.checkout.steps.CheckoutStep;
import de.hybris.platform.financialacceleratorstorefront.checkout.step.FinancialServicesCheckoutStep;
import de.hybris.platform.financialacceleratorstorefront.controllers.pages.checkout.steps.AbstractCheckoutStepController;

import java.util.List;


public interface DynamicFormCheckoutStrategy
{
	/**
	 * Create dynamic form progress checkout steps based on the cart entries. <br/>
	 * Depends on the content of the cart, dynamically create the form steps and defined the navigation between the
	 * forms.
	 *
	 * @param formCheckoutStepPlaceholder
	 */
	List<FinancialServicesCheckoutStep> createDynamicFormSteps(final CheckoutStep formCheckoutStepPlaceholder);


	/**
	 * Combine the Form Checkout Steps to the original Checkout steps for display the at the progress bar.
	 *
	 * @param formCheckoutStepPlaceholder
	 * @param originalCheckoutSteps
	 */
	List<AbstractCheckoutStepController.CheckoutSteps> combineFormCheckoutStepProgressBar(CheckoutStep formCheckoutStepPlaceholder,
			List<AbstractCheckoutStepController.CheckoutSteps> originalCheckoutSteps);

	/**
	 * Get all the Form HTMLs to display on the given formPageId
	 *
	 * @param formPageId
	 */
	List<String> getFormsInlineHtmlByFormPageId(final String formPageId);
}

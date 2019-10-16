/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.checkout.step;

public interface InsuranceStepTransition //NOSONAR
{
	String UNSET = "unset";
	String INVALID = "invalid";
	String VALIDATED = "validated";

	/*
	 * Return the current status of the step to be NOT_VISITED or INVALID or VALID
	 */
	String getCurrentStatus();

	/*
	 * Determine if the step is valid.
	 */
	boolean isValid();

	/*
	 * Determine if the step is visited.
	 */
	boolean isVisited();

	/*
	 * Set visited flag for the checkout step transition
	 */
	void setVisited(final boolean isVisited);

	/*
	 * Determine if the step is enabled.
	 */
	boolean getIsEnabled();
}

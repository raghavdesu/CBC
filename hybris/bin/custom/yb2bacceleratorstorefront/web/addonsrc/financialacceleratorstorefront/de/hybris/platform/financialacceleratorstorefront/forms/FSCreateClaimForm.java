/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.forms;

public class FSCreateClaimForm
{
	private String policyId;
	private String contractId;
	private boolean confirmation;

	public String getPolicyId()
	{
		return policyId;
	}

	public void setPolicyId(String policyId)
	{
		this.policyId = policyId;
	}

	public String getContractId()
	{
		return contractId;
	}

	public void setContractId(String contractId)
	{
		this.contractId = contractId;
	}

	public boolean getConfirmation()
	{
		return confirmation;
	}

	public void setConfirmation(boolean confirmation)
	{
		this.confirmation = confirmation;
	}

}

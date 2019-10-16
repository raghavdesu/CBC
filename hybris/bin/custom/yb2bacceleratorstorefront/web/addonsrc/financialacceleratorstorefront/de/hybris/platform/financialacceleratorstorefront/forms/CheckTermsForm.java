/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.forms;

public class CheckTermsForm
{
	private boolean term1checked, term2checked, term3checked, term4checked;

	public boolean isTerm1checked()
	{
		return term1checked;
	}

	public void setTerm1checked(final boolean term1checked)
	{
		this.term1checked = term1checked;
	}

	public boolean isTerm2checked()
	{
		return term2checked;
	}

	public void setTerm2checked(final boolean term2checked)
	{
		this.term2checked = term2checked;
	}

	public boolean isTerm3checked()
	{
		return term3checked;
	}

	public void setTerm3checked(final boolean term3checked)
	{
		this.term3checked = term3checked;
	}

	public boolean isTerm4checked()
	{
		return term4checked;
	}

	public void setTerm4checked(final boolean term4checked)
	{
		this.term4checked = term4checked;
	}

}

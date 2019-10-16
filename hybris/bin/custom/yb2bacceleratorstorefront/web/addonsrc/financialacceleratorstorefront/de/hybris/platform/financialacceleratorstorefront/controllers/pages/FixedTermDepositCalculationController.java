/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.pages;

import de.hybris.platform.financialfacades.facades.dto.KeyValueDTO;
import de.hybris.platform.financialfacades.strategies.impl.FixedTermDepositQuotationPricingStrategy;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;

/**
 * Fixed Term Deposit Calculation Controller. Handles calculations for term deposit
 */
@Controller
@RequestMapping(value = "/term-deposit")
public class FixedTermDepositCalculationController
{
	private static final String INTEREST_RATE_KEY = "interest-rate";
	private static final double DEFAULT_INTEREST_RATE = 0d;

	@Resource
	private FixedTermDepositQuotationPricingStrategy fixedTermDepositQuotationPricingStrategy;

	@RequestMapping(value = "/interestRate", method = RequestMethod.GET, produces = MediaType.APPLICATION_XML_VALUE)
	public ResponseEntity fixedTermDepositInterestRateCalculation(@RequestParam(value = "termAmount") final String termAmount,
			@RequestParam(value = "depositTerm") final String depositTerm)
	{
		try
		{
			final double interestRate = getFixedTermDepositQuotationPricingStrategy()
					.calculateRate(Double.parseDouble(termAmount), Integer.parseInt(depositTerm));
			return getResponseEntity(new KeyValueDTO(INTEREST_RATE_KEY, String.valueOf(interestRate)));
		}
		catch (NumberFormatException e)
		{
			return getResponseEntity(new KeyValueDTO(INTEREST_RATE_KEY, String.valueOf(DEFAULT_INTEREST_RATE)));
		}
	}

	private <T> ResponseEntity getResponseEntity(T output)
	{
		if (output == null)
		{
			return new ResponseEntity<>(null, HttpStatus.OK);
		}

		final MultiValueMap<String, String> headers = new HttpHeaders();
		headers.add(HttpHeaders.CONTENT_TYPE, "text/xml; charset=UTF-8");
		return new ResponseEntity<>(output, headers, HttpStatus.OK);
	}

	protected FixedTermDepositQuotationPricingStrategy getFixedTermDepositQuotationPricingStrategy()
	{
		return fixedTermDepositQuotationPricingStrategy;
	}

	public void setFixedTermDepositQuotationPricingStrategy(
			FixedTermDepositQuotationPricingStrategy fixedTermDepositQuotationPricingStrategy)
	{
		this.fixedTermDepositQuotationPricingStrategy = fixedTermDepositQuotationPricingStrategy;
	}
}

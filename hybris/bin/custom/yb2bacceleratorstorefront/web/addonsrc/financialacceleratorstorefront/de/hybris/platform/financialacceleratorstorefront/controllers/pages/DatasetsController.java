/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.financialfacades.facades.FSIncidentTypeFacade;
import de.hybris.platform.servicelayer.i18n.I18NService;
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
import java.util.Locale;


/**
 * Data Autocomplete Controller.
 */
@Controller
@RequestMapping(value = "/datasets")
public class DatasetsController extends AbstractPageController
{

	@Resource
	private FSIncidentTypeFacade fsIncidentTypeFacade;

	@Resource
	private I18NService i18nService;

	@RequestMapping(value = "/incidentTypes", method = RequestMethod.GET, produces = MediaType.APPLICATION_XML_VALUE)
	public ResponseEntity countryAutocomplete(@RequestParam(value = "categoryCode") final String categoryCode,
			@RequestParam(value = "language") final String language)
	{
		getI18nService().setCurrentLocale(new Locale(language));
		return getResponseEntity(getFsIncidentTypeFacade().findIncidentTypeDTOsByCategory(categoryCode));
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

	protected FSIncidentTypeFacade getFsIncidentTypeFacade()
	{
		return fsIncidentTypeFacade;
	}

	public void setFsIncidentTypeFacade(FSIncidentTypeFacade fsIncidentTypeFacade)
	{
		this.fsIncidentTypeFacade = fsIncidentTypeFacade;
	}

	protected I18NService getI18nService()
	{
		return i18nService;
	}

	public void setI18nService(I18NService i18nService)
	{
		this.i18nService = i18nService;
	}
}

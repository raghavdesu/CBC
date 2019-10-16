/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.misc.document.generation.pdf;

import de.hybris.platform.acceleratorstorefrontcommons.controllers.AbstractController;
import de.hybris.platform.financialfacades.facades.DocumentGenerationFacade;
import de.hybris.platform.servicelayer.exceptions.UnknownIdentifierException;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


/**
 * PDFGenerationController
 */
@Controller("PdfGenerationController")
public class PdfGenerationController extends AbstractController
{

	private static final Logger LOGGER = Logger.getLogger(PdfGenerationController.class);

	@Resource(name = "documentGenerationFacade")
	DocumentGenerationFacade documentGenerationFacade;

	@ExceptionHandler(UnknownIdentifierException.class)
	public String handleUnknownIdentifierException(final UnknownIdentifierException exception, final HttpServletRequest request)
	{
		request.setAttribute("message", exception.getMessage());
		return FORWARD_PREFIX + "/404";
	}

	/*
	 * http://financialservices.local:9001/yb2bacceleratorstorefront/insurance/en/pdf/print?itemRefId=12345
	 */
	@RequestMapping(value = "/pdf/print", method = RequestMethod.GET)
	public void pdfPrint(@RequestParam("itemRefId") final String itemRefId, final HttpServletResponse response) throws IOException
	{
		LOGGER.info("Pdf printing.");
		documentGenerationFacade.generate(DocumentGenerationFacade.PDF_DOCUMENT, itemRefId, response);
	}
}

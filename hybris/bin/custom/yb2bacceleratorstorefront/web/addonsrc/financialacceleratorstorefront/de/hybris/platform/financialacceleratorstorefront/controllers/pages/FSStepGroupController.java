/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.financialfacades.facades.FSStepGroupFacade;
import de.hybris.platform.financialfacades.facades.FSUserRequestSubmitFacade;
import de.hybris.platform.financialfacades.insurance.data.FSStepDataData;
import de.hybris.platform.financialfacades.insurance.data.FSUserRequestData;
import de.hybris.platform.financialservices.enums.FSRequestStatus;
import de.hybris.platform.financialservices.enums.FSStepStatus;
import de.hybris.platform.servicelayer.exceptions.UnknownIdentifierException;
import de.hybris.platform.webservicescommons.util.YSanitizer;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;


@Controller
@RequestMapping("/fsStepGroup")
public class FSStepGroupController extends AbstractPageController
{
	protected static final String REQUEST_ID_PATH_VARIABLE_PATTERN = "{requestId:.*}";
	protected static final String STEP_NO_PATH_VARIABLE_PATTERN = "{stepNo:.*}";
	protected static final String FSUSERREQUEST_CONFIRMATION_PAGE = "fsRequestConfirmation";

	protected static final String MESSAGE = "message";
	protected static final String REFERER = "Referer";
	protected static final String FS_STEP_GROUP = "/fsStepGroup/";
	protected static final String STEP = "/step/";

	private static final Logger LOG = Logger.getLogger(FSStepGroupController.class);

	@Resource(name = "fsStepGroupFacade")
	private FSStepGroupFacade fsStepGroupFacade;
	@Resource(name = "fsUserRequestSubmitFacade")
	private FSUserRequestSubmitFacade fsUserRequestSubmitFacade;

	protected String sanitize(final String input)
	{
		return YSanitizer.sanitize(input);
	}

	@ExceptionHandler(CMSItemNotFoundException.class)
	public String handleCMSItemNotFoundException(final CMSItemNotFoundException exception, final HttpServletRequest request)
	{
		request.setAttribute(MESSAGE, exception.getMessage());
		return FORWARD_PREFIX + "/404";
	}

	@ExceptionHandler(UnknownIdentifierException.class)
	public String handleUnknownIdentifierException(final UnknownIdentifierException exception, final HttpServletRequest request)
	{
		request.setAttribute(MESSAGE, exception.getMessage());
		return FORWARD_PREFIX + "/404";
	}

	@ExceptionHandler(NumberFormatException.class)
	public String handleNumberFormatException(final NumberFormatException exception, final HttpServletRequest request)
	{
		request.setAttribute(MESSAGE, exception.getMessage());
		return FORWARD_PREFIX + "/404";
	}

	@RequestMapping(value = "/start", method = RequestMethod.GET)
	@RequireHardLogIn
	public String startFSStepGroupForCategoryAndRequest(@RequestParam String requestId, @RequestParam String categoryCode,
			final RedirectAttributes redirectAttributes, final Model model, final HttpServletRequest request)
			throws CMSItemNotFoundException
	{
		getFsStepGroupFacade().startFSStepGroupForCategoryAndRequest(categoryCode, requestId);

		return REDIRECT_PREFIX + requestId + "/step/1";
	}

	@RequestMapping(value = "/" + REQUEST_ID_PATH_VARIABLE_PATTERN + STEP
			+ STEP_NO_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
	@RequireHardLogIn
	public String enterStepForRequest(@PathVariable String requestId, @PathVariable int stepNo,
			final RedirectAttributes redirectModel, final Model model, final HttpServletRequest request)
			throws CMSItemNotFoundException
	{
		final FSUserRequestData requestData = getFsStepGroupFacade().getFSUserRequestForIdForCurrentUser(requestId);
		if (requestData == null || CollectionUtils.isEmpty(requestData.getConfigurationSteps()))
		{
			throw new CMSItemNotFoundException("Step with number: " + stepNo + " not found!");
		}

		final List<Integer> stepNumbers = getFsStepGroupFacade().getStepNumbersForNotCompletedSteps(requestData);

		for (final Integer step : stepNumbers)
		{
			if (step < stepNo)
			{
				GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER,
						"navigation.complete.previous.steps");
				return REDIRECT_PREFIX + FS_STEP_GROUP + requestId + STEP + step;
			}
		}

		return populateModelForRequestAndStep(model, requestData, stepNo);
	}

	@RequestMapping(value = "/" + REQUEST_ID_PATH_VARIABLE_PATTERN + STEP
			+ STEP_NO_PATH_VARIABLE_PATTERN + "/next", method = RequestMethod.GET)
	@RequireHardLogIn
	public String next(@PathVariable String requestId, @PathVariable int stepNo, final RedirectAttributes redirectAttributes,
			final Model model, final HttpServletRequest request) throws CMSItemNotFoundException
	{
		final FSUserRequestData requestData = getFsStepGroupFacade().getFSUserRequestForIdForCurrentUser(requestId);
		getFsStepGroupFacade().validateStepContent(requestData, stepNo);
		final int nextStep = requestData != null && CollectionUtils.isNotEmpty(requestData.getConfigurationSteps())
				&& requestData.getConfigurationSteps().size() >= stepNo + 1 ? (stepNo + 1) : stepNo;
		return REDIRECT_PREFIX + FS_STEP_GROUP + requestId + STEP + nextStep;
	}

	@RequestMapping(value = "/" + REQUEST_ID_PATH_VARIABLE_PATTERN + STEP
			+ STEP_NO_PATH_VARIABLE_PATTERN + "/back", method = RequestMethod.GET)
	@RequireHardLogIn
	public String back(@PathVariable String requestId, @PathVariable int stepNo, final RedirectAttributes redirectAttributes,
			final Model model, final HttpServletRequest request) throws CMSItemNotFoundException
	{
		final FSUserRequestData requestData = getFsStepGroupFacade().getFSUserRequestForIdForCurrentUser(requestId);
		getFsStepGroupFacade().validateStepContent(requestData, stepNo);
		final int previousStep = requestData != null && CollectionUtils.isNotEmpty(requestData.getConfigurationSteps())
				&& stepNo - 1 > 0 ? (stepNo - 1) : stepNo;
		return REDIRECT_PREFIX + FS_STEP_GROUP + requestId + STEP + previousStep;
	}

	private String populateModelForRequestAndStep(Model model, FSUserRequestData requestData, int step)
			throws CMSItemNotFoundException
	{
		try
		{
			final int index = step - 1;

			final List<FSStepDataData> configurationSteps = requestData.getConfigurationSteps();

			model.addAttribute("requestData", requestData);
			model.addAttribute("configurationSteps", configurationSteps);

			model.addAttribute("stepData", getFsStepGroupFacade().exposeStepContent(requestData, step));

			if (configurationSteps.size() > step)
			{
				model.addAttribute("nextStep", step + "/next");
			}

			if (index != 0)
			{
				model.addAttribute("previousStep", step + "/back");
			}

			final String pageLabelOrId = configurationSteps.get(index).getPageLabelOrId();

			storeCmsPageInModel(model, getContentPageForLabelOrId(pageLabelOrId));
			setUpMetaDataForContentPage(model, getContentPageForLabelOrId(pageLabelOrId));
			return getViewForPage(model);
		}
		catch (NumberFormatException | IndexOutOfBoundsException ex)
		{
			LOG.info("No step with the provided number found", ex);
			throw new CMSItemNotFoundException("Step with number: " + step + " not found!");
		}
	}

	@RequireHardLogIn
	@RequestMapping(value = "/submit", method = RequestMethod.POST)
	public String submitRequest(@RequestParam(value = "requestId", required = true) final String requestId, final Model model,
			final RedirectAttributes redirectModel, final HttpServletRequest request) throws CMSItemNotFoundException
	{
		try
		{
			FSUserRequestData requestData = getFsStepGroupFacade().getFSUserRequestForIdForCurrentUser(requestId);

			if (requestData == null)
			{
				LOG.warn("There is no request data associated with request with requestId " + sanitize(requestId) + ".");
				GlobalMessages.addFlashMessage(redirectModel,
						GlobalMessages.ERROR_MESSAGES_HOLDER, "request.item.not.submitted", null);

				return REDIRECT_PREFIX + ROOT;
			}

			if (FSRequestStatus.SUBMITTED.equals(requestData.getRequestStatus()))
			{
				LOG.warn("Request with requestId" + sanitize(requestId) + " is already submitted.");
				GlobalMessages.addFlashMessage(redirectModel,
						GlobalMessages.ERROR_MESSAGES_HOLDER, "request.item.is.already.submitted", null);

				return REDIRECT_PREFIX + ROOT;
			}

			final int stepNo = CollectionUtils.isNotEmpty(requestData.getConfigurationSteps()) ?
					requestData.getConfigurationSteps().size() : 0;
			final FSStepStatus lastStepStatus = getFsStepGroupFacade().validateStepContent(requestData, stepNo);

			if (FSStepStatus.UNSET.equals(lastStepStatus))
			{
				LOG.warn("Last step is not valid.");
				GlobalMessages.addFlashMessage(redirectModel,
						GlobalMessages.ERROR_MESSAGES_HOLDER, "request.item.last.step.not.valid", null);

				return REDIRECT_PREFIX + FS_STEP_GROUP + requestId + STEP + stepNo;
			}

			requestData = getFSUserRequestSubmitFacade().submitFSRequest(requestId);
			redirectModel.addAttribute("requestId", requestData.getRequestId());

			if (requestData.getFsStepGroupDefinition() != null && !StringUtils
					.isEmpty(requestData.getFsStepGroupDefinition().getConfirmationUrl()))
			{
				return REDIRECT_PREFIX + "/" + requestData.getFsStepGroupDefinition().getConfirmationUrl() + "/" + requestData
						.getRequestId();
			}
			else
			{
				return REDIRECT_PREFIX + "/fsStepGroup/confirmation/" + requestData.getRequestId();
			}
		}
		catch (final UnknownIdentifierException e)
		{
			LOG.warn("Attempted to submit request was not successfull", e);
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "request.item.not.submitted", null);

			return REDIRECT_PREFIX + ROOT;
		}
	}

	@RequireHardLogIn
	@RequestMapping(value = "/confirmation/" + REQUEST_ID_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
	public String fsRequestConfirmation(@PathVariable("requestId") final String requestId, final HttpServletResponse request,
			final Model model, final RedirectAttributes redirectModel) throws CMSItemNotFoundException
	{
		try
		{
			final FSUserRequestData requestData = getFsStepGroupFacade().getFSUserRequestForIdForCurrentUser(requestId);
			model.addAttribute("fsRequest", requestData);
		}
		catch (final UnknownIdentifierException e)
		{
			LOG.warn("Attempted to load a FSRequest that does not exist or is not visible", e);
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, "request.item.not.found", null);

			return REDIRECT_PREFIX + ROOT;
		}

		storeCmsPageInModel(model, getContentPageForLabelOrId(FSUSERREQUEST_CONFIRMATION_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(FSUSERREQUEST_CONFIRMATION_PAGE));
		return getViewForPage(model);
	}

	protected FSStepGroupFacade getFsStepGroupFacade()
	{
		return fsStepGroupFacade;
	}

	protected FSUserRequestSubmitFacade getFSUserRequestSubmitFacade()
	{
		return fsUserRequestSubmitFacade;
	}

}

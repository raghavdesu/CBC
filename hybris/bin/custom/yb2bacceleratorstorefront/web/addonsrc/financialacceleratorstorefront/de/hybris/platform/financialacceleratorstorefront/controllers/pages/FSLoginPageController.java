/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.consent.data.ConsentCookieData;
import de.hybris.platform.acceleratorstorefrontcommons.constants.WebConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractLoginPageController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.acceleratorstorefrontcommons.forms.ConsentForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.GuestForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.LoginForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.RegisterForm;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.AbstractPageModel;
import de.hybris.platform.cms2.model.pages.ContentPageModel;
import de.hybris.platform.commercefacades.customer.CustomerFacade;
import de.hybris.platform.commercefacades.user.data.RegisterData;
import de.hybris.platform.commerceservices.customer.DuplicateUidException;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import de.hybris.platform.financialacceleratorstorefront.forms.FSRegisterForm;
import de.hybris.platform.webservicescommons.util.YSanitizer;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Required;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Validator;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.WebUtils;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.List;


/**
 * Login Controller. Handles login and register for the account flow.
 */
@RequestMapping(value = "/login")
public class FSLoginPageController extends AbstractLoginPageController
{
	private static final Logger LOGGER = Logger.getLogger(FSLoginPageController.class);
	private static final String FORM_GLOBAL_ERROR = "form.global.error";
	private static final String CONSENT_FORM_GLOBAL_ERROR = "consent.form.global.error";
	protected SimpleDateFormat simpleDateFormat;

	@Resource
	private CustomerFacade customerFacade;

	@Resource(name = "fsRegistrationValidator")
	private Validator fsRegistrationValidator;

	private HttpSessionRequestCache httpSessionRequestCache;
	private String dateFormatForDisplay;

	protected String sanitize(final String input)
	{
		return YSanitizer.sanitize(input);
	}

	@Resource(name = "httpSessionRequestCache")
	public void setHttpSessionRequestCache(final HttpSessionRequestCache accHttpSessionRequestCache)
	{
		this.httpSessionRequestCache = accHttpSessionRequestCache;
	}

	@Override
	protected String getView()
	{
		return ControllerConstants.Views.Pages.Account.AccountLoginPage;
	}

	@Override
	protected String getSuccessRedirect(final HttpServletRequest request, final HttpServletResponse response)
	{
		if (httpSessionRequestCache.getRequest(request, response) != null)
		{
			return httpSessionRequestCache.getRequest(request, response).getRedirectUrl();
		}
		return "/";
	}

	@Override
	protected AbstractPageModel getCmsPage() throws CMSItemNotFoundException
	{
		return getContentPageForLabelOrId("login");
	}

	@RequestMapping(method = RequestMethod.GET)
	public String doLogin(@RequestHeader(value = "referer", required = false) final String referer,
			@RequestParam(value = "error", defaultValue = "false") final boolean loginError, final Model model,
			final HttpServletRequest request, final HttpServletResponse response, final HttpSession session)
			throws CMSItemNotFoundException
	{
		if (!loginError)
		{
			storeReferer(referer, request, response);
		}
		model.addAttribute(new FSRegisterForm());
		return super.getDefaultLoginPage(loginError, session, model);
	}

	protected void storeReferer(final String referer, final HttpServletRequest request, final HttpServletResponse response)
	{
		if (StringUtils.isNotBlank(referer) && !StringUtils.endsWith(referer, "/login")
				&& StringUtils.contains(referer, request.getServerName()))
		{
			httpSessionRequestCache.saveRequest(request, response);
		}
	}

	@RequestMapping(value = "/register", method = RequestMethod.POST)
	public String doRegister(@RequestHeader(value = "referer", required = false) final String referer, final FSRegisterForm form,
			final BindingResult bindingResult, final Model model, final HttpServletRequest request,
			final HttpServletResponse response, final RedirectAttributes redirectModel) throws CMSItemNotFoundException
	{
		getRegistrationValidator().validate(form, bindingResult);
		return processRegisterUserRequest(referer, form, bindingResult, model, request, response, redirectModel);
	}

	@RequestMapping(value = "/register/termsandconditions")
	public String getTermsAndConditions(final Model model) throws CMSItemNotFoundException
	{
		final ContentPageModel pageForRequest = getCmsPageService().getPageForLabel("/termsAndConditions");
		storeCmsPageInModel(model, pageForRequest);
		setUpMetaDataForContentPage(model, pageForRequest);
		return ControllerConstants.Views.Fragments.Checkout.TermsAndConditionsPopup;
	}

	@Override
	protected String processRegisterUserRequest(final String referer, final RegisterForm form, final BindingResult bindingResult,
			final Model model, final HttpServletRequest request, final HttpServletResponse response,
			final RedirectAttributes redirectModel) throws CMSItemNotFoundException
	{
		FSRegisterForm fsForm = new FSRegisterForm();

		if (form instanceof FSRegisterForm)
		{
			fsForm = (FSRegisterForm) form;
		}
		else
		{
			LOGGER.warn("Not proper type of form used for registration.");
			fsForm.setFirstName(form.getFirstName());
			fsForm.setLastName(form.getLastName());
			fsForm.setTitleCode(form.getTitleCode());
			fsForm.setEmail(form.getEmail());
			fsForm.setTermsCheck(form.isTermsCheck());
			fsForm.setConsentForm(form.getConsentForm());
			preHandleRegistrationError(model, fsForm);
			return handleRegistrationError(model);
		}

		if (bindingResult.hasErrors())
		{
			preHandleRegistrationError(model, fsForm);
			return handleRegistrationError(model);
		}

		final RegisterData data = new RegisterData();
		data.setFirstName(fsForm.getFirstName());
		data.setLastName(fsForm.getLastName());
		data.setLogin(fsForm.getEmail());
		data.setPassword(fsForm.getPwd());
		data.setTitleCode(fsForm.getTitleCode());

		try
		{
			data.setDateOfBirth(simpleDateFormat.parse(fsForm.getDateOfBirth()));
			customerFacade.register(data);
			getAutoLoginStrategy().login(fsForm.getEmail().toLowerCase(), fsForm.getPwd(), request, response);
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.CONF_MESSAGES_HOLDER,
					"registration.confirmation.message.title");
		}
		catch (final DuplicateUidException e)
		{
			LOGGER.warn("registration failed: ", e);
			bindingResult.rejectValue("email", "registration.error.account.exists.title");
			preHandleRegistrationError(model, fsForm);
			return handleRegistrationError(model);
		}
		catch (final ParseException e)
		{
			LOGGER.warn("registration failed: ", e);
			bindingResult.rejectValue("dateOfBirth", "register.dateOfBirth.invalid");
			preHandleRegistrationError(model, fsForm);
			return handleRegistrationError(model);
		}

		// Consent fsForm data
		try
		{
			final ConsentForm consentForm = fsForm.getConsentForm();
			if (consentForm != null && consentForm.getConsentGiven())
			{
				getConsentFacade().giveConsent(consentForm.getConsentTemplateId(), consentForm.getConsentTemplateVersion());
			}
		}
		catch (final Exception e)
		{
			LOGGER.error("Error occurred while creating consents during registration", e);
			GlobalMessages.addFlashMessage(redirectModel, GlobalMessages.ERROR_MESSAGES_HOLDER, CONSENT_FORM_GLOBAL_ERROR);
		}

		// save anonymous-consent cookies as ConsentData
		final Cookie cookie = WebUtils.getCookie(request, WebConstants.ANONYMOUS_CONSENT_COOKIE);
		if (cookie != null)
		{
			try
			{
				final ObjectMapper mapper = new ObjectMapper();
				final List<ConsentCookieData> consentCookieDataList = Arrays.asList(mapper.readValue(
						URLDecoder.decode(cookie.getValue(), StandardCharsets.UTF_8.displayName()), ConsentCookieData[].class));
				consentCookieDataList.stream().filter(consentData -> WebConstants.CONSENT_GIVEN.equals(consentData.getConsentState()))
						.forEach(consentData -> consentFacade.giveConsent(consentData.getTemplateCode(),
								Integer.valueOf(consentData.getTemplateVersion())));
			}
			catch (final UnsupportedEncodingException e)
			{
				LOGGER.error(String.format("Cookie Data could not be decoded : %s", sanitize(cookie.getValue())), e);
			}
			catch (final IOException e)
			{
				LOGGER.error("Cookie Data could not be mapped into the Object", e);
			}
			catch (final Exception e)
			{
				LOGGER.error("Error occurred while creating Anonymous cookie consents", e);
			}
		}

		customerConsentDataStrategy.populateCustomerConsentDataInSession();

		return REDIRECT_PREFIX + getSuccessRedirect(request, response);
	}

	protected void preHandleRegistrationError(Model model, FSRegisterForm fsForm)
	{
		fsForm.setTermsCheck(false);
		model.addAttribute(fsForm);
		model.addAttribute(new LoginForm());
		model.addAttribute(new GuestForm());
		GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
	}

	@Override
	protected Validator getRegistrationValidator()
	{
		return fsRegistrationValidator;
	}

	@Required
	public void setDateFormatForDisplay(final String dateFormatForDisplay)
	{
		this.dateFormatForDisplay = dateFormatForDisplay;
		simpleDateFormat = new SimpleDateFormat(dateFormatForDisplay);
	}

	protected SimpleDateFormat getSimpleDateFormat()
	{
		if (simpleDateFormat == null)
		{
			simpleDateFormat = new SimpleDateFormat(this.dateFormatForDisplay);
		}
		return simpleDateFormat;
	}
}

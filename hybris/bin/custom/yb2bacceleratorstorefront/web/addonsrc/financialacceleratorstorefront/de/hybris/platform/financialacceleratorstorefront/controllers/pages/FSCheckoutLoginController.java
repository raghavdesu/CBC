/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.pages;

import de.hybris.platform.acceleratorfacades.flow.CheckoutFlowFacade;
import de.hybris.platform.acceleratorstorefrontcommons.consent.data.ConsentCookieData;
import de.hybris.platform.acceleratorstorefrontcommons.constants.WebConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractLoginPageController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.acceleratorstorefrontcommons.forms.ConsentForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.GuestForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.LoginForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.RegisterForm;
import de.hybris.platform.acceleratorstorefrontcommons.forms.validation.GuestValidator;
import de.hybris.platform.acceleratorstorefrontcommons.security.GUIDCookieStrategy;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.AbstractPageModel;
import de.hybris.platform.commercefacades.customer.CustomerFacade;
import de.hybris.platform.commercefacades.order.data.CartData;
import de.hybris.platform.commercefacades.product.data.CategoryData;
import de.hybris.platform.commercefacades.user.data.RegisterData;
import de.hybris.platform.commerceservices.customer.DuplicateUidException;
import de.hybris.platform.constants.FinancialacceleratorstorefrontConstants;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import de.hybris.platform.financialacceleratorstorefront.forms.FSRegisterForm;
import de.hybris.platform.financialfacades.facades.InsuranceCartFacade;
import de.hybris.platform.webservicescommons.util.YSanitizer;
import org.apache.log4j.Logger;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Required;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Validator;
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
 * Checkout Login Controller. Handles login and register for the checkout flow.
 */
@RequestMapping(value = "/login/checkout")
public class FSCheckoutLoginController extends AbstractLoginPageController
{
	private static final Logger LOGGER = Logger.getLogger(FSCheckoutLoginController.class);

	private static final String FORM_GLOBAL_ERROR = "form.global.error";
	private static final String CONSENT_FORM_GLOBAL_ERROR = "consent.form.global.error";

	@Resource(name = "checkoutFlowFacade")
	private CheckoutFlowFacade checkoutFlowFacade;
	@Resource(name = "guidCookieStrategy")
	private GUIDCookieStrategy guidCookieStrategy;
	@Resource(name = "guestValidator")
	private GuestValidator guestValidator;
	@Resource(name = "cartFacade")
	private InsuranceCartFacade cartFacade;
	@Resource
	private CustomerFacade customerFacade;
	@Resource(name = "fsRegistrationValidator")
	private Validator fsRegistrationValidator;

	private SimpleDateFormat simpleDateFormat;
	private String dateFormatForDisplay;

	protected String sanitize(final String input)
	{
		return YSanitizer.sanitize(input);
	}

	@Override
	protected AbstractPageModel getCmsPage() throws CMSItemNotFoundException
	{
		return getContentPageForLabelOrId("checkout-login");
	}

	@RequestMapping(method = RequestMethod.GET)
	public String doCheckoutLogin(@RequestParam(value = "error", defaultValue = "false") final boolean loginError,
			final HttpSession session, final Model model, final HttpServletRequest request) throws CMSItemNotFoundException
	{
		model.addAttribute("expressCheckoutAllowed", getCheckoutFlowFacade().isExpressCheckoutEnabledForStore());
		model.addAttribute(new FSRegisterForm());

		LOGGER.debug("In the FSCheckoutLoginController for GET for /checkout/login");
		final CategoryData categoryData = cartFacade.getSelectedInsuranceCategory();
		if (categoryData != null)
		{
			model.addAttribute(FinancialacceleratorstorefrontConstants.CATEGORY_NAME_MODEL_VAR, categoryData.getName());
		}

		return getDefaultLoginPage(loginError, session, model);
	}

	@RequestMapping(value = "/register", method = RequestMethod.POST)
	public String doCheckoutRegister(final FSRegisterForm form, final BindingResult bindingResult, final Model model,
			final HttpServletRequest request, final HttpServletResponse response, final RedirectAttributes redirectModel)
			throws CMSItemNotFoundException
	{
		getRegistrationValidator().validate(form, bindingResult);
		return processRegisterUserRequest(null, form, bindingResult, model, request, response, redirectModel);
	}

	@RequestMapping(value = "/register", method = RequestMethod.GET)
	public String checkoutRegister(@RequestParam(value = "error", defaultValue = "false") final boolean loginError,
			final HttpSession session, final Model model, final HttpServletRequest request) throws CMSItemNotFoundException
	{
		return doCheckoutLogin(loginError, session, model, request);
	}

	@Override
	protected String getView()
	{
		return ControllerConstants.Views.Pages.Checkout.CheckoutLoginPage;
	}

	@Override
	protected String getSuccessRedirect(final HttpServletRequest request, final HttpServletResponse response)
	{
		if (hasItemsInCart())
		{
			return getCheckoutUrl();
		}
		// Redirect to the main checkout controller to handle checkout.
		return "/checkout";
	}

	@Override
	protected String processRegisterUserRequest(final String referer, final RegisterForm form, final BindingResult bindingResult,
			final Model model, final HttpServletRequest request, final HttpServletResponse response,
			final RedirectAttributes redirectModel) throws CMSItemNotFoundException
	{
		final FSRegisterForm fsForm = (FSRegisterForm) form;

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

	/**
	 * Checks if there are any items in the cart.
	 *
	 * @return returns true if items found in cart.
	 */
	protected boolean hasItemsInCart()
	{
		final CartData cartData = getCheckoutFlowFacade().getCheckoutCart();

		return cartData.getEntries() != null && !cartData.getEntries().isEmpty();
	}

	protected String getCheckoutUrl()
	{
		// Default to the multi-step checkout
		return "/checkout/multi";
	}

	protected GuestValidator getGuestValidator()
	{
		return guestValidator;
	}

	protected CheckoutFlowFacade getCheckoutFlowFacade()
	{
		return checkoutFlowFacade;
	}

	@Override
	protected GUIDCookieStrategy getGuidCookieStrategy()
	{
		return guidCookieStrategy;
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

	public SimpleDateFormat getSimpleDateFormat()
	{
		if (simpleDateFormat == null)
		{
			simpleDateFormat = new SimpleDateFormat(this.dateFormatForDisplay);
		}
		return simpleDateFormat;
	}

}

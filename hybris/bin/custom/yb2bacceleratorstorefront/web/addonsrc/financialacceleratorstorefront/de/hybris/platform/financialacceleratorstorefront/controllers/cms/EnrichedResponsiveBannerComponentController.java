/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */

package de.hybris.platform.financialacceleratorstorefront.controllers.cms;

import de.hybris.platform.acceleratorfacades.device.ResponsiveMediaFacade;
import de.hybris.platform.commercefacades.product.data.ImageData;
import de.hybris.platform.commerceservices.i18n.CommerceCommonI18NService;
import de.hybris.platform.financialacceleratorstorefront.controllers.ControllerConstants;
import de.hybris.platform.financialservices.model.components.EnrichedResponsiveBannerComponentModel;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;


/**
 * Controller for CMS MultiFunctionalResponsiveBannerController
 */
@Controller("EnrichedResponsiveBannerComponentController")
@RequestMapping(value = ControllerConstants.Actions.Cms.EnrichedResponsiveBanerComponent)
public class EnrichedResponsiveBannerComponentController extends
		SubstitutingCMSAddOnComponentController<EnrichedResponsiveBannerComponentModel>
{

	@Resource(name = "responsiveMediaFacade")
	private ResponsiveMediaFacade responsiveMediaFacade;

	@Resource(name = "commerceCommonI18NService")
	private CommerceCommonI18NService commerceCommonI18NService;

	@Override
	protected void fillModel(final HttpServletRequest request, final Model model,
			final EnrichedResponsiveBannerComponentModel component)
	{
		final List<ImageData> mediaDataList = responsiveMediaFacade.getImagesFromMediaContainer(component
				.getMedia(commerceCommonI18NService.getCurrentLocale()));
		model.addAttribute("medias", mediaDataList);
		model.addAttribute("urlLink", component.getUrlLink());
		model.addAttribute("headingText", component.getHeadingText());
		model.addAttribute("styledText", component.getStyledText());
	}
}

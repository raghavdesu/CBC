<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<div id="popup_referred_quote_wrapper" style="display:none">
    <div id="popup_referred_quote">
        <div class="popup-content-wrapper">
            <h3><spring:theme code="text.quote.referred.title" text="Customer info"/></h3>
            <spring:theme code="text.quote.referred.description"
                          text="Your Quote is referred. For more information, please contact the Agent."/>
            <div class="modal-actions">
                <div class="row">
                    <div class="col-md-6 col-sm-6 col-xs-12 pull-right">
                        <a href="${request.contextPath}/find-agent">
                            <button id="referredQuoteContactAgent" class="primary-button primary-button__default primary-button__popup changePlanConfirmButton">
                                <spring:theme code="text.dialog.contact.agent" text="Contact Agent"/>
                            </button>
                        </a>
                    </div>
                    <div class="col-md-6 col-sm-6 col-xs-12 pull-left">
                            <button id="referredQuoteCancel" class="secondary-button secondary-button__default secondary-button__popup">
                                <spring:theme code="text.dialog.cancel" text="Cancel"/>
                            </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

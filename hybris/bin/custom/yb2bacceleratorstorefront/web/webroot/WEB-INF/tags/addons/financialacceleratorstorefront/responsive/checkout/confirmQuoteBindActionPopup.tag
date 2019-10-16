<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<div id="popup_confirm_bind_quote_wrapper" style="display:none">
    <div id="popup_confirm_bind_quote">
        <div class="popup-content-wrapper">
            <h3><spring:theme code="text.confirm.quote.notification" text="Confirm Quote"/></h3>
            <p id="certifyDescription"><spring:theme code="checkout.multi.quoteReview.certify.description"
                text="By clicking on Continue I certify the information in this application is true and correct."/></p>
            <p id="processingBindQuote" style="display:none">
                <spring:theme code="checkout.multi.quoteReview.pleaseWait"
                text="Quote is being processed, please wait!"/>
            </p>
            <div id="jsLoading"></div>
            <div class="modal-actions">
                <div class="row">
                    <div class="col-md-6 col-sm-6 col-xs-12 pull-right">
                        <button id="yesButton" class="primary-button primary-button__default primary-button__popup changePlanConfirmButton">
                            <spring:theme code="text.dialog.confirm" text="Continue"/>
                        </button>
                    </div>
                    <div class="col-md-6 col-sm-6 col-xs-12 pull-left">
                        <button id="cancelButton" class="secondary-button secondary-button__default secondary-button__popup">
                            <spring:theme code="text.dialog.cancel" text="Cancel"/>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:htmlEscape defaultHtmlEscape="true"/>

<div id="popup_confirm_retrieve_quote_wrapper" style="display:none">
    <div id="popup_confirm_retrieve_quote">
        <div class="popup-content-wrapper">
            <h3><spring:theme code="text.plan.confirm.change.plan" text="Confirm change plan"/></h3>
            <spring:theme code="text.plan.remove.confirmation" text="Changing product plans may alter the form questions. Do you still wish to proceed?"/>
            
            <div class="modal-actions">
                <div class="row">
                    <div class="col-xs-12 col-sm-6 col-sm-push-6">
                        <button id="saveProceedButton" class="primary-button primary-button__default primary-button__popup changePlanConfirmButton">
                            <spring:theme code="text.plan.save.proceed" text="Save and Proceed"/>
                        </button>
                    </div>
                    <div class="col-xs-12 col-sm-6 col-sm-pull-6">
                        <button id="cancelButton" class="secondary-button secondary-button__default secondary-button__popup">
                            <spring:theme code="text.dialog.cancel" text="Cancel"/>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

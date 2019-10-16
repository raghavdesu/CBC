<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>


<spring:htmlEscape defaultHtmlEscape="true"/>

<div class="account-section-header account-close-section-header">
    <div class="row">
        <div class="container-lg col-md-6">
            <spring:theme code="text.account.closeAccount.header"/>
        </div>
    </div>
</div>
<div class="row">
    <div class="container-lg col-md-6">
        <div class="account-section-content">
            <div class="account-section-form">
                <div class="account-section-form__intro-text">
					<spring:theme code="text.account.closeAccount.retention.info" htmlEscape="false"/>
                </div>
                <div class="profile-info">
	                <div class="col-xs-12 col-sm-6">
	                	<spring:theme code="text.account.closeAccount.list.info1.${fn:toLowerCase(fn:escapeXml(cmsSite.channel))}" htmlEscape="false"/>
	                </div>
	                <div class="col-xs-12 col-sm-6">
	                	<spring:theme code="text.account.closeAccount.list.info2.${fn:toLowerCase(fn:escapeXml(cmsSite.channel))}" htmlEscape="false"/>
	                </div>
                </div>
            </div>
            <div class="col-sm-6 col-sm-push-6">
            	<div class="accountActions">
		            <button type="button" class="btn btn-primary btn-block js-close-account-popup-button" data-popup-title="<spring:theme code="text.account.closeAccount.popup.title"/>">
		                <spring:theme code="text.account.closeAccount.button"/>
		            </button>
		        </div>
            </div>
			<div class="col-sm-6 col-sm-pull-6">
				<div class="accountActions">
					<button type="button" class="btn btn-default btn-block backToHome">
						<spring:theme code="text.button.cancel" text="Cancel" />
					</button>
				</div>
			</div>
            <div class="display-none">
                <div id="popup_confirm_account_removal" class="js-close-account-popup">

                    <div class="modal-details row">
                        <spring:theme code="text.account.closeAccount.popup.confirm" />
                    </div>
                    <div class="modal-actions">
                        <div class="row">
                            <div>
                                <a class="btn btn-primary btn-block js-close-account-action">
                                    <spring:theme code="text.account.closeAccount.popup.action" />
                                </a>
                            </div>

                            <div>
                                <a class="btn btn-default btn-block closeColorBox">
                                    <spring:theme code="text.button.cancel" />
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

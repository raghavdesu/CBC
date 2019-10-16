<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="policyData" required="true" type="de.hybris.platform.commercefacades.insurance.data.InsurancePolicyData" %>
<%@ taglib prefix="agent" tagdir="/WEB-INF/tags/addons/financialacceleratorstorefront/responsive/agent" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:htmlEscape defaultHtmlEscape="true" />

<h2 class="accordion-item__heading accordion-item--valid js-toggle">
    <spring:theme code="checkout.multi.quoteReview.myAgent" text="My Agent"/>
    <span class="accordion-item__open" data-open="myAgentPanel"></span>
</h2>

<div id="myAgentPanel" class="accordion-item__body">
    <div class="col-md-9 col-sm-9 col-xs-12">
        <agent:agentInfo agent="${policyData.responsibleAgent}"/>
    </div>
</div>


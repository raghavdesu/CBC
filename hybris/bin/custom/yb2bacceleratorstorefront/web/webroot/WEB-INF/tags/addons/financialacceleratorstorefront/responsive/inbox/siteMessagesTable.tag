<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div class="tabbody">
    <div class="table">
        <div class="th section-header__heading hidden-xs hidden-sm">
            <div class="td1 section-header__heading--small-title">
                <label class="checkbox-label js-check-main">
                    <input type="checkbox" value="true">
                    <span class="checkbox-text"></span>
                </label>
            </div>
            <div class="td2 section-header__heading--small-title hidden-xs hidden-sm"><spring:theme
                    code="text.account.inbox.message.list.subject" text="Subject"/>
                <span class="sort js-sort" sort-code="title" sort-order="desc"></span></div>
            <div class="td3 section-header__heading--small-title"><spring:theme code="text.account.inbox.message.list.preview"
                                                                                text="Preview"/>
                <span class="sort js-sort" sort-code="content" sort-order="desc"></span></div>
            <div class="td4 section-header__heading--small-title"><spring:theme code="text.account.inbox.message.list.date"
                                                                                text="Date"/>
                <span class="sort js-sort active" sort-code="sentdate" sort-order="desc"></span>
            </div>
        </div>
        <div class="message-content">
        </div>	
        <div class="no-messages-info margin-t-20 no-show">
            <spring:theme code="text.site.message.no.messages"/>
        </div>
    </div>
</div>
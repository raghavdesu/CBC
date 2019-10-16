ACC.quotereview = {

    isQuoteBindUrl: ACC.config.contextPath + '/checkout/multi/isQuoteBind',
    isQuoteReferredUrl: ACC.config.contextPath + '/checkout/multi/isQuoteReferred',
    bindQuoteUrl: ACC.config.contextPath + '/checkout/multi/bindQuote',
    quoteReviewUrl: ACC.config.contextPath + '/checkout/multi/quote/review',
    popupCheckoutButtonConfirmationDivId: '#popup_confirm_bind_quote',
    popupCheckoutReferredQuoteConfirmationId: '#popup_referred_quote',

    _autoload: [
        'bindAddOptions',
        'quoteReviewCheckoutButton'
    ],

    bindAddOptions: function () {
        var $planInfo = $('.js-quotePlanInfoSection');
        $planInfo.find('.header').click(function () {
            $planInfo.find('.content').slideToggle();
        });
    },

    quoteStatus: function (location, requestType) {
        return $.ajax({
            url: location,
            type: requestType,
            dataType: 'text'
        });
    },

    popupConfirmationBox: function (url, closeButton) {
        ACC.colorbox.open('', {
            inline: true,
            fixed: true,
            href: url,
            onOpen: function(){
                $(closeButton).on('click', function () {
                    $.colorbox.close();
                });
            }
        });
    },

    quoteReviewCheckoutButton: function () {
        var $checkoutSubmitForm = $('.js-certifyForm');
        var $checkoutButton = $checkoutSubmitForm.find('.js-checkoutBtn');
        $checkoutButton.on('click', function (e) {
            e.preventDefault();
            ACC.quotereview.quoteStatus(ACC.quotereview.isQuoteBindUrl, 'GET').done(function(isQuoteBinded) {
                if (isQuoteBinded === 'true') {
                    ACC.quotereview.quoteStatus(ACC.quotereview.isQuoteReferredUrl, 'GET').done(function(isReferred) {
                        if (isReferred === 'true') {
                            ACC.quotereview.popupConfirmationBox(ACC.quotereview.popupCheckoutReferredQuoteConfirmationId, '#referredQuoteCancel');
                        } else {
                            $checkoutSubmitForm.submit();
                        }
                    });
                }
                else {
                    ACC.quotereview.popupConfirmationBox(ACC.quotereview.popupCheckoutButtonConfirmationDivId, '#cancelButton');
                }
            });
        });

        $('#yesButton').on('click', function () {
            $('#certifyDescription, .modal-actions').remove();
            $('#processingBindQuote').show();
            $('#jsLoading').addClass('loading');
            ACC.quotereview.quoteStatus(ACC.quotereview.bindQuoteUrl, 'POST').done(function(isBinded) {
                if (isBinded === 'true') {
                    $checkoutSubmitForm.submit();
                } else {
                    window.location.href = ACC.quotereview.quoteReviewUrl;
                }
            });
        });
    }
};

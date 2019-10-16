ACC.insurance_cart = {

    addToCartType: 'addToCart',
    comparisonTables: '#tab_content',
    changePlanType: 'changePlan',
    popupId: '#popup_confirm_plan_removal',
    cartPageUrl: ACC.config.contextPath + '/cart',
    checkFormDataUrl: ACC.config.contextPath + '/cart/rollover/checkFormData',
    cartItemsList: $('.js-cartItemsList'),

    _autoload: [
        'addToCartAction',
        'addPotentialProductToCartAction',
        'removePotentialProductFromCartAction'
    ],

    submitFormAction: function(button, form, type, isSaveCart) {
        //off event is needed to clear piled up click events caused by pop-up
        button.off('click').on('click', function () {
            ACC.insurance_cart.submitFormActionFunction(form, type, isSaveCart);
        });
    },

    submitFormActionFunction: function (form, type, isSaveCart) {
        if (type === ACC.insurance_cart.changePlanType) {
            form.submit();
        } else if (type === ACC.insurance_cart.addToCartType) {
            ACC.insurance_cart.appendSaveCartValue(form, isSaveCart);
            $.ajax({
                url: form.attr('action'),
                type: 'POST',
                dataType: 'json',
                data: form.serialize(),
                success: function (data) {
                    if (data.result.success === 'true') {
                        window.location.href = ACC.insurance_cart.cartPageUrl;
                    }
                }
            });
        }
        parent.$.colorbox.close();
    },

    appendSaveCartValue: function(form, value) {
        $('<input>').attr('type', 'hidden').attr('name', 'isSaveCart').attr('value', value).appendTo(form);
    },

    appendIsSameProductGroup: function(form, value) {
        $('<input>').attr('type', 'hidden').attr('name', 'isSameProductGroup').attr('value', value).appendTo(form);
    },

    appendShouldRecalculateOnly: function(form, value) {
        $('<input>').attr('type', 'hidden').attr('name', 'shouldRecalculateOnly').attr('value', value).appendTo(form);
    },

    // Function for adding products to cart
    addToCartAction: function() {
        $(ACC.insurance_cart.comparisonTables).addClass('active');
        $('.js-addToCartForm .js-submit').each(function () {
            var $formButton = $(this);
            var $form = $formButton.parent();
            $formButton.on('click', function (){
                return ACC.insurance_cart.triggerAddToCartForm($form);
            });
        });
    },

    triggerAddToCartForm: function(form) {
        $.ajax({
            url: ACC.insurance_cart.checkFormDataUrl,
            type: 'GET',

            dataType: 'json',
            success: function() {
                $.ajax({
                    url: form.data('handlerpath'),
                    type: 'POST',
                    dataType: 'json',
                    data: form.serialize(),
                    success: function (data) {
                        if (data.result.success === 'true') {
                            window.location.href = ACC.insurance_cart.cartPageUrl;
                        }
                        else {
                            if (data.result.cartUpperLimitReached === 'true') {
                                if (data.result.sameProductGroup === 'true') {
                                    ACC.insurance_cart.appendIsSameProductGroup(form, true);
                                    if (data.result.recalculateOnly === 'true') {
                                        ACC.insurance_cart.appendShouldRecalculateOnly(form, true);
                                    }
                                    ACC.insurance_cart.submitFormActionFunction(form, ACC.insurance_cart.addToCartType);
                                }
                                else {
                                    ACC.insurance_cart.popupConfirmationBox(form, ACC.insurance_cart.addToCartType);
                                }
                            }
                            else {
                                window.location.href = ACC.insurance_cart.cartPageUrl;
                            }
                        }
                    }});
            }
        });
        return false;
    },

    // Function for adding optional products to cart
    addPotentialProductToCartAction: function() {
        ACC.insurance_cart.cartItemsList.addClass('active');
        $('.js-addPotentialProductToCartForm').on('click', function () {
            $(this).prop('disabled', true);
            var productCode = $(this).attr('id').split('-');
            var form = $('#addPotentialProduct' + productCode[1] );
            form.submit();
        });
    },

    // Function for removing optional products from cart
    removePotentialProductFromCartAction: function () {
        $('.js-remove-entry-button').on('click', function () {
            $(this).prop('disabled', true);
            var entryNumber = $(this).attr('id').split('_');
            var form = $('#updateCartForm' + entryNumber[1]);
            var productCode = form.find('input[name=productCode]').val();
            var initialCartQuantity = form.find('input[name=initialQuantity]');
            var cartQuantity = form.find('input[name=quantity]');
            ACC.track.trackRemoveFromCart(productCode, initialCartQuantity.val());
            cartQuantity.val(0);
            initialCartQuantity.val(0);
            form.submit();
        });
    },

    // Popup for confirming plan change
    popupConfirmationBox: function(form, type) {
        ACC.colorbox.open('', {
            inline: true,
            fixed: true,
            href: ACC.insurance_cart.popupId,
            onComplete: function ()
            {
                $(this).colorbox.resize();
            },
            onOpen: function () {
                var $popupConfirmDiv = $(ACC.insurance_cart.popupId);
                ACC.insurance_cart.submitFormAction($('#saveProceedButton'), form, type, true);
                $popupConfirmDiv.find('#cancelButton').on('click', function () {
                    $.colorbox.close();
                });
            },
            onClosed: function() {
                form.find('input[name=isSaveCart]').remove();
            }
        });
    }
};

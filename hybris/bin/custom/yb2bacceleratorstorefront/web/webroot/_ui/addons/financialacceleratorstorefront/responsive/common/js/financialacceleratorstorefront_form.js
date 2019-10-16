ACC.insurance_form = {

    $continueBtn: $('#continueBtn'),
    $yFormSaveBtn: $('#yFormSaveBtn'),
    $yFormRecalculateBtn: $('.js-button-recalculate button'),
    $configureProductsForm: $('.configure-product-form'),
    orbeonForm: $('.xforms-form'),
    orbeonSaveButton: $('.fr-save-final-button button'),
    orbeonCalculateButton: $('.fr-validate-button button'),
    orbeonInputField: $('.xforms-input-input'),

    _autoload: [
        'triggerYFormSaveButton',
        'triggerYFormValidateButton',
        'changeContinueBtnHref',
        ['fsStepCheckoutNavbar', $('#checkoutProgress.js-fsStep').length > 0],
        ['claimsPolicies', $('body.page-claimsPage').length > 0]
    ],

    // Function for changing URL in category page (between 1st and 2nh checkout step)
    changeContinueBtnHref: function() {
        $('.pageType-CategoryPage #checkoutProgress a').on('click', function(){
            ACC.insurance_form.$continueBtn.attr('href', $(this).attr('href'));
        });
    },

    // Function for handling switching between FNOL checkout steps
    fsStepCheckoutNavbar: function() {
        var defaultHref = ACC.insurance_form.$continueBtn.attr('href');
        $('#checkoutProgress a').on('click', function(e) {
            e.preventDefault();
                ACC.insurance_form.$continueBtn.attr('href', $(this).attr('href'));
                //trigger form save
                ACC.insurance_form.orbeonSaveButton.trigger('click');
                //if not on Orbeon pages return the href's default behaviour
                if (ACC.insurance_form.orbeonForm.length === 0) {
                    window.location = $(this).attr('href');
                }
        });
        //If user clicks on continue button instead of item in progress bar
        //return the original href to continue button
        ACC.insurance_form.$continueBtn.on('click', function() {
            ACC.insurance_form.$continueBtn.attr('href', defaultHref);
        });
    },

    // Function for triggering yForm hidden save button
    triggerYFormSaveButton: function() {
        // Choose cover page - Insurance
        ACC.insurance_form.clickTouch(this.$continueBtn, ACC.insurance_form.orbeonSaveButton);
        // Product configuration page - Banking
        ACC.insurance_form.clickTouch(this.$yFormSaveBtn, ACC.insurance_form.orbeonSaveButton);

        // Personal details page - Insurance & Banking
        var $checkoutProgressLinks = $('#checkoutProgress').find('.js-step.disabled a');
        if (this.$continueBtn.length > 0) {
            $checkoutProgressLinks.each(function () {
                if ($(this).prop('href') !== '') {
                    var that = $(this);
                    ACC.insurance_form.clickTouch(that, ACC.insurance_form.orbeonSaveButton);
                }
            });
        }
    },

    // Function for triggering yForm hidden validate button
    triggerYFormValidateButton: function() {
        ACC.insurance_form.clickTouch(ACC.insurance_form.$yFormRecalculateBtn, ACC.insurance_form.orbeonCalculateButton);
        ACC.insurance_form.$configureProductsForm.parents('form').on('change keyup', function() {
            //checks if the form has changed or key has been pressed while on form field
            if (ACC.insurance_form.$configureProductsForm.find('.xforms-active').length > 0 ) {
                //if any errors are present ENABLES Calculate button, so recalculation can be done
                ACC.insurance_form.$yFormRecalculateBtn.css('pointer-events', 'auto');
            }
        });
    },

    // Function for triggering Orbeon's hidden button and indetifying if it's mobile or desktop device
    // so appropriate event is called
    clickTouch: function(selector, buttonType) {
        var buttonScroll;
        var eventTrigger = ACC.insurance.mobileTest ? 'touchend' : 'click';
        selector.on('touchstart', function() {
        //Sets the postion of user's finger when touchstart occures (needed for disabling click when swiping)
            buttonScroll = $(window).scrollTop();
        });
        selector.on(eventTrigger, function() {
            if (eventTrigger === 'touchend' && Math.abs($(window).scrollTop() - buttonScroll) > 3) {
                //Checks whether user has touched or swiped while on calculate/continue button on mobile devices
                return false;
            }
            //Disable CALCULATE button to prevent agressive clicking if form is without any errors
            if (selector === ACC.insurance_form.$yFormRecalculateBtn && ACC.insurance_form.$configureProductsForm.find('.xforms-active').length < 1) {
                ACC.insurance_form.$yFormRecalculateBtn.css('pointer-events', 'none');
            }

            ACC.insurance_form.orbeonInputField.blur();//needed for some IOS devices so Continue button may work if focus is on some input field
            buttonType.trigger('click');
            return false;
        });
    },

    // Function called in Orbeon's properties-insurance.xml and properties-banking.xml
    nextFormPage: function (shouldRedirect) {

        if (ACC.insurance_form.$continueBtn.length > 0) {

            window.location = ACC.insurance_form.$continueBtn.attr('href');

        } else if (ACC.insurance_form.$yFormSaveBtn.length > 0) {

            var $form = ACC.insurance_form.$yFormSaveBtn.parent();

            // Busy spinner on mobile or desktop
            if (ACC.insurance.mobileTest) {
                $('#mobile-spinner.js-spinner').show();
            } else {
                $('#desktop-spinner.js-spinner').show();
            }

            // Indicating if Add To Cart is requested (with redirect) or Recalculation (without redirect)
            if (shouldRedirect) {
                ACC.insurance_cart.triggerAddToCartForm($form);
                $('.js-spinner').hide();
                ACC.insurance_form.$yFormRecalculateBtn.css('pointer-events', 'auto');
            } else {
                $.ajax({
                    url: $form.data('updateconfigurationpath'),
                    type: 'POST',
                    data: $form.serialize()
                }).done(function (data) {
                    $('#js-dynamic-cart').html(data);
                    //When AJAX finishes reenable the calculate button and hide the spinner
                    $('.js-spinner').hide();
                    ACC.insurance_form.$yFormRecalculateBtn.css('pointer-events', 'auto');
                });
            }
        }
    },
    //Claims entry page (FNOL 0) - selecting and verifying policies
    claimsPolicies: function() {
        var currentClaim = $('.claims');
        var policySubmit = $('.js-submit-policy');
        var checkbox = $('.checkbox-label');
        var confirmationInput = $('#confirmation');
        //Selecting the policy on click
        currentClaim.on('click', function() {
            $(this).addClass('selected').siblings().removeClass('selected');
            //Taking selected policy's ID and passing it into the form
            var policyId = $(this).data('policy');
            var contractId = $(this).data('contract');
            $('#policyId').val(policyId);
            $('#contractId').val(contractId);
            //Checking whether checkbox is checked or not, and enabling the submit button if it is
            if (confirmationInput.prop('checked')) {
                policySubmit.removeAttr('disabled');
            }
        });
        //Checking if checkbox is checked and if the policy is selected,
        //and enabling the submit button based on that
        checkbox.on('click', function(){
            if (confirmationInput.prop('checked') === true && currentClaim.hasClass('selected')) {
                policySubmit.attr('disabled', function(index, attribute) {
                    return attribute === 'disabled' ? null : 'disabled';
                });
            }
        });
    }
};

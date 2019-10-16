ACC.insurance = {

    mobileTest: /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent),
    iosTest: /iPhone|iPad|iPod/i.test(navigator.userAgent),
    getTabContentUrl: ACC.config.contextPath + '/c/tab/',
    getInboxTabContentUrl: 'inbox/tab',
    popupDivId_RetrieveQuote: '#popup_confirm_retrieve_quote',
    tooltip: '.js-tooltip',
    tip: '.js-tip',

    screenSm: 1023,
    maxHeight: -1,
    cboxWidth: '',
    dragging: false,
    viewPort: $('html,body'),
    homePage: $('.banner__component a').attr('href'),
    myAccountLinksHeader: $('.js-nav-links').find('.js-myAccount-toggle'),
    findAgent: $('.js-nav-links').find('.js-find-agent-link, .js-find-branch-link').parent(),
    login: $('.js-nav-links').find('.log-in-link').parent(),
    logout: $('.js-nav-links').find('.userSign').parent(),
    mobileNav: $('.navigation__overflow'),
    mobileNavAccLnk: $('.navigation__overflow').find('.js-userAccount-Links'),
    productLinks: $('.navigation__overflow').find('.js-offcanvas-links'),
    languageSwitcher: $('#langCurrSwticher').find('.js-language'),
    currencySwitcher: $('#langCurrSwticher').find('.js-currency'),
    search: $('.site-search'),
    searchInput: $('.js-site-search-input'),
    searchBtn: $('.js-btn-search'),
    detailsTitle: $('.js-find-agent').find('.js-category-caption'),
    mandatoryBundleProduct: $('#mandatoryBundleProduct'),
    submitButton: $('.js-submit'),
    fullWidthContentWrapper: $('.full-width-content-wrapper'),
    footer: $('footer'),
    premiumGrid: $('.js-premium-grid'),
    bindCloseAccountButton: ACC.close.bindCloseAccountButton,
    divHeightArray: ['.js-optional-products', '.js-product-grid-item .js-price', '.js-product-grid-item .js-price-extended', '.js-pay-on-checkout', '.js-details > .js-product-name', '.js-addToCartForm', '.js-product-grid-item .js-details'], //Creating array of selectors needed to equalize element heights on checkout and product pages

    _autoload: [
        'mobileMenuShow',
        'signedUserToggleMenuPart',
        'activeNavItem',
        'touchMove',
        'searchShow',
        'mobileMenuHeight',
        'popUpEvents',
        'hoverOnMobile',
        'heightsOnResize',
        'findAgentAccordion',
        'equalizeHeights',
        ['moreFeatures', $('#tab_content').find('.no-show').length > 0],
        ['timerRedirect', $('#timer').length > 0],
        'termsMenuClick',
        'retrieveQuoteButton',
        'popupDeleteClaimConfirmationBox',
        'toggleAccordions',
        'toggleAccordionsPremiumCalendar',
        'bindTabAction',
        'displayToolTip',
        'enableAutoProduct',
        'foucRemove',
        'calendar',
        ['showSavedPayments', $('#viewSavedPayments').length > 0]
    ],

    //Adding my account link and language/currency switchers to mobile menu since the whole mobile menu is implemented through JS (acc.navigation.js)
    mobileMenuShow: function() {
        ACC.insurance.findAgent.clone().addClass('liUserSign').prependTo(ACC.insurance.mobileNavAccLnk);
        ACC.insurance.login.clone().addClass('liUserSign').prependTo(ACC.insurance.mobileNavAccLnk);
        ACC.insurance.logout.clone().addClass('liUserSign').prependTo(ACC.insurance.mobileNavAccLnk);
        ACC.insurance.languageSwitcher.add(ACC.insurance.currencySwitcher)
            .clone().addClass('hidden-md hidden-lg').appendTo(ACC.insurance.productLinks);
        // Sorting mobile menu items in right order (B2C bug)
        var mobileMenuReversedList = $('.js-myAccount-root');
        var mobileMenuList = mobileMenuReversedList.children().toArray().reverse();
        $(mobileMenuList).appendTo(mobileMenuReversedList);
    },
    //Setting active item in navigation
    activeNavItem: function() {
        var base = $('nav').data('category');
        var wordsArray = base.length > 0 ? base.split('_') : ' ';//if category attribute has a value, splits attribute based on _ and creates an array, else empty string
        var keyword = wordsArray[wordsArray.length - 1];//selects the last word in the array
        $('.js_nav__link').each(function() {
            var that = $(this);
            var navLink = that.find('a');
            var navLinkPath = navLink.attr('href');
            if(navLinkPath.indexOf(keyword) !== -1 ){
                navLink.addClass('active');
            }
        });
    },
    //Toogle menu - signed user
    signedUserToggleMenuPart: function () {
        $('.js_navigation--bottom .collapsed ').removeClass('collapsed'); // B2C adds this for bootstrap logic that is removed.
        var $toToggle = $('.offcanvasGroup1');
        $('.js_navigation--bottom').on('click', '.js-nav-collapse', function() {
            if($(this).hasClass('collapsed')) {
                $(this).toggleClass('collapsed');
                $(this).children('.myAcctExp').removeClass('glyphicon-chevron-down').addClass('glyphicon-chevron-up');
                $toToggle.slideToggle(400);
            } else {
                $(this).toggleClass('collapsed');
                $(this).children('.myAcctExp').removeClass('glyphicon-chevron-up').addClass('glyphicon-chevron-down');
                $toToggle.slideToggle(400);
            }
        });
    },
    //Checking touchmove event
    touchMove: function() {
        ACC.insurance.viewPort.on('touchmove', function() {
            ACC.insurance.dragging = true;
        });
    },
    //Show/hide search bar input field
    searchShow: function() {
        var inputCheck = (function checkInput (){
            if (ACC.insurance.search.hasClass('active')) {
                ACC.insurance.searchInput.focus();
            } else {
                ACC.insurance.searchInput.blur();
            }
            return checkInput;
        })();
        ACC.insurance.searchBtn.on('click', function() {
            ACC.insurance.search.toggleClass('active');
            inputCheck();
            //if mobile menu is opened close it!
            var menuOpen = $(document).find('.offcanvas');
            menuOpen.removeClass('offcanvas');
        });
    },

    //Setting the height of the mobile menu based on the viewport height
    mobileMenuHeight: function() {
        enquire.register('screen and (max-width:' + ACC.insurance.screenSm + 'px)', {
            match: function() {
                var mobileMenuHeightCalc = (function heightCheck () {
                    var paddingCalc = $('.branding-mobile').height() + 80;
                    ACC.insurance.mobileNav.height(window.innerHeight - paddingCalc);
                    return heightCheck;
                })();
                $(window).on('resize', function() {
                    //resizing mobile menu on device's orientation change
                    mobileMenuHeightCalc();
                });
                ACC.banking.footerAccordion(true);
            },
            unmatch: function() {
                ACC.insurance.mobileNav.height('auto');
                $(window).on('resize', function() {
                    //returning menu to desktop size
                    ACC.insurance.mobileNav.height('auto');
                });
                ACC.banking.footerAccordion(false);
            }
        });
    },

    //Trigger events for repositioning and resizing ColorBox popups
    popUpEvents: function () {
        $(document).on('cbox_complete', function() {
            //Getting the initial width of the popup after it's first appearance
            ACC.insurance.cboxWidth = $('#colorbox').width();
            if ($('#colorbox').is(':visible')) {
                // overriding B2C's fixed popup top position and width on mobile devices
                ACC.insurance.popUpPos(100, ACC.insurance.cboxWidth);
            }
        });
        //Resizing Colorbox popups on device's orientation change and on window resize
        $(window).on('resize', function() {
            if ($('#colorbox').is(':visible')) {
                ACC.insurance.popUpPos(50, ACC.insurance.cboxWidth);
            }
        });
    },

    //Reposition and resize Colorbox Popup function
    popUpPos: function (time, contentWidth) {
        var element = $('#colorbox');
        element.css({'opacity': 0});
        //selecting inner content of the popup, needed if the popup's content is overflowing
        //such is the case with Terms and conditions popup.
        var content = $('#cboxLoadedContent > *');
        //change the width of the popup only when window's size iz less than 770px
        var elWidth = $(window).width() < 770 ? '95%' : contentWidth;
        //When inner popup content has larger height than viewport set the popup to 95% height
        var elHeight = content.height() > $(window).height() ? '95%' : '';
        var resizeTimer;
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(function() {
            $.colorbox.resize({width: elWidth, height: elHeight});
            var newTopPosition = ($(window).height() - element.height()) / 2;
            element.css({'top': newTopPosition, 'position': 'fixed', 'opacity': 1});
        }, time);
    },

    //Disable :hover on mobile devices
    hoverOnMobile: function () {
        if (ACC.insurance.mobileTest) {
            try { // prevent exception on browsers not supporting DOM styleSheets properly
                for (var si in document.styleSheets) {
                    var styleSheet = document.styleSheets[si];
                    if (!styleSheet.rules)  {
                        continue;
                    }
                    for (var ri = styleSheet.rules.length - 1; ri >= 0; ri--) {
                        if (!styleSheet.rules[ri].selectorText) {
                            continue;
                        }
                        if (styleSheet.rules[ri].selectorText.match(':hover')) {
                            styleSheet.deleteRule(ri);
                        }
                    }
                }
            } catch (ex) {
                return;
            }
        }
    },

    //Accordion for Find an Agent page and scrolling to active category
    findAgentAccordion: function () {
        ACC.insurance.detailsTitle.on('click', function() {
            var $that = $(this);
            if($that.hasClass('active')) {
                $that.removeClass('active').next().slideUp().removeClass('opened');
                ACC.insurance.animateScroll(0);
            } else {
                $that.addClass('active').siblings().removeClass('active');
                $that.next().slideDown().addClass('opened')
                    .siblings('.js-category-content').slideUp().removeClass('opened');
                //wait for the animation slideUp or slideDown to finish then animate content into view
                setTimeout(function() {
                    ACC.insurance.animateScroll($that.offset().top);
                }, 400);
            }
        });
    },

    //Equalize heights on resize
    heightsOnResize: function () {
        $(window).on('resize', function() {
            setTimeout(function() {
                ACC.insurance.equalizeHeights();
            }, 300);
        });
    },

    //Function for equalizing heights of divs on product pages/checkout
    equalizeHeights: function () {
        $.each(ACC.insurance.divHeightArray, function(index, selector) {
            $(selector).each(function() {
                var that = $(this);
                $(selector).height('auto');
                ACC.insurance.maxHeight = ACC.insurance.maxHeight > that.height() ? ACC.insurance.maxHeight : that.height();
            });
            $(selector).each(function() {
                var that = $(this);
                that.height(ACC.insurance.maxHeight);
            });
            ACC.insurance.maxHeight = -1;
        });
    },

    //More features function for comparison tables
    moreFeatures: function () {
        var hiddenContent = $('#tab_content').find('.no-show');
        $('#tab_content').on('click', '.js-more-features', function(e) {
            e.preventDefault();
            var $that = $(this);
            if ($that.hasClass('open')) {
                $that.removeClass('open');
                hiddenContent.slideUp();
                $('#tab_content').find('.separator').slideDown();
            } else {
                $that.addClass('open');
                hiddenContent.slideDown();
                $('#tab_content').find('.separator').slideUp();
            }
            ACC.insurance.equalizeHeights();
        });
    },

    //Disabling back button on "Contact an agent - thank you page" and implemented page redirect
    timerRedirect: function () {
        history.pushState({ page: 1 }, 'Title 1', '#no-back');
        window.onhashchange = function () {
            window.location.hash = 'no-back';
        };
        var timerHolder = $('#timer');
        var count = 6;
        setInterval(function() {
            count--;
            timerHolder.text(count + ' seconds');
            if (count === 0) {
                window.location = ACC.insurance.homePage;
            }
        }, 1000);
    },

    termsMenuClick: function () {
        $('.page-termsAndConditions .container__full').on('click', 'a', function() {
            var target = $(this.hash);
            ACC.insurance.animateScroll(target.offset().top);
        });
    },

    //Function for animating content into view
    animateScroll: function (position) {
        ACC.insurance.viewPort.animate({
            scrollTop: position
        }, 600);
    },

    // Function for retrieving quotes
    retrieveQuoteButton: function() {
        $('#myQuotesList').find('.js-retrieveBtn').on('click', function(e){
            var $formButton = $(this);
            var $form = $formButton.parents('form');
            ACC.insurance.popupRetrieveQuoteConfirmationBox($form, e);
        });
    },

    // Function for confirming quote retrieve
    popupRetrieveQuoteConfirmationBox: function(form, event) {
        event.preventDefault();
        var quoteCode = form.find('input[name="code"]').val();
        var cartCode = form.find('input[name="cartCode"]').val();
        if (quoteCode === cartCode) {
            form.submit();
        }
        else {
            $(document).on('click', '.js-retrieveBtn', function () {
                ACC.colorbox.open('', {
                    inline: true,
                    href: ACC.insurance.popupDivId_RetrieveQuote,
                    fixed: true,
                    onOpen: function(){
                        var $popupConfirmDiv = $(ACC.insurance.popupDivId_RetrieveQuote);
                        $popupConfirmDiv.find('#cancelButton').on('click', function () {
                            $.colorbox.close();
                        });
                        $popupConfirmDiv.find('#saveProceedButton').on('click', function(){
                            ACC.insurance_cart.appendSaveCartValue(form, true);
                            form.submit();
                        });
                    }
                });
            });
        }
    },

    // Function for showing a popup for claim deletion
    popupDeleteClaimConfirmationBox: function() {
        $(document).on('click', '.js-deleteClaimButton', function () {
            var claimNumber = $(this).data('claimNumber');
            ACC.colorbox.open('', {
                inline: true,
                fixed: true,
                href: '#popup_confirm_claim_deletion_' + claimNumber,
                onComplete: function () {
                    $(this).colorbox.resize();
                }
            });
        });
    },

    // Function for toggling accordions in checkout pages
    toggleAccordions: function() {
        $('.js-toggle').click(function(){
            var $that = $(this);
            if ($that.hasClass('active')) {
                $that.removeClass('active').next().slideUp(function() {
                    $that.removeClass('opened');
                });
            } else {
                $that.addClass('active').next().slideDown().addClass('opened');
            }
        });
    },
    // Function for toggling accordions in premium calendar
    toggleAccordionsPremiumCalendar: function() {
        var eventTrigger = ACC.insurance.mobileTest ? 'touchend' : 'click';
        var triggerElement = '.js-collapse';
        var accordionElement = '.js-accordion';
        enquire.register('screen and (max-width:' + ACC.insurance.screenSm + 'px)', {
            match: function() {
                ACC.insurance.premiumGrid.on(eventTrigger, triggerElement, function() {
                    var $that = $(this);
                    if($that.hasClass('active')){
                        $that.next(accordionElement).slideUp(function() {
                            $that.removeClass('active');
                        });
                    } else {
                        $that.next(accordionElement).slideDown(function() {
                            $that.addClass('active');
                        });
                    }
                });
            }
        }).register('screen and (min-width:' + ACC.insurance.screenSm + 'px)', {
            match: function() {
                ACC.insurance.premiumGrid.on(eventTrigger, triggerElement, function() {
                    var $that = $(this);
                    if($that.hasClass('active')){
                        $that.children(accordionElement).slideUp(function() {
                            $that.removeClass('active');
                        });
                    } else {
                        $that.children(accordionElement).slideDown(function() {
                            $that.addClass('active');
                        });
                    }
                });
            }
        });
    },
    foucRemove: function () {
        ACC.insurance.fullWidthContentWrapper.fadeIn(300);
        ACC.insurance.footer.fadeIn(100);
    },

    //*****************************************************************//
    //******************** Comparison table block ********************//
    //***************************************************************//

    // Function for activating tab
    activeTabSwitch: function($main) {
        $('.js-multi-tabs .js-tab').each(function ()
        {
            var $tab = $(this);
            $tab.removeClass('active');
        });
        $main.addClass('active');
    },

    // Function for getting tab content
    getTabContent: function($main) {
        $.get(ACC.insurance.getTabContentUrl + $main.attr('id'), function (result) {
            var isSessionExpires = $('#isSessionExpires', $(result)).html();
            if(isSessionExpires === 'true') {
                window.location = ACC.config.contextPath;
            }
            var $result = $('<div />').append(result).html();
            $('#tab_content').html($result);
            ACC.insurance.displayToolTip();
            ACC.insurance_cart.addToCartAction();
            ACC.insurance.equalizeHeights();
        });
    },

    // Function for switching between tabs in comparison table
    bindTabAction: function() {
        $('.js-multi-tabs .js-tab').each(function () {
            var $tab = $(this);
            $tab.on('click', function(){
                ACC.insurance.activeTabSwitch($tab);
                ACC.insurance.getTabContent($tab);
            });
        });
    },

    // Function for opening tooltips in comparison tables

    isItScrolled: function( startPoint, endPoint ) { // Function for determing if event is touch or swipe
        return Math.abs(startPoint - endPoint) > 3;
    },
    displayToolTip: function() {
        var touchStart;
        var touchEnd;
        var eventTrigger = ACC.insurance.mobileTest ? 'touchend' : 'click';
        var closeAllTips = function() {  // If visible, hide element and remove it`s active class
            if ($(ACC.insurance.tip).is(':visible')) {
                $(ACC.insurance.tip).hide(400);
                $(ACC.insurance.tooltip).removeClass('active');
            }
        };
        var toggleToolTips = function(holderTooltip) { // Toggle tip div by checking if its tooltip element is active
            if(!$(holderTooltip).hasClass('active')) { // If tooltip element doesn`t have class active, first close all tips, then toggle clicked tip
                var $tip = $(holderTooltip).next(ACC.insurance.tip); // Set tip selector according to tooltip element

                closeAllTips();
                $tip.toggle(400, function() {
                    $(this).siblings('.js-tooltip').addClass('active');
                });
                if(ACC.insurance.mobileTest) { // If toggling tip element on mobile device, add tip repositioning functionality
                    setTimeout(function() {
                        ACC.insurance.animateScroll($tip.offset().top - 20);
                    }, 400);
                }
            } else { // If tooltip element has class active, simply close all tips
                closeAllTips();
            }
        };
        $(ACC.insurance.tooltip).on('touchstart', function() { // Set touch start y coordinate so we can later determine if user has touched or swiped
            touchStart = $(window).scrollTop();
        });
        $(ACC.insurance.tooltip).on(eventTrigger, function() {
            touchEnd =  $(window).scrollTop(); // Set touch end y coordinate so we can determne if user has touched or swiped
            if (ACC.insurance.mobileTest) { // Check if mobile, if it is, we have to check if user swiped or touched
                if(!ACC.insurance.isItScrolled(touchStart, touchEnd)) {
                    toggleToolTips($(this));
                }
            } else {
                toggleToolTips($(this)); // If desktop, we toggle tip, it`s click event for sure
            }
        });

        $('.js-close-tip').on(eventTrigger, function() {
            closeAllTips();
        });
        $(document).keydown(function (event) {
            if (event.which === 27) {
                closeAllTips();
            }
        });
        $(document).on('touchend', function(event) {
            // Check if touch happend on tooltip element, if true, ignore event
            if(!$(event.target).is('ACC.insurance.tooltip') && $(ACC.insurance.tip).siblings('.js-tooltip').hasClass('active'))
            {
                closeAllTips();
            }
        });
    },

    // Function for enabling Monthly Auto Insurance
    enableAutoProduct: function() {
        var mandatoryOptionalId = ACC.insurance.mandatoryBundleProduct.attr('data-code');
        if(mandatoryOptionalId !== undefined) {
            ACC.insurance.submitButton.each(function () {
                var $that = $(this);
                if ($that.attr('id') === mandatoryOptionalId) {
                    $that.attr('disabled', 'disabled');
                }
                ACC.insurance.mandatoryBundleProduct.removeAttr('checked');
            });
            ACC.insurance.mandatoryBundleProduct.click(function() {
                if($(this).is(':checked')){
                    ACC.insurance.submitButton.each(function () {
                        var $that = $(this);
                        if($that.attr('id') === mandatoryOptionalId) {
                            $that.removeAttr('disabled');
                        }
                    });
                } else {
                    ACC.insurance.submitButton.each(function () {
                        var $that = $(this);
                        if($that.attr('id') === mandatoryOptionalId) {
                            $that.attr('disabled', 'disabled');
                        }
                    });
                }
            });
        }
    },
    //*****************************************************************//
    //******************* Comparison table block END *****************//
    //***************************************************************//

    //Function for triggering  popup with saved payment details on Payment Details checkout step
    showSavedPayments: function () {
        $(document).on('click', '.js-view-payments', function(){
            var data = $('#savedPaymentList');
            ACC.colorbox.open('', {
                inline: true,
                fixed: true,
                href: data
            });
        });
    },
    //Date picker
    calendar: function () {
        $('.js-calendar').datepicker({
            dateFormat: 'dd-mm-yy',
            changeYear: true,
            changeMonth: true,
            yearRange: '-100:c'
        });
    }
};

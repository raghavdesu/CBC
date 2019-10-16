ACC.banking = {

    bankingPage: $('.banking'),
    footerLeft: $('.footer__left'),
    mobileNav: $('.js_navigation--bottom'),

    _autoload: [
        'enableMobileBankingLanguageSelector'
    ],

    // Enabling language selector in mobile menu. B2C renders two language selector forms with same IDs.
    enableMobileBankingLanguageSelector: function () {
        var langSelector = ACC.banking.mobileNav.find('#lang-selector'),
            langForm = ACC.banking.mobileNav.find('#lang-form');
        langSelector.change(function(){
            langForm.submit();
        });
    },
    //Accordion for footer in both Insurance and Banking sites!
    footerAccordion : function (bool) {
        var $title = ACC.banking.footerLeft.find('.footer__nav--container .title');
        var $links = ACC.banking.footerLeft.find('.footer__nav--links');
        var eventAccordion;
        var firstPositionOfScroll;
        if(ACC.insurance.mobileTest) {
            eventAccordion = 'touchend';
        } else {
            eventAccordion = 'click';
        }
        if(bool) {
            $title.off(eventAccordion);
            $title.on('touchstart', function() {
                firstPositionOfScroll = $(window).scrollTop();
            });
            $title.on(eventAccordion, function() {
                if (eventAccordion === 'touchend' && (Math.abs($(window).scrollTop()-firstPositionOfScroll)>3) ) {
                    return;
                }
                var $that = $(this);
                if($that.hasClass('active')) {
                    $that.removeClass('active').next().slideUp().removeClass('opened');
                } else {
                    $that.addClass('active').siblings().removeClass('active');
                    $that.next().slideDown().addClass('opened');
                }
            });
            $links.hide();
        } else {
            $title.off(eventAccordion).removeClass('active');
            $links.show();
        }
    }
};

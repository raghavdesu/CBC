ACC.financial_termsandconditions = {
    _autoload: [
        'bindTermsAndConditionsLink'
    ],
    bindTermsAndConditionsLink: function() {
        $('.terms-and-conditions-link').click(function(e) {
            e.preventDefault();
            ACC.colorbox.open('', {
                href: $(this).attr('href'),
                fixed: true,
                maxWidth : '800px',
                width : '100%',
                height: '80%',
                onComplete: function () {
                    ACC.common.refreshScreenReaderBuffer();
                    $('#cboxLoadingOverlay').remove();
                    $('#cboxLoadingGraphic').remove();
                },
                onClosed: function() {
                    ACC.common.refreshScreenReaderBuffer();
                }
            });
        });
    }
};

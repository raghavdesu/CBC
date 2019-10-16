ACC.insurance_b2b = {
    commerceOrgProducts: $('#selectProducts'),
    _autoload: [
        ['bindToToggleProduct', $('.page-my-company').length > 0],
        ['addOrRemoveProductFromUnit', $('.page-manageUnits').length > 0]
    ],

    bindToToggleProduct: function() {
        ACC.insurance_b2b.commerceOrgProducts.on('click','.action-links', function(e){
            e.preventDefault();
            var url = $(this).attr('url');
            var state = this.parentNode.parentNode.getElementsByClassName('js-state')[0].innerText;
            // Toggle selected class and change tile`s state text
            $(this).parents('.card').toggleClass('selected').find('.js-state').text(state === 'Active' ? 'Disabled' : 'Active');
            // Send Data to BE
            $.postJSON(url,{});
            // Check new state and set new url for next click
            url = state === 'Active' ? url.replace('deselect', 'select') : url.replace('select', 'deselect');
            $(this).attr('url', url);
        });
    },
    addOrRemoveProductFromUnit: function(){ //Commerce org, manage units "add/remove cards" script
        var $notAssignedProductsContainer = $('#not-assigned-products');
        var $assignedProductsContainer = $('#assigned-products');
        var $notAssignedCounter = $notAssignedProductsContainer.parent().prev('.account-list-header').children('.counter');
        var $assignedCounter = $assignedProductsContainer.parent().prev('.account-list-header').children('.counter');
        var assignedCounter = parseInt($assignedCounter.text()); // Get counters inital state
        var notAssignedCounter = parseInt($notAssignedCounter.text());
        function changeCounterState( productAddedOrRemoved) {
            if ( productAddedOrRemoved === 'adding') {
                $assignedCounter.text(++assignedCounter);
                $notAssignedCounter.text(--notAssignedCounter);
            } else if (productAddedOrRemoved === 'removing') {
                $assignedCounter.text(--assignedCounter);
                $notAssignedCounter.text(++notAssignedCounter);
            }
        }
        $('#toggle-units').on('click','.js-product-status',function(){
            var $that = $(this);
            var card =  $that.closest('.card');
            $.ajax({
                url: $(this).attr('data-url'),
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                data: {product: $(this).attr('data-productid'), unit: $(this).attr('data-unitid')},
                success:function (data) {
                    var ajaxUrl = this.url;
                    var parentContainer = $that.closest('.row');
                    var urlParameter =  $(parentContainer).attr('id') === 'assigned-products' ?
                        ajaxUrl.replace('/deassign', '/assign') :
                        ajaxUrl.replace('/assign', '/deassign');
                    card.remove();
                    if( $(parentContainer).attr('id') === 'assigned-products') { // by parent`s container id we know where to put the current card
                        $($that).attr('data-url', urlParameter); // modify url for future ajax call
                        $notAssignedProductsContainer.append(card);
                        changeCounterState('removing');
                    } else {
                        $($that).attr('data-url', urlParameter);
                        $assignedProductsContainer.append(card);
                        changeCounterState('adding');
                    }
                }
            });
        });
    },
};

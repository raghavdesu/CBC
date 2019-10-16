ACC.autocomplete = {

    _autoload: [
        'bindSearchAutocomplete',
        'bindDisableSearch'
    ],

    // Function for rendering product category name in search autocomplete
    bindSearchAutocomplete: function ()
    {
        // extend the default autocomplete widget, to solve issue on multiple instances of the searchbox component
        $.widget( 'custom.yautocomplete', $.ui.autocomplete, {
            _create:function(){

                // get instance specific options form the html data attr
                var option = this.element.data('options');
                // set the options to the widget
                this._setOptions({
                    minLength: option.minCharactersBeforeRequest,
                    displayProductImages: option.displayProductImages,
                    delay: option.waitTimeBeforeRequest,
                    autocompleteUrl: option.autocompleteUrl,
                    source: this.source
                });

                // call the _super()
                $.ui.autocomplete.prototype._create.call(this);

            },
            options:{
                cache:{}, // init cache per instance
                focus: function (){return false;}, // prevent textfield value replacement on item focus
                select: function (event, ui){
                    window.location.href = ui.item.url;
                }
            },
            _renderItem : function (ul, item){
                var renderHtml;
                if (item.type === 'autoSuggestion'){
                    renderHtml = '<a href="'+ item.url + '" ><div class="name">' + item.value + '</div></a>';
                    return $('<li>')
                            .data('item.autocomplete', item)
                            .append(renderHtml)
                            .appendTo(ul);
                }
                else if (item.type === 'productResult'){

                    renderHtml = '<a href="' + item.url + '" >';

                    renderHtml += '<div class="name">' + item.value + '</div>';
                    renderHtml += '<div class="category">' + item.category + '</div>';
                    renderHtml += '</a>';

                    return $('<li>').data('item.autocomplete', item).append(renderHtml).appendTo(ul);
                }
            },
            source: function (request, response)
            {
                var self=this;
                var term = request.term.toLowerCase();
                if (term in self.options.cache)
                {
                    return response(self.options.cache[term]);
                }

                $.getJSON(self.options.autocompleteUrl, {term: request.term}, function (data)
                {
                    var autoSearchData = [];
                    if(data.suggestions !== null){
                        $.each(data.suggestions, function (i, obj)
                        {
                            autoSearchData.push({
                                value: obj.term,
                                url: ACC.config.encodedContextPath + '/search?text=' + obj.term,
                                type: 'autoSuggestion'
                            });
                        });
                    }
                    if(data.products !== null){
                        $.each(data.products, function (i, obj)
                        {
                            autoSearchData.push({
                                value: obj.name,
                                code: obj.code,
                                category: obj.bundleTemplates[0].products[0].defaultCategory.name,
                                url:  ACC.config.encodedContextPath + obj.bundleTemplates[0].products[0].defaultCategory.url,
                                type: 'productResult'
                            });
                        });
                    }
                    self.options.cache[term] = autoSearchData;
                    return response(autoSearchData);
                });
            }

        });


        var $search = $('.js-site-search-input');
        if($search.length>0){
            $search.yautocomplete();
        }
    },

    bindDisableSearch: function ()
    {
        $('#js-site-search-input').keyup(function(){
            $('#js-site-search-input').val($('#js-site-search-input').val().replace(/^\s+/gm,''));
            $('.js_search_button').prop('disabled', this.value === '' ? true : false);
        });
    }

};

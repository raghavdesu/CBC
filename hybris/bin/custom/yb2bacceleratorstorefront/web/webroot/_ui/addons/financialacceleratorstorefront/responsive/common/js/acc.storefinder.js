ACC.storefinder = {
    storeFinder : $('#storeFinder'),
    pageBtn : '.js-store-finder-pager-prev, .js-store-finder-pager-next',
    storeData:"",
    storeId:"",
    coords:{},
    storeSearchData:{},
    _autoload: [
        "init",
        "bindStoreChange",
        "bindSearch",
        "bindPagination"
    ],

    createListItemHtml: function (data,id) {
        var item="";
        item+='<li class="list__entry">';
        item+='<input type="radio" name="storeNamePost" value="'+data.name+'" id="store-finder-entry-'+id+'" class="js-store-finder-input" data-id="'+id+'">';
        item+='<label for="store-finder-entry-'+id+'" class="js-select-store-label">';
        item+='<span class="entry__info">';
        item+='<span class="entry__name">'+data.name+'</span>';
        $.each(data.pointsOfService, function(key, val){
            item+='<span class="entry__pos">'+val.posName+': '+'</span>';
            item+='<span class="entry__address">'+val.line1+' '+val.line2+'</span><br>';
        });
        item+='<span class="entry__city">'+data.pointsOfService[0].town+'</span>';
        item+='</span>';
        item+='<span class="entry__distance">';
        $.each(data.pointsOfService, function(key, val){
            item+='<span>'+val.formattedDistance+'</span>';
        });
        item+='</span>';
        item+='</label>';
        item+='</li>';
        return item;
    },

    refreshNavigation: function () {
        var listitems = "";
        var data = ACC.storefinder.storeData;
        if (data) {
            for ( var i = 0; i < data.data.length; i++) {
                listitems += ACC.storefinder.createListItemHtml(data.data[i],i);
            }
            $(".js-store-finder-navigation-list").html(listitems);
            // select the first store
            var firstInput= $(".js-store-finder-input")[0];
            $(firstInput).click();
        }
        var page = ACC.storefinder.storeSearchData.page;
        $(".js-store-finder-pager-item-from").html(page*ACC.storefinder.storeData.pageSize+1);
        var to = ((page*ACC.storefinder.storeData.pageSize+ACC.storefinder.storeData.pageSize)>ACC.storefinder.storeData.total)? ACC.storefinder.storeData.total : page*ACC.storefinder.storeData.pageSize+ACC.storefinder.storeData.pageSize ;
        $(".js-store-finder-pager-item-to").html(to);
        $(".js-store-finder-pager-item-all").html(ACC.storefinder.storeData.total);
        $(".js-store-finder").removeClass("show-store");
    },

    bindPagination: function () {
        ACC.storefinder.storeFinder.on('click', ACC.storefinder.pageBtn, function(e) {
            e.preventDefault();
            var page = ACC.storefinder.storeSearchData.page;
            var currBtn = e.currentTarget.className;
            if (currBtn.indexOf('js-store-finder-pager-prev') !== -1) {
                ACC.storefinder.getStoreData(page-1);
                checkStatus(page-1);
            } else {
                ACC.storefinder.getStoreData(page+1);
                checkStatus(page+1);
            }
        });
        function checkStatus(page) {
            if (page === 0){
                $(".js-store-finder-pager-prev").attr("disabled","disabled");
            } else {
                $(".js-store-finder-pager-prev").removeAttr("disabled");
            }
            if (page === Math.ceil(ACC.storefinder.storeData.total/ACC.storefinder.storeData.pageSize) - 1) {
                $(".js-store-finder-pager-next").attr("disabled","disabled");
            } else {
                $(".js-store-finder-pager-next").removeAttr("disabled");
            }
        }
    },

    bindStoreChange: function() {
        ACC.storefinder.storeFinder.on("change",".js-store-finder-input", function(e) {
            e.preventDefault();
            if (ACC.storefinder.storeData.total <= ACC.storefinder.storeData.pageSize) {
                $(".js-store-finder-pager-prev").attr("disabled","disabled");
                $(".js-store-finder-pager-next").attr("disabled","disabled");
            }
            var storeData = ACC.storefinder.storeData.data;
            var storeId = $(this).data("id");
            var $ele = $(".js-store-finder-details");
            $.each(storeData[storeId] ,function(key,value) {
                $ele.find(".js-store-name").html(storeData[storeId].name);
                if (key === "agentimage") {
                    if (value !==  "") {
                        $ele.find(".js-store-image").html('<img src="'+value+'" alt="" />');
                    } else {
                        $ele.find(".js-store-image").html('');
                    }
                }
                else if(key === "categories") {
                    var categories="";
                    $.each(value,function(key2,value2){
                        categories += "<li>"+value2.categoryName+"</li>";
                    });
                    $ele.find(".js-store-agents").html(categories);
                }
                else if(key === "pointsOfService") {
                    var lastItem = value[value.length - 1];
                    $.each(lastItem,function(key2,value2){
                        $ele.find(".js-store-"+key2).html(value2);
                    });
                }
                else if (key === "uid"){
                    var href  = "contact-agent?agent=" + value + "&activeCategory=";
                    $ele.find(".secondary-button.secondary-button__agent").attr("href", href);
                }
            });
            ACC.storefinder.storeId = storeData[storeId];
            ACC.storefinder.initGoogleMap();
        });
        ACC.storefinder.storeFinder.on('click','.js-select-store-label, .js-store-finder-details-back', function(e){
            var currBtn = e.currentTarget.className;
            if (currBtn.indexOf('js-select-store-label') !== -1) {
                $(".js-store-finder").addClass("show-store");
                var that = $(this);
                if (that.siblings().prop('checked') === true) {
                    that.siblings().trigger('change');//needed for 1st list item, otherwise no map is shown on mobile
                }
            } else {
                $(".js-store-finder").removeClass("show-store");
            }
        });
    },

    initGoogleMap : function() {
        if($("#storeFinder").length > 0) {
            ACC.global.addGoogleMapsApi("ACC.storefinder.loadGoogleMap");
        }
    },
    mapStyle :
        [
            {
                "elementType": "geometry",
                "stylers": [
                    {
                        "color": "#f5f5f5"
                    }
                ]
            },
            {
                "elementType": "labels.icon",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#616161"
                    }
                ]
            },
            {
                "elementType": "labels.text.stroke",
                "stylers": [
                    {
                        "color": "#f5f5f5"
                    }
                ]
            },
            {
                "featureType": "administrative.land_parcel",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#bdbdbd"
                    }
                ]
            },
            {
                "featureType": "poi",
                "elementType": "geometry",
                "stylers": [
                    {
                        "color": "#eeeeee"
                    }
                ]
            },
            {
                "featureType": "poi",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#757575"
                    }
                ]
            },
            {
                "featureType": "poi.park",
                "elementType": "geometry",
                "stylers": [
                    {
                        "color": "#e5e5e5"
                    }
                ]
            },
            {
                "featureType": "poi.park",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#9e9e9e"
                    }
                ]
            },
            {
                "featureType": "road",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "road",
                "elementType": "geometry",
                "stylers": [
                    {
                        "color": "#ffffff"
                    }
                ]
            },
            {
                "featureType": "road.arterial",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#757575"
                    }
                ]
            },
            {
                "featureType": "road.highway",
                "elementType": "geometry",
                "stylers": [
                    {
                        "color": "#dadada"
                    }
                ]
            },
            {
                "featureType": "road.highway",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#616161"
                    }
                ]
            },
            {
                "featureType": "road.local",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#9e9e9e"
                    }
                ]
            },
            {
                "featureType": "transit.line",
                "elementType": "geometry",
                "stylers": [
                    {
                        "color": "#e5e5e5"
                    }
                ]
            },
            {
                "featureType": "transit.station",
                "elementType": "geometry",
                "stylers": [
                    {
                        "color": "#eeeeee"
                    }
                ]
            },
            {
                "featureType": "water",
                "elementType": "geometry",
                "stylers": [
                    {
                        "color": "#c9c9c9"
                    }
                ]
            },
            {
                "featureType": "water",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#9e9e9e"
                    }
                ]
            }
        ],
    loadGoogleMap: function() {
        var pos = ACC.storefinder.storeId.pointsOfService;
        var centerPoint = new google.maps.LatLng(pos[0].latitude, pos[0].longitude);
        var styledMapType = new google.maps.StyledMapType(
            ACC.storefinder.mapStyle,
            {name: 'Styled Map'});
        var mapOptions = {
            zoom: 13,
            zoomControl: true,
            panControl: true,
            streetViewControl: false,
            mapTypeIds: ['roadmap', 'satellite', 'hybrid', 'terrain', 'styled_map'],
            center: centerPoint
        };
        var map = new google.maps.Map(document.getElementById("store-finder-map"), mapOptions);
        map.mapTypes.set('styled_map', styledMapType);
        map.setMapTypeId('styled_map');
        var marker;
        var infowindow = new google.maps.InfoWindow();
        for (var i = 0; i < pos.length; i++) {
            marker = new google.maps.Marker({
                position: new google.maps.LatLng(pos[i].latitude, pos[i].longitude),
                map: map,
                title: ACC.storefinder.storeId.name,
                icon: "https://maps.google.com/mapfiles/ms/icons/blue-dot.png"
            });
            google.maps.event.addListener(marker, 'click', (function(marker, i) {
                return function() {
                    infowindow.setContent(ACC.storefinder.storeId.name + '<br>' + '<b>' + pos[i].posName + '</b>' + '<br>' + pos[i].line1 + ' ' +pos[i].line2 + '<br>' +pos[i].town );
                    infowindow.open(map, marker);
                };
            })(marker, i));
        }
    },

    bindSearch: function() {
        ACC.storefinder.storeFinder.on('submit','#storeFinderForm', function(e) {
            e.preventDefault();
            var q = $('.js-store-finder-search-input').val();
            if (q.length > 0) {
                ACC.storefinder.getInitStoreData(q,ACC.storefinder.coords.latitude,ACC.storefinder.coords.longitude);
                $('.js-storefinder-alert').addClass('inactive');
            } else {
                $('.js-storefinder-alert').removeClass('inactive');
                $(".js-store-finder").hide();
            }
        });
        $(".closeAccAlert").on("click", function () {
            $('.js-storefinder-alert').addClass('inactive');
        });
    },

    getStoreData: function (page) {
        ACC.storefinder.storeSearchData.page = page;
        var url = $(".js-store-finder").data("url");
        $.ajax({
            url: url,
            data: ACC.storefinder.storeSearchData,
            type: "get",
            success: function (response) {
                try {
                    ACC.storefinder.storeData = $.parseJSON(response);
                    ACC.storefinder.refreshNavigation();
                    if (ACC.storefinder.storeData.total < ACC.storefinder.storeData.pageSize) {
                        $(".js-store-finder-pager-next").attr("enabled", "enabled");
                    }
                } catch (error) {
                    $(".js-store-finder").hide();
                }
            }
        });
    },

    getInitStoreData: function (q, latitude, longitude) {
        var data = {
            "q":"" ,
            "page":0
        };
        if (q !== null) {
            data.q = q;//value from input field
        }
        if (latitude !== null && longitude !== null) {
            //triggered on page load
            data.latitude = latitude;
            data.longitude = longitude;
        }
        ACC.storefinder.storeSearchData = data;
        ACC.storefinder.getStoreData(data.page);
        $(".js-store-finder").show();
        $(".js-store-finder-pager-prev").attr("disabled","disabled");
        $(".js-store-finder-pager-next").removeAttr("disabled");
    },

    init: function(){
        if (ACC.storefinder.storeFinder.length > 0 && navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                function (position) {
                    ACC.storefinder.coords = position.coords;
                    ACC.storefinder.getInitStoreData(null, ACC.storefinder.coords.latitude, ACC.storefinder.coords.longitude);
                }
            );
        }
    }
};

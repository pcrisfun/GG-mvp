// Custom scripts goes here
(function() {

    // Initialize carousel
    carouselInit();

    // Portfolio filters function
    portfolioFilters();

})();


// Function to animate the height of carousel in case of slides with different heights
function carouselInit() {
    var carousel = $('#myCarousel'),
        defaultHeight = carousel.find('.active').height();

    // setting the default height
    carousel.css('min-height', defaultHeight);

    // added to prevent sliding automatically after clicking the next buttons - http://stackoverflow.com/questions/13358499/preventing-twitter-bootstrap-carousel-from-auto-sliding-on-page-load
    $(document).ready(function() {
        $('.carousel').carousel('pause');
    });

    // animate the container height on any slider transitiom
    carousel.bind('slid', function() {
        var itemheight = carousel.find('.active').height();

        carousel.css('min-height', itemheight);
        carousel.animate({
            height: itemheight
        }, 50 );
    });
}


// Function to style the map in the contact page, change lat and lng vars to create your own map
function mapInit(location) {
    // Create an array of styles.
    var styles =   [
        {
            stylers: [
                { saturation: -100 }
            ]
        },{
            featureType: 'road',
            elementType: 'geometry',
            stylers: [
                { lightness: 100 },
                { visibility: 'simplified' }
            ]
        },{
            featureType: 'road',
            elementType: 'labels',
            stylers: [
                { visibility: 'off' }
            ]
            }
        ],
        // put your locations lat and long here
        //$lat = 30.2761,
        //$lng = -97.7161,
        geocoder = new google.maps.Geocoder();
        //convert location into longitude and latitude
        geocoder.geocode({
            address: location
        }, function(locResult) {
            console.log(locResult);
            console.log(locResult[0].geometry.location.lat());
            console.log(locResult[0].geometry.location.lng());
            lat = locResult[0].geometry.location.lat();
            lng = locResult[0].geometry.location.lng();

            console.log(lat);
            console.log(lng);

            // Create a new StyledMapType object, passing it the array of styles,
            // as well as the name to be displayed on the map type control.
            styledMap = new google.maps.StyledMapType(styles,
                {name: 'Styled Map'}),

            // Create a map object, and include the MapTypeId to add
            // to the map type control.
            mapOptions = {
                zoom: 14,
                scrollwheel: false,
                center: new google.maps.LatLng( lat, lng ),
                mapTypeControlOptions: {
                    mapTypeIds: [google.maps.MapTypeId.ROADMAP]
                }
            },
            map = new google.maps.Map(document.getElementById('map'),
                mapOptions),
            austin = new google.maps.LatLng( lat, lng ),

            marker = new google.maps.Marker({
                                            position: austin,
                                            map: map,
                                            title: location
                                        });


            //Associate the styled map with the MapTypeId and set it to display.
            map.mapTypes.set('map_style', styledMap);
            map.setMapTypeId('map_style');
        });
}

function portfolioFilters() {
    var filters = $('.thumbnail-filters');

    filters.on('click', 'a', function(e) {
        var active = $(this),
            portfolio = filters.next();
            activeClass = active.data('filter');


        filters.find('a').removeClass('active');
        active.addClass('active');

        if ( activeClass == 'all') {
            portfolio.find('li').removeClass('inactive');
        } else {
            portfolio.find('li').removeClass('inactive').not('.filter-' + activeClass ).addClass('inactive');
        }


        e.preventDefault();
    });
}
;

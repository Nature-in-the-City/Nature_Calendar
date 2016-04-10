var autocomplete;

// Used to choose type of address components received by Google
var componentForm = {
    street_number: 'short_name',
    route: 'long_name',
    locality: 'long_name',
    administrative_area_level_1: 'short_name',
    country: 'short_name',
    postal_code: 'short_name'
};

// Used to map app's css ids to google ids
var idMap = {
    street_number: 'event_st_number',
    route: 'event_st_name',
    locality: 'event_city',
    postal_code: 'event_zip',
    administrative_area_level_1: 'event_state',
    country: 'event_country'
};

// Used to hide or display the divs containing ALL the location fields
var divIDs = [
    'e_address',
    'e_city',
    'e_state',
    'e_zip',
    'e_country'
];

var registerMapGenerationEvent = function () {
    for (var i = 0; i < divIDs.length; i++) {
        document.getElementById(divIDs[i]).addEventListener('change', function () {
            get_interactive_map();
        }, true);
    }
};


function displayLocationDivs() {
    for (var i = 0; i < divIDs.length; i++) {
        document.getElementById(divIDs[i]).style.display = 'block';
    }
}

function hideLocationDivs() {
    for (var i = 0; i < divIDs.length; i++) {
        document.getElementById(divIDs[i]).style.display = 'none';
    }
}

function initialize() {
    var locationBox = document.getElementById('autocomplete');
    autocomplete = new google.maps.places.Autocomplete(locationBox, {types: ['geocode']});
    // When the user selects an address from the dropdown,
    // populate the address fields in the form.
    google.maps.event.addListener(autocomplete, 'place_changed', function() {
        fillInAddress();
        get_interactive_map();
    });

    displayLocationDivs();
    registerMapGenerationEvent();
    geolocate();
}

function clearElementsText() {
    for (var component in componentForm) {
        if (componentForm.hasOwnProperty(component)) {
            document.getElementById(idMap[component]).value = '';
        }
    }
}

function fillInAddress() {
    var place = autocomplete.getPlace();

    clearElementsText();

    for (var i = 0; i < place.address_components.length; i++) {
        var addressType = place.address_components[i].types[0];
        if (componentForm[addressType]) {
            var val = place.address_components[i][componentForm[addressType]];
            document.getElementById(idMap[addressType]).value = val;
        }
    }
}

function read_full_address_from_form() {
    var fullAddress = {
        event_st_number: '',
        event_st_name: '',
        event_city: '',
        event_zip: '',
        event_state: '',
        event_country: ''
    };
    for (var component in componentForm) {
        if (componentForm.hasOwnProperty(component)) {
            id = idMap[component];
            fullAddress[id] = document.getElementById(id).value;
        }
    }
    return fullAddress;
}

function fix_null_fields(address) {
    for (var field in address) {
        if (address.hasOwnProperty(field) && !address[field]) {
            address[field] = '';
        }
    }
    return address;
}

function read_full_address(address) {
    if (address) {
        return fix_null_fields(address);
    } else {
        return read_full_address_from_form();
    }
}

function format_address_string(address) {
     return [(address['event_st_number'] + ' ' + address['event_st_name']).replace(' ', '+').replace('&', 'and'),
              address['event_city'].replace(' ', '+'), address['event_state'].replace(' ', '+'),
              address['event_country'].replace(' ', '+'), address['event_zip']].join(',').replace(' ', '+');  // CHECK THIS FINAL REPLACE
}

function get_interactive_map(address_map) {
    var key = 'AIzaSyBBttOYOnnWpdZL92Xo96ZLolIKBunNsHk';
    var address = read_full_address(address_map);
    var address_string = format_address_string(address);
    var map = $(['<iframe id="map_frame" width="100%" height="100%" frameborder="0" style="border:0" src="https://www.google.com/maps/embed/v1/place?key=', key, '&q=', address_string, '"></iframe>'].join(""));
    $('#map').html(map).show();
    prevent_auto_scroll_on_map();
}

function prevent_auto_scroll_on_map() {
    // make iframe active on click, disable on mouseleave
    $('#map_frame').each( function(i, iframe) {
        $(iframe).parent().hover( // make inactive on hover
            function() {
                $(iframe).css('pointer-events', 'none');
            }).click( // activate on click
            function() { $(iframe).css('pointer-events', 'auto');
            }).trigger('mouseover'); // make it inactive by default as well
    });
}

function geolocate() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            var geolocation = new google.maps.LatLng(
                position.coords.latitude, position.coords.longitude);
            var circle = new google.maps.Circle({
                center: geolocation,
                radius: position.coords.accuracy
            });
            autocomplete.setBounds(circle.getBounds());
        });
    }
}

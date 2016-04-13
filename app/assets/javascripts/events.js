var setup_event_form = function(button_id) {
    $(button_id).on('click', function () {
        if ($('#event_name').val() == '') {
            alert('Please make sure to at least include the event name.');
            return false;
        }
    });

    var setTimeListeners = function () {
        for (var i = 1; i < 6; i++) {
            var startId = '#' + 'event_start_' + i + 'i';
            $(startId).on('change', function () {
                elem = $(this);
                var endId = '#' + 'event_end_' + elem.attr('id')[12] + 'i';
                $(endId).val(elem.val());
            });
        }
    };
    setTimeListeners();

    var event_venue_name = $('#event_venue_name');
    var venue_check = $('#venue_check');
    var venue_label = $('#venue_label');
    var autocomplete = $('#autocomplete');
    var location_label = $('#location_label');
    var event_state = $('#event_state');
    var event_country = $('#event_country');
    
    function disableVenue() {
        event_venue_name.prop('disabled', true);
        autocomplete.prop('disabled', true);
        
        venue_label.addClass('disabled');
        location_label.addClass('disabled');
        hideLocationDivs();
        $('#map').hide();
        clearElementsText();
        autocomplete.val('');
        event_venue_name.val('');
    }
    
    function enableVenue() {
        event_venue_name.prop('disabled', false);
        autocomplete.prop('disabled', false);
        
        venue_label.removeClass('disabled');
        location_label.removeClass('disabled');
        event_state.val('CA');
        event_country.val('US');
    }

    if (venue_check.length === 0) {
        enableVenue();
    }
    else if (event_venue_name.val() != '') {
        venue_check.prop('checked', true);
        event_venue_name.prop('disabled', false);
        autocomplete.prop('disabled', false);
        displayLocationDivs();
    } 
    else {
        venue_check.prop('checked', false);
        venue_label.addClass('disabled');
        location_label.addClass('disabled');
        event_venue_name.prop('disabled', true);
        autocomplete.prop('disabled', true);
    }


    venue_check.on('click', function () {
        var enabled = this.checked;
        if (!enabled) {
            disableVenue();
        } else {
            enableVenue();
        }
    });


    $(button_id).on('click', function () {
        if (venue_check.prop('checked')) {
            if (event_venue_name.val() == '' ||
                $('#event_st_name').val() == '' ||
                $('#event_city').val() == '' ||
                event_state.val() == '' ||
                event_country.val() == '') {
                alert('If you want to create a venue please make sure to include at least: \n Venue Name \n Address Name (Number not required)\n City \n State \n Country (2 letter code) \nIf you want to erase a currently set venue, then please un-check the "Enable Venue" check box.');
                return false;
            }
        }
    });

};

var renderEvent = function(event) {
    calendar = $('#calendar');
    eventDate = calendar.fullCalendar('getCalendar').moment(event['start']);
    displayedDate = calendar.fullCalendar('getDate');
    if (eventDate.month() == displayedDate.month()) {
        calendar.fullCalendar('renderEvent', event, true);
    }
    calendar.fullCalendar('gotoDate', eventDate);
};

/** Returns the zipcodes within dist_from_center of zip_center */
var checkZipcodeRadius = function(zip_center, dist_from_center, units) {
    var api_key = "OoZsJzcAcAkDFySGpVRykDBm5jfInQdbfcDYMPzYqTB6suMRqEqKh17mkm5IdiTs"
    
    var url = "https://www.zipcodeapi.com/rest/"+api_key+"/radius.json/"+zip_center+"/"+dist_from_center+"/"+units+""
    
    /** Handle successful response */
    function handleResp(data)
    {
        /** TODO: handle data
         * see https://www.zipcodeapi.com/API
         */
            
    }
    
    $.ajax({
        "url": url,
        "dataType": "json"
    }).done(function(data){
        
        handleResp(data);
    }).fail(function(data){
        
        /* TODO: handle failures */
        
    })
};

// TODO: Bind checkZipcodeRadius to button

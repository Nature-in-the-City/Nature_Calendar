// NOTE: I'm forced to declare this global object because of a sad bug with the calendar API
//       I need it to rebuild the calendar given that refetchEvents doesn't work...

var init_object = {
    events: function(start, end, timezone, callback){
        $.getJSON('events.json', {start: start.toDate(), end: end.toDate(), filter: getParam('event%5Bfilter%5D')}, function(data){
            callback(data);
        });
    },

    eventLimit: 'true',

    eventClick: function(calEvent, jsEvent, view) {
        $.ajax({
            type: 'GET',
            url: calEvent.url,
            dataType: 'script'
        });
        return false;
    },

    header: {
        left:   'today',
        center: 'title',
        right:  'prev,next'
    },

    aspectRatio: 1
};

var setPanelHeight = function() {
    $('#panel').outerHeight($('#calendar').find('.fc-view-container').outerHeight(true));
};

var setLayout = function() {
    var panel = $('#panel_wrapper');
    var calendar = $('#calendar');
    calendar.css('float', 'left');
    var width = $(window).width();

    if (width < 500) {
        panel.css('float', 'left');
        panel.css('width', '100%');
        calendar.css('width', '100%');
    } else {
        panel.css('float', 'right');
        panel.css('width', '35%');
        calendar.css('width', '64%');
    }

    if (width < 980) {
        $('#page').css('width', '100%');

        if (width < 800) {
            calendar.fullCalendar('option', 'aspectRatio', 0.8);
        }
    } else {
        $('#page').css('width', '96%');
        calendar.fullCalendar('option', 'aspectRatio', 1);
    }

};

$(document).ready(function() {
  $('#calendar').fullCalendar(init_object);

  setLayout();
  setPanelHeight();


  var timer;
  $(window).resize(function() {
    clearTimeout(timer);
    timer = setTimeout(function() {
        setPanelHeight();
    }, 250);

    setLayout();
  });

  // Prevent any form submission caused by a simple press of the ENTER key
  $(window).on('keydown', function(e) {
      var enter_key_code = 13;
      var esc_key_code =  27;
      if (e.keyCode == enter_key_code) {
          return false;
      }
      if (e.keyCode == esc_key_code) {
          path = 'users/sign_in';
          $(location).attr('href', path);
          return false;
      }
  });

  setup_squarespace();
});

var refreshCalendar = function() {
    // NOTE: The calendar API seems to be buggy. It refuses to refetch the calendar
    // So I'm forced to reset the div, and rebuild the calendar from scratch
    $('#calendar').replaceWith("<div id='calendar'></div>");
    $('#calendar').fullCalendar(init_object);
    setLayout();
    setPanelHeight();
};

var getParam = function(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)", "i"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}
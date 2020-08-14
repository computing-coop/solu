
  var $fc = $("#calendar");

  var screenWidth = $(window).width();
  var options = {
      customButtons: {
          download: {
            text: 'download',
            click: function() {
              window.location.href='/calendar.ics'
            }
          }
        },
        editable: true,
        header: {
          left: 'prev,next today download',
          center: 'title',
          right: 'month,agendaWeek,agendaDay'
        },
        defaultView: 'month',
        contentHeight: 'auto',
        lang: '#{I18n.locale.to_s}',
        contentHeight: 'auto',
        firstDay: 1,

        fixedWeekCount: false,
        slotMinutes: 30,
        eventSources: [
          {
            url: '/calendar'
          }
        ],
        timeFormat: 'H:mm',
        dragOpacity: "0.5",
        eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc) {
          return updateEvent(event);
        },
        eventResize: function(event, dayDelta, minuteDelta, revertFunc) {
          return updateEvent(event);
        },
        eventRender: function(event, element) {
          if (event.exhibition) {
            element.addClass('exhibition')
            element.find('.fc-title').append('<span class="exhibition_hours"><br />Open from Wed-Sat, see SOLU opening hours</span>')
          }
        }
      
      };
  var mobileOptions = {
    editable: true,
    header: {
        left: 'prev,next today',
        center: 'title',
        right: ''
    },
    defaultView: 'listMonth',

    lang: '#{I18n.locale.to_s}',
    contentHeight: 350,
    firstDay: 1,

    fixedWeekCount: false,
    slotMinutes: 30,
    eventSources: [
      {
        url: '/calendar'
      }
    ],
    timeFormat: 'H:mm',
    dragOpacity: "0.5",
    eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc) {
      return updateEvent(event);
    },
    eventResize: function(event, dayDelta, minuteDelta, revertFunc) {
      return updateEvent(event);
    }
  };

  if (screenWidth < 700) {
    $fc.fullCalendar(mobileOptions);
    } else {
      $fc.fullCalendar(options);
    };


var updateEvent = function(the_event) {

  return $.update("/calendar/" + the_event.id, {
    event: {
      title: the_event.title,
      starts_at: "" + the_event.start,
      ends_at: "" + the_event.end,
      description: the_event.description
    }
  });
};


  var $fc = $("#calendar");

  var screenWidth = $(window).width();
  var options = {
        editable: true,
        header: {
          left: 'prev,next today',
          center: 'title',
          right: 'month,agendaWeek,agendaDay'
        },
        defaultView: 'month',
        contentHeight: '400px',
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

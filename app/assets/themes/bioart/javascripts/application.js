//= require jquery
//= require jquery_ujs
//= require jquery-ui/core
//= require jquery.slick
//= require video
//= require bioart/javascripts/jquery.scrollTo.min
//= require bioart/javascripts/masonry.pkgd.min
//= require foundation
//= require bioart/javascripts/jquery.pageless
//= require moment
//= require fullcalendar
//= require fullcalendar/locale-all

$(document).on('ready page:load', function () {
  $(document).foundation();
});

function toggleCalendar() {

  if ( jQuery('#calendar_container').css("top") == "180px")  {
    jQuery('#calendar_container').animate({top:"-300%"}, 600);
    // jQuery('#calendar_container').animate({top: parseInt($('#container').offset().top) + 'px' }, 600);
    jQuery('#calendar_container').css('position', 'fixed');
    return false;
  } else {

    var eTop = $('#calendar_container').offset().top;
    jQuery('#calendar_container').css('position', 'absolute');
    jQuery('#calendar_container').css('top', parseInt(eTop) + 'px');
        jQuery('#calendar_container').animate({top:"180px"}, 600);
  }

}


function scroll_To(target) {
  $('html, body').stop().animate({
      'scrollTop': $(target).offset().top - 40
  }, 900, 'swing', function () {
      //window.location.hash = target;
  });
  return false;
}

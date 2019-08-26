//= require jquery
//= require jquery_ujs
//= require jquery-ui/core
//= require jquery.slick
//= require video
//= require bioart/javascripts/jquery.scrollTo.min
//= require bioart/javascripts/masonry.pkgd.min
//= require foundation
//= require bioart/javascripts/jquery.pageless

$(document).on('ready page:load', function () {
  $(document).foundation();
});

function toggleCalendar() {

  if ( jQuery('#calendar_container').css("left") == "0px")  {
    jQuery('#calendar_container').animate({left:"-85%"}, 600);
    jQuery('#calendar_container').animate({top: parseInt($('#container').offset().top) + 'px' }, 600);

    jQuery('#calendar_container').css('position', 'fixed');
  } else {

    var eTop = $('#calendar_container').offset().top;
    jQuery('#calendar_container').css('position', 'absolute');
    jQuery('#calendar_container').css('top', parseInt(eTop) + 'px');
        jQuery('#calendar_container').animate({left:"0%"}, 100);
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

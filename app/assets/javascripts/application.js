// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require foundation-datepicker
//= require jquery_nested_form
//= require slick-carousel
//= require ckeditor/init
//= require jquery-ui

function scrollTo(target) { 
  $('html, body').stop().animate({
      'scrollTop': $(target).offset().top - 40
  }, 900, 'swing', function () {
      //window.location.hash = target;
  });
  return false;
}



function toggleActivitytype(activitytype) {
  var jsid = "#activitytype_" + activitytype;
  var jsclass = ".activitytype_" + activitytype;
  
  if ($('.secondary_activities_filter ul.top-bar-menu ' + jsid).hasClass('active')) {

    $('.activity_row').removeClass('hidden');
    
      
  } else {

    $('.activity_row').not(jsclass).addClass('hidden');
    
  }
    
    

  $('ul.top-bar-menu ' + jsid).toggleClass('active');
}

$(function() { 
  $(document).foundation();  
});


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


function clearAllActivityFilters() {
  $('.secondary_activities_filter ul.top-bar-menu li').removeClass('active');
  $('.activity_row').removeClass('hidden'); 
}

function toggleActivitytype(activitytype) {
  var jsid = "#activitytype_" + activitytype;
  var jsclass = ".activitytype_" + activitytype;
  
  
  // if this is first active:
  if ($('#map_right .filter_box .active').length == 0) {
    // hide everything except me
    $('.activity_row').not(jsclass).addClass('hidden');
    $('#map_right .filter_box ' + jsid).toggleClass('active');

  }
  else {
    // something is alerady filtered, so...
    
    // am i the only one active?
    if ($('#map_right .filter_box ' + jsid).hasClass('active')) {
      if ($('#map_right .filter_box .active').length == 1) {
        // it's the only one

        $('.activity_row').removeClass('hidden');  // show all

      } else {
        // not the only one, so just remove me
        
        $('.activity_row' + jsclass).addClass('hidden');

      }
      $('#map_right .filter_box ' + jsid).toggleClass('active');
      
    } else {
      // not active yet so toggling on
      $('.activity_row' + jsclass).removeClass('hidden');
      $('#map_right .filter_box ' + jsid).toggleClass('active');
    
    }
    

  }
  
    
    

  
}

$(function() { 
  $(document).foundation();  

});


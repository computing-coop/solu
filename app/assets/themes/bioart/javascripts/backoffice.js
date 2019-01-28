//= require chosen-jquery
//= require foundation-datepicker
//= require jquery_nested_form
//= require bioart/javascripts/spectrum
//= require ckeditor/init

CKEDITOR.on('instanceReady', function(ev)
{
    ev.editor.filter.addTransformations([['img{width,height}: sizeToStyle', 'img[width,height]: sizeToAttribute']]);
});
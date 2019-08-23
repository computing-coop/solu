//= require chosen-jquery
//= require foundation-datetimepicker
//= require jquery_nested_form
//= require bioart/javascripts/spectrum
//= require ckeditor/init
//= require moment

CKEDITOR.on('instanceReady', function(ev)
{
    ev.editor.filter.addTransformations([['img{width,height}: sizeToStyle', 'img[width,height]: sizeToAttribute']]);
});

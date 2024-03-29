// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require autosize
//= require fastclick
//= require markdown_editor
//= require jquery.ui.widget
//= require jquery.fileupload
//= require_tree .

String.prototype.pluralize = function(count, plural){
	if (plural == null)
	plural = this + 's';

	return (count == 1 ? this : plural) 
};

$(function() {
	FastClick.attach(document.body);
	Turbolinks.enableProgressBar();
});

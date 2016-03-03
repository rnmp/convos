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
//= require_tree .

var App = {
    onLoadFns: [],

    onPageLoad: function(callback) {
        this.onLoadFns.push(callback);
    },

    load: function() {
        _.each(this.onLoadFns, function(callback) {
            callback.call(this);
        }, this);
    }
};

$(function() {

    Turbolinks.enableProgressBar();

    // Called everytime turbolinks loads a new page
    $(document).on("page:load", function() {
        App.load();
    });

    // Called on initial full page load
    //
    // defer is used to allow all features to register
    // their page load callbacks before App.load runs
    _.defer(function() {
        App.load();
    });
});

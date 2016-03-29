# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $(".comment").each ->
    self = this
    content = $('.user-content', this)
    if content.height() > 360
      $(self).addClass('truncate')
      expand_link = $('<a>').addClass('expand-link').text('— expand —')
      content.append(expand_link)
      expand_link.on "click", () ->
        $(self).removeClass('truncate')
        $(this).remove()

  $('#formatting_help_link').click ->
    $('#formatting_help').fadeIn()
    $('#formatting_help_link').fadeOut()
    $('#formatting_help_hide').fadeIn()

  $('#formatting_help_hide').click ->
    $('#formatting_help').fadeOut()
    $('#formatting_help_hide').fadeOut()
    $('#formatting_help_link').fadeIn()

$(document).ready(ready)
$(document).on('page:load', ready)
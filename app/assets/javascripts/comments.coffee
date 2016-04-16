# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->

  $('#formatting_help_link').click ->
    $('#formatting_help').fadeIn()
    $('#formatting_help_link').fadeOut()
    $('#formatting_help_hide').fadeIn()

  $('#formatting_help_hide').click ->
    $('#formatting_help').fadeOut()
    $('#formatting_help_hide').fadeOut()
    $('#formatting_help_link').fadeIn()

  $('form').on 'submit', (event) ->
    if $('#comment_comment', this).val() == ''
      event.preventDefault()
      alert 'This can’t be blank.'


$(document).ready(ready)
$(document).on('page:load', ready)

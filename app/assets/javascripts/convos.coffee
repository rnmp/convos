# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# still need to fix: reversing your vote should change votecount by 2, 
# since an upvote is being destroyed and a downvote created (or vice
# versa). currently votecount only changes in increment of 1.

ready = ->
  $(".replies .block-form").hide()

  $(".formatting-link").hide()
  $(".block-form textarea").on 'focus', (e) ->
    $(".formatting-link").show()

  $(".show-reply-form").on "click", (e) ->
    e.preventDefault()
    $($(this).attr 'href').toggle()

  $(".truncate-content").each ->
    self = this
    content = $('.user-content', this)
    if content.height() > 90
      $(self).addClass('truncate')
      expand_link = $('<a>').addClass('expand-link').text('— expand —')
      content.append(expand_link)
      expand_link.on "click", () ->
        $(self).removeClass('truncate')
        $(this).remove()
  
  autosize($('textarea'))

  $('.convo').on "click", (e) ->
    if $(this).hasClass('disabled') 
      return
    if !$(e.target).hasClass('arrow')
      return

    $(this).addClass('disabled')
    $(e.target).addClass('active')

    points = parseInt($('.point-count', this).text())

    if $(e.target).hasClass('upvote')
      points++
    else
      points--

    $('.point-count', this).text(points)
    $('.point-word', this).text(' point'.pluralize(points, ' points'))

    $(this).off

  $('.arrow').on "ajax:success", (e, data, status, xhr) ->
    $('.arrow', $(this).parent()).removeAttr('href').removeAttr('data-remote')    

$(document).ready(ready)
$(document).on('page:load', ready)

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# still need to fix: reversing your vote should change votecount by 2, 
# since an upvote is being destroyed and a downvote created (or vice
# versa). currently votecount only changes in increment of 1.

truncateContent = ->
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

ready = ->
  $(".replies .block-form").hide()

  $(".formatting-link").hide()
  $(".block-form textarea").on 'input', (e) ->
    $(".formatting-link").show()

  $(".show-reply-form").on "click", (e) ->
    e.preventDefault()
    $($(this).attr 'href').toggle()

  
  autosize($('textarea'))

  $('.convo, .single-convo').on "click", (e) ->
    if !$(e.target).hasClass('arrow')
      return

    points = parseInt($('.point-count', this).text())

    if $(this).hasClass('disabled')
      if $(this).hasClass('upvoted')
        points--
        $(this).removeClass('upvoted')
      else
        points++
      $('.active', this).removeClass('active')
    else
      if $(e.target).hasClass('upvote')
        points++
        $(this).toggleClass('upvoted')
      else
        points--
      $(e.target).toggleClass('active')

    $(this).toggleClass('disabled')

    $('.point-count', this).text(points)
    $('.point-word', this).text(' point'.pluralize(points, ' points'))

  truncateContent()

$(document).ready(ready)
$(document).on('page:load', ready)
$(window).load ->
  truncateContent()


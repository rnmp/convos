# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# still need to fix: reversing your vote should change votecount by 2, 
# since an upvote is being destroyed and a downvote created (or vice
# versa). currently votecount only changes in increment of 1.

ready = ->
  String::pluralize = (count, plural) ->
    if plural == null
      plural = this + 's'
    if count == 1 then this else plural

  $(".convo").each ->
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

  $('.convo').on "mousedown", (event) ->
    points = $(this).data('points')
    unless $(event.target).hasClass('upvote') || $(event.target).hasClass('downvote')
      return
    if $(event.target).hasClass('upvote')
      points++
      $(this).data('points', points)
      $('.points-count', this).text(points)
      $('.points-noun', this).text(' point'.pluralize(points))

  # $("a[data-remote]").on "click", (e) ->
  #   is_selected = $(this).hasClass('active')

  #   $(this).parent().removeClass 'disabled'
  #   $(this).parent().children().map (idx, el) ->
  #     console.log("removing", el)
  #     $(el).removeClass('active')

  #   if is_selected
  #     if $(this).hasClass('upvote')
  #       item_points--
  #     else
  #       item_points++

  #     item_type = $(this).attr('data-item-type')
  #     item_id = $(this).attr('data-item-id')
  #     $span = $('span[data-item-type='+item_type+'][data-item-id='+item_id+']')
  #     item_points = $span.html()

  #     if $(this).hasClass('upvote')
  #       item_points--
  #     else
  #       item_points++

  #     $span.html item_points

  #     return

  #   console.log("keeps running")
  #   item_type = $(this).attr('data-item-type')
  #   item_id = $(this).attr('data-item-id')
  #   $span = $('span[data-item-type='+item_type+'][data-item-id='+item_id+']')
  #   item_points = $span.html()

  #   console.log("removing points")
  #   if $(this).hasClass('upvote')
  #     item_points++
  #   else
  #     item_points--
  #   $span.html item_points
  #   $(this).parent().addClass 'disabled'
  #   $(this).addClass 'active'

  #   # $(this).unbind()


$(document).ready(ready)
$(document).on('page:load', ready)

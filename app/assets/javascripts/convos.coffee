# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# still need to fix: reversing your vote should change votecount by 2, 
# since an upvote is being destroyed and a downvote created (or vice
# versa). currently votecount only changes in increment of 1.

ready = ->
  autosize($('textarea'))

  $("a[data-remote]").on "click", () ->
    is_selected = $(this).hasClass('active')

    $(this).parent().removeClass 'disabled'
    $(this).parent().children().map (idx, el) ->
      console.log("removing", el)
      $(el).removeClass('active')

    if is_selected
      if $(this).hasClass('upvote')
        item_points--
      else
        item_points++

      item_type = $(this).attr('data-item-type')
      item_id = $(this).attr('data-item-id')
      $span = $('span[data-item-type='+item_type+'][data-item-id='+item_id+']')
      item_points = $span.html()

      if $(this).hasClass('upvote')
        item_points--
      else
        item_points++

      $span.html item_points

      return

    console.log("keeps running")
    item_type = $(this).attr('data-item-type')
    item_id = $(this).attr('data-item-id')
    $span = $('span[data-item-type='+item_type+'][data-item-id='+item_id+']')
    item_points = $span.html()

    console.log("removing points")
    if $(this).hasClass('upvote')
      item_points++
    else
      item_points--
    $span.html item_points
    $(this).parent().addClass 'disabled'
    $(this).addClass 'active'

$(document).ready(ready)
$(document).on('page:load', ready)
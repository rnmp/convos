# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
	autosize($('textarea'))

	$("a[data-remote]").on "ajax:success", (e, data, status, xhr) ->
		item_type = $(this).attr('data-item-type')
		item_id = $(this).attr('data-item-id')
		$span = $('span[data-item-type='+item_type+'][data-item-id='+item_id+']')
		item_points = $span.html()
		if $(this).hasClass('upvote')
			item_points++
		else
			item_points--
		$span.html item_points
		$(this).parent().addClass 'disabled'
		$(this).addClass 'active'

$(document).ready(ready)
$(document).on('page:load', ready)
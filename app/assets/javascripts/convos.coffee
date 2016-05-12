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
    threshold = ->
      if $(self).hasClass('comment')
        return 350 
      else
        return 200
    if content.height() > threshold()
      $(self).addClass('truncate')
      expand_link = $('<a>').addClass('expand-link').text('expand')
      content.append(expand_link)
      $(self).on "click", () ->
        $(self).removeClass('truncate')
        expand_link.remove()
      expand_link.on "click", () ->
        $(self).removeClass('truncate')
        $(this).remove()

ready = ->
  $(".replies .block-form").hide()

  $(".block-form textarea").markdown().focus()

  $(".show-reply-form").on "click", (e) ->
    e.preventDefault()
    $($(this).attr 'href').toggle()

  
  autosize($('textarea'))

  $('.convo .embed-code').hide()
  $('.single-convo .embed-link').hide()
  
  $('.multimedia').on 'click', (e) ->
    if $(e.target).hasClass('embed-link')
      $('.embed-code', this).toggle()
      $('.thumbnail', $(this).closest('.convo')).toggle()

  $('.convo.hidden').each ->
    self = this
    link_text = ->
      string = '— show hidden'
      if $(self).hasClass('comment')
        string += ' comment —'
      else
        string += ' convo —'
      return string
    show_convo_link = $('<a>')
      .addClass('show-hidden-post-link')
      .text(link_text)
    $(self).before(show_convo_link)
    show_convo_link.on 'click', (e) ->
      $(self).show()
      show_convo_link.remove()

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

  $('.convo, .single-convo').on "ajax:success", (e) ->
    ga('send', 'pageview', $(e.target).attr('href'))

  truncateContent()

  $('.report-link').on "ajax:success", (e) ->
    $(this).after('thank you')
    $(this).remove()

  # fix google analytics with turbolinks
  ga('send', 'pageview', location.pathname)

  $('.poll').on "ajax:send", (e) ->
    $(this).addClass('js-loading')

  $('.poll').on "ajax:success", (e, xhr, status, error) ->
    $(this).after(xhr.html)
    $(this).remove()

$(document).ready(ready)
$(document).on('page:load', ready)


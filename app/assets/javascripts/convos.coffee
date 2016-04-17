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
        return 90
    if content.height() > threshold()
      $(self).addClass('truncate')
      expand_link = $('<a>').addClass('expand-link').text('— expand —')
      content.append(expand_link)
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

  $('.multimedia').on 'click', (e) ->
    if $(e.target).hasClass('embed-link')
      if $(this).is('.image')
        $item = $('<img alt />')
        $item.attr('src', $(this).attr('data-link'))
      else if $(this).is('.youtube')
        $item = $('<iframe width="640" height="360" frameborder="0" allowfullscreen></iframe>')
        embed_url = $(this).attr('data-link').split('&')[0].split('=')[1]
        $item.attr('src', "https://www.youtube.com/embed/#{embed_url}")
      else if $(this).is('.vimeo')
        $item = $('<iframe width="640" height="360" frameborder="0" allowfullscreen></iframe>')
        arr = $(this).attr('data-link').split('/')
        embed_url = arr[arr.length - 1]
        $item.attr('src', "https://player.vimeo.com/video/#{embed_url}?portrait=0")
      $(this).parent().after($item)
      $('.embed-link', this).remove()

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

$(document).ready(ready)
$(document).on('page:load', ready)


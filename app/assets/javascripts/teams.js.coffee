# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

setup_form = () ->
  $('#submit-btn').click (ev) ->
    $('#users option').each (i, opt) ->
      opt.selected = true

  $('#add-btn').click (ev) ->
    $('#other_users option').filter((_,e) -> e.selected).each (i, opt) ->
      opt.selected = false
      $(opt).detach()
      $('#users').append(opt)
    ev.preventDefault()

  $('#rem-btn').click (ev) ->
    $('#users option').filter((_,e) -> e.selected).each (i, opt) ->
      opt.selected = false
      $(opt).detach()
      $('#other_users').append(opt)
    ev.preventDefault()

  $('#user_filter').on "keyup change", (ev) ->
    input = $('#user_filter').val().toLowerCase()

    $('#users option').each (i, opt) ->
      if $(opt).text().toLowerCase().includes(input)
        $(opt).show()
      else
        $(opt).hide()

  $('#other_filter').on "keyup change", (ev) ->
    input = $('#other_filter').val().toLowerCase()

    $('#other_users option').each (i, opt) ->
      if $(opt).text().toLowerCase().includes(input)
        $(opt).show()
      else
        $(opt).hide()

run_on_page "teams/new", setup_form
run_on_page "teams/edit", setup_form

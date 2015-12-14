
run_on_page "assignments/show", () ->
  $(document).ajaxError (e, data, xhr) ->
    console.log(e, data, xhr)

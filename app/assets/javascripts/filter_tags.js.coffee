
window.find_tags = () ->
  tag_data = $('[data-tags]').map((_, ee) -> $(ee).data('tags'))
  tags_seen = {}
  tag_data.each (_, tags_string) ->
    tags_string.split(/\s*;\s*/).forEach (tag) ->
      if (tag != "")
        tags_seen[tag] = 1
  Object.keys(tags_seen).sort()

window.filter_tags = (tag) ->
  if (tag == "")
    $('[data-tags]').each (_, row) ->
      $(row).show()
    return
  
  $('[data-tags]').each (_, row) ->
    tags = $(row).data('tags').split(/\s*;\s*/)
    if tags.includes(tag)
      $(row).show()
    else
      $(row).hide()

window.fill_tag_select = () ->
  tags = find_tags()

  select = $('#tag-filter')[0]
    
  opt = document.createElement("option")
  opt.innerHTML = "ALL"
  opt.value = ""
  select.appendChild(opt)
  
  tags.forEach (tag) ->
    opt = document.createElement("option")
    opt.innerHTML = tag
    opt.value = tag

    select.appendChild(opt)

window.setup_filter_form = () ->
  fill_tag_select()
  $('#apply-filter').click (ev) ->
    tag = $('#tag-filter')[0].value
    filter_tags(tag)

run_on_page "courses/show", setup_filter_form
run_on_page "assignments/show", setup_filter_form
run_on_page "teams/status", setup_filter_form

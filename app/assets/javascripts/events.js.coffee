$(document).on 'click', "[data-behaviour~='setfeatured']", ->
  $.post $(this).data("url"),
    id: $(this).data("album")
    add_featured: $(this).data("photo")
  , ->
    $(".featured").css "background-color", "#7dbc0f"
    reloadAlbum()
    $(".featured").animate(backgroundColor: "#CCC", 1500)
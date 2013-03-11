reloadAlbum = () ->
  $("#album_photos").imagesLoaded ->
    $(this).masonry("reload")
  $("[rel=tooltip]").tooltip()

loadAlbum = () ->

  # File Uploads using the Add Images Button
  $("#new_photo").fileupload
    dataType: "script"
    autoUpload: true
    sequentialUploads: true
    add: (e, data) ->
      file = undefined
      types = undefined
      types = /(\.|\/)(gif|jpe?g|png)$/i
      file = data.files[0]
      if types.test(file.type) or types.test(file.name)
        data.context = $(tmpl("template-upload", file))
        $("#photos div:eq(0)").after data.context
        $("#photos").masonry "reload"
        data.submit()
      else
        alert "" + file.name + " is not a gif, jpeg, or png image file"

    progress: (e, data) ->
      progress = undefined
      if data.context
        progress = parseInt(data.loaded / data.total * 800, 10)
        data.context.find(".bar").css "width", progress + "px"

    done: (e, data) ->
      data.context.find("img").imagesLoaded ->
        data.context.find(".progress").fadeOut 1000
        data.context.find(".bar").fadeOut 1000

  #Initialize Masonry on the gallery
  $("#photos").masonry
    isAnimated: !Modernizr.csstransitions
    itemSelector: ".box_photo"


  #Initialize Masonry on the Album
  $("#album_photos").masonry
    isAnimated: !Modernizr.csstransitions
    itemSelector: ".box"
    isResizeable: true



  #Make the Album Photos sortable
  $('#album_photos').sortable
    distance: 0
    forcePlaceholderSize: true
    handle: '.handle'
    items: '.box'
    placeholder: 'box masonry-brick placeholder'
    scroll: true
    tolerance: 'pointer'
    zindex: 1000
    start: (e, ui)->
      ui.item.addClass('dragging').removeClass('box masonry-brick')
      ui.item.parent().masonry('reload')
    change: (e, ui) ->
      ui.item.parent().masonry('reload')
    stop: (e, ui) ->
      ui.item.removeClass('dragging').addClass('box masonry-brick')
      ui.item.parent().masonry('reload')
      $.ajax
        type: 'POST',
        url: $(this).data('update-url'),
        data:  $(this).sortable('serialize') + '&album_id=' + $(this).data('update-album')


  # Animate the gallery photos when the modal loads
  $("#galleryModal").bind "shown", ->
    $("#photos").masonry "reload"

  $("#galleryModal").bind "hidden", ->
    $("#photos").masonry "reload"


  # Hide the Edit Album Modal
  $("#edit_album_save").click ->
    $("#editAlbumModal").modal "hide"

  $(document).on 'click', "[rel=tooltip]", ->
    $(".tooltip").hide()

  # Use the buttons to update the album
  $(document).on 'click', "[data-behaviour~='addphotos']", ->
    $(this).css('opacity', '.5')
    $.post $(this).data("url"),
      id: $(this).data("album")
      add_photos: [$(this).data("photo")]
    , ->
      $(this).css('opacity', '1')
      reloadAlbum()

  $(document).on 'click', "[data-behaviour~='removephotos']", ->
    $.post $(this).data("url"),
      id: $(this).data("album")
      add_photos: [$(this).data("photo")]
    , ->
      reloadAlbum()

  $(document).on 'click', "[data-behaviour~='setfeatured']", ->
    $.post $(this).data("url"),
      id: $(this).data("album")
      add_featured: $(this).data("photo")
    , ->
      $(".featured").css "background-color", "#7dbc0f"
      reloadAlbum()
      $(".featured").animate(backgroundColor: "#DFF0D8", 1500)

jQuery ->
  $(window).load ->
    loadAlbum()










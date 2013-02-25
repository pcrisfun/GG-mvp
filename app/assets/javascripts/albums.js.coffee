jQuery ->
  $('#photos').imagesLoaded ->
    $('#photos').masonry itemSelector: ".box"
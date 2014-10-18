jQuery ->
  $(".featured-btn").click ->
    $(this).removeClass("fa")
    $(this).addClass("fa")
    $(this).toggleClass("fa-star-o")
    $(this).toggleClass("fa-star")
    $.post $(this).data("url")
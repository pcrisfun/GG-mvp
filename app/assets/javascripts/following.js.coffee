jQuery ->
  $(".btn-following").mouseenter ->
    $(this).html("Unfollow <icon class='icon-eye-close' />")
  $(".btn-following").mouseleave ->
    $(this).text("You're following")
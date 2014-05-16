jQuery ->
  $(".btn-following").mouseenter ->
    $(this).html("Unfollow <icon class='fa fa-eye-slash' />")
  $(".btn-following").mouseleave ->
    $(this).text("You're following")
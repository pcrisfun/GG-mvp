jQuery ->
  $(".btn-following").mouseenter ->
    $(this).html("Unfollow <icon class='fa fa-eye-slash' />")
  $(".btn-following").mouseleave ->
    $(this).html("You're following <icon class='fa fa-check' />")
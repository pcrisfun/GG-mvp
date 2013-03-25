jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  charge.setupForm()



charge =
  setupForm: ->
    $('#stripe_error').hide()
    $("#new_apprenticeship").submit ->
      $('#cc_process').attr('disabled', true)
      if $('#card_number').length
        charge.processCard()
        false
      else
        true

  processCard: ->
    $('#stripe_error').hide()
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, charge.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    if status == 200
        $('#stripe_card_token').val(response.id)
        $("form").get(0).submit();
    else
      $('#stripe_error').show()
      $('#stripe_error.message').text(response.error.message)
      $('#cc_process').attr('disabled', false)



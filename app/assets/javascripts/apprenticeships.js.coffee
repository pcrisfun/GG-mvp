jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  charge.setupForm()



charge =
  setupForm: ->
    $('#cc_process').click ->
      $('input[type=submit]').attr('disabled', true)
      if $('#card_number').length
        charge.processCard()
        false
      else
        true

  processCard: ->
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, charge.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    if status == 200
        $('#charge_stripe_card_token').val(response.id)
        $("form")[0].submit()
    else
      $('#stripe_error').text(response.error.message)
      $('input[type=submit]').attr('disabled', false)



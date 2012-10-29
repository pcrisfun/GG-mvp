jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  charge.setupForm()

charge =
  setupForm: ->
    $('#stripe_error').hide()
    $('#cc_process').click ->
      $('input[type=submit]').attr('disabled', true)
      charge.processCard()
  
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
      $('#stripe_error .message').text(response.error.message)
      $('input[type=submit]').attr('disabled', false)

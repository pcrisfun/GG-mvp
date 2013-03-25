jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  charge.setupForm("_apprenticeship")

charge =
  setupForm: (formId)->
    $('#stripe_error').hide()
    charge.handle = 'form[id*="'+formId+'"]'
    $(charge.handle).submit ->
      $('#cc_process').attr('disabled', true)
      if $('#card_number').length
        charge.processCard()
        false
      else
        true

  processCard: ->
    console.log('Processing card')
    $('#stripe_error').hide()
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, charge.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    if status == 200
      console.log('Hooray!')
      $('#stripe_card_token').val(response.id)
      $(charge.handle).get(0).submit();
    else
      console.log('Facepalm :(')
      $('#stripe_error').show()
      $('#stripe_error.message').text(response.error.message)
      $('#cc_process').attr('disabled', false)
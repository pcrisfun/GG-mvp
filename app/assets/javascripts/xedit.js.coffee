jQuery ->
  $('.editable').editable
    mode: 'inline'
    onblur: 'submit'
    ajaxOptions:
      type: 'put'
      dataType: 'json'
    success: ->
      $(this).parent('.field').css "opacity", "0"
      $(this).parent('.field').animate(opacity: "1", 1500)

    $('.tags').children(".editable").editable
      source: {'true': 'TBA'}
      mode: 'inline'
      onblur: 'submit'
      ajaxOptions:
        type: 'put'
        dataType: 'json'
      params: (params)->
        data = {}
        data['id'] = params.pk
        data['name'] = params.name
        data['value'] = ->
          if params.value
            return params.value
          else
            return []
        return data
      success: ->
        $(this).parent('.field').css "opacity", "0"
        $(this).parent('.field').animate(opacity: "1", 1500)

    $('#tba').children(".editable").editable
      mode: 'inline'
      onblur: 'submit'
      ajaxOptions:
        type: 'put'
        dataType: 'json'
      success: (response)->
        if (response == true)
          $('#dates, #from').addClass('hidden')
        else
          $('#dates, #from').removeClass('hidden')
        $(this).parent('.field').css "opacity", "0"
        $(this).parent('.field').animate(opacity: "1", 1500)

    $('#private-address').children(".editable").editable
      mode: 'inline'
      onblur: 'submit'
      ajaxOptions:
        type: 'put'
        dataType: 'json'
      success: (response)->
        if (response == true)
          $('#nbrhood-toggle').removeClass('hidden')
        else
          $('#nbrhood-toggle').addClass('hidden')
        $(this).parent('.field').css "opacity", "0"
        $(this).parent('.field').animate(opacity: "1", 1500)










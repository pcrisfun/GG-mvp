# The validator variable is a JSON Object
# The selector variable is a jQuery Object
window.ClientSideValidations.validators.local["date"] = (element, options) ->

  # Your validator code goes in here
  date = new Date($('#user_birthday')[0].value)
  cutoff = new Date()
  cutoff.setFullYear(cutoff.getFullYear() - 13)

  # When the value fails to pass validation you need to return the error message.
  # It can be derived from validator.message
  options.message  if date.getTime() > cutoff.getTime()

jQuery ->
  $("#user_birthday").combodate({ minYear: 1920, maxYear:  ( (new Date().getFullYear()) - 13 ), firstItem: 'none' });
  #$('.user_birthday .controls .form-inline').focusout ->
  #  $('#user_birthday').change().focusout()



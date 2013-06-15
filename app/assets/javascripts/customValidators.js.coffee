# The validator variable is a JSON Object
# The selector variable is a jQuery Object
window.ClientSideValidations.validators.local["date"] = (element, options) ->

  # Your validator code goes in here
  dateParts = element.val().split("/")
  return options.message  unless dateParts.length is 3
  date = new Date(dateParts)
  cutoff = new Date()
  cutoff.setFullYear cutoff.getFullYear() - 13

  # When the value fails to pass validation you need to return the error message.
  # It can be derived from validator.message
  options.message  if date.getTime() > cutoff.getTime()

jQuery ->
  $("[data-behaviour~='combodate']").change ->
    console.log("YO!")

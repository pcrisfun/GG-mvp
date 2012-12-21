// The validator variable is a JSON Object
// The selector variable is a jQuery Object
window.ClientSideValidations.validators.local['date'] = function(element, options) {
  // Your validator code goes in here
  var dateParts = element.val().split("/");
  if(dateParts.length != 3) {
    return options.message;
  }
  var date = new Date(dateParts[2], dateParts[0], dateParts[1]);
  var cutoff = new Date();
  cutoff.setFullYear(cutoff.getFullYear() - 13);
  if (date.getTime() > cutoff.getTime()) {
    // When the value fails to pass validation you need to return the error message.
    // It can be derived from validator.message
    return options.message;
  }
}
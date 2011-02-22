$(document).ready(function(){
  $(".login label").inFieldLabels();
  $(".new_user label").inFieldLabels();
  
  $("#login").validate();
  
  $("#new_user").validate({
    rules: {
      password: "required",
      verify: {
        equalTo: "#user_password"
      }
    }
  });
  
  
  
  $('.add').click(function() {
    $(this).fadeOut('fast', function() {
        // Animation complete.
        $(this).siblings('form.facebook').fadeIn('fast');
      });
    return false;
  });
  
});

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
  
  $('.reply').click(function() {
    $(this).fadeOut('fast', function() {
        // Animation complete.
        $(this).siblings('.reply_hide').fadeIn('fast');
      });
    return false;
  });
  
});

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
  
  $(".edit_user").validate({
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
  
  $('.google').click(function() {
    $(this).fadeOut('fast', function() {
        // Animation complete.
        $(this).siblings('form.analytics').fadeIn('fast');
      });
    return false;
  });
  
  $('.mail').click(function() {
    $(this).fadeOut('fast', function() {
        // Animation complete.
        $(this).siblings('form.chimp').fadeIn('fast');
      });
    return false;
  });
  
});

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
  
  $('a.details').click(function() {
    if($('div.details').is(':visible'))
    {
      return false;
    } else  {
      $('a.overview').removeClass('active');
      $('a.details').addClass('active');
      $('div.overview').fadeOut('fast', function() {
          // Animation complete.
          $('div.details').fadeIn('fast');
        });
    }
    return false;
  });
  
  $('a.overview').click(function() {
    if($('div.overview').is(':visible'))
    {
      return false;
    } else  {
      $('a.details').removeClass('active');
      $('a.overview').addClass('active');
      $('div.details').fadeOut('fast', function() {
          // Animation complete.
          $('div.overview').fadeIn('fast');
        });
    }
    return false;
  });
  
  $('a.twitter_link').click(function() {
    if($('div.twitter').is(':visible'))
    {
      return false;
    } else  {
      $('div.detail.active').fadeOut('fast', function() {
          // Animation complete.
          $('img.side_logo.active').fadeOut('fast', function() {
            $('img.twitter_logo').fadeIn('fast', function() {
              $('img.side_logo.active').removeClass('active');
              $('img.twitter_logo').addClass('active');
            });
          });
          $('div.twitter').fadeIn('fast');
          $('div.detail').removeClass('active');
          $('div.twitter').addClass('active');
        });
    }
    return false;
  });
  
  $('a.facebook_link').click(function() {
    if($('div.facebook').is(':visible'))
    {
      return false;
    } else  {
      $('div.detail.active').fadeOut('fast', function() {
          // Animation complete.
          $('img.side_logo.active').fadeOut('fast', function() {
            $('img.face_logo').fadeIn('fast', function() {
              $('img.side_logo.active').removeClass('active');
              $('img.face_logo').addClass('active');
            });
          });
          $('div.facebook').fadeIn('fast');
          $('div.detail').removeClass('active');
          $('div.facebook').addClass('active');
        });
    }
    return false;
  });
  
  $('a.google_link').click(function() {
    if($('div.google').is(':visible'))
    {
      return false;
    } else  {
      $('div.detail.active').fadeOut('fast', function() {
          // Animation complete.
          $('img.side_logo.active').fadeOut('fast', function() {
            $('img.google_logo').fadeIn('fast', function() {
              $('img.side_logo.active').removeClass('active');
              $('img.google_logo').addClass('active');
            });
          });
          $('div.google').fadeIn('fast');
          $('div.detail').removeClass('active');
          $('div.google').addClass('active');
        });
    }
    return false;
  });
  
  $('a.mailchimp_link').click(function() {
    if($('div.mailchimp').is(':visible'))
    {
      return false;
    } else  {
      $('div.detail.active').fadeOut('fast', function() {
          // Animation complete.
          $('img.side_logo.active').fadeOut('fast', function() {
            $('img.mail_logo').fadeIn('fast', function() {
              $('img.side_logo.active').removeClass('active');
              $('img.mail_logo').addClass('active');
            });
          });
          $('div.mailchimp').fadeIn('fast');
          $('div.detail').removeClass('active');
          $('div.mailchimp').addClass('active');
        });
    }
    return false;
  });
  
});

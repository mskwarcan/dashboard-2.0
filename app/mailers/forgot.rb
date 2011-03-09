class Forgot < ActionMailer::Base
  default :from => "forgottenpassword@bdashd.com"
  
  def forgot_password(user)
    @email = user
    mail(:to => @email.email, :subject => "bdashd Forgotten Password" )
  end
end
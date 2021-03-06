class UserMailer < ActionMailer::Base
  default :from => "no-reply@#{host}"

  def forgot_password(user, key)
    @user, @key = user, key
    mail( :from => "no-reply@#{host}",
          :subject => "#{app_name} -- forgotten password",
          :to      => user.email_address )
  end

  def invite(user, key)
    @user, @key = user, key
    mail( :from => "no-reply@#{host}",
          :subject => "Invitation to #{app_name}",
          :to      => user.email_address )
  end

end

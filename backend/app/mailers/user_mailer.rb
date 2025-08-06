class UserMailer < ApplicationMailer
  def welcome_email(user, course_name = nil, course_price = nil)
    @user = user
    @course_name = course_name
    @course_price = course_price
    
    mail(to: @user.email, subject: 'Welcome To Our Learning Platform')
  end
end

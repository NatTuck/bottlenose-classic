class AuthMailer < ActionMailer::Base
  default from: "UML CS Grader Server <webcat@cs.uml.edu>"
  
  def auth_link_email(user)
    email = CGI.escape(user.email)
    @auth_url = "#{root_url}main/auth?email=#{email}&key=#{user.auth_key}"
    mail(to: user.email, subject: "Course authentication link")
  end
end

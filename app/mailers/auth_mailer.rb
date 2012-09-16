class AuthMailer < ActionMailer::Base
  default from: "UML CS Grader Server <webcat@cs.uml.edu>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.auth_mailer.auth_link_email.subject
  #
  def auth_link_email(user, base_url)
    email = CGI.escape(user.email)
    @auth_url = "#{base_url}main/auth?email=#{email}&key=#{user.auth_key}"
    mail(to: user.email, subject: "Course authentication link")
  end
end

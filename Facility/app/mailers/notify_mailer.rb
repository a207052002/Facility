class NotifyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notify_mailer.notify_rent.subject
  #
  default :from => "NCUregister <center21@cc.ncu.edu.tw>"
  def tester
    mail(to: "a207052002@gmail.com", subject: "OK")
  end

  def notify_rent(facility, count)
    @count = count
    @name = facility.name
    @url = "https://ncuregi.webapp.cc.ncu.edu.tw/facilities"
    users = facility.users.where(notify: true)
    users = users.map(&:mail) if users.present?
    mail(to: users, subject: "New Rent! in #{@name}")
  end

  def mail_verify(mail, current_user)
    if current_user.present?
      token = loop do
        token = SecureRandom.urlsafe_base64(nil, false)
        break token unless Mailverify.where(token: token).present?
      end
      verify =  Mailverify.find_by(portal_id: current_user)
      if verify.present?
        verify.update(token: token, mail: mail)
      else
        Mailverify.create(token: token, mail: mail, portal_id: current_user)
      end
      @url = "https://ncuregi.webapp.cc.ncu.edu.tw/facilities/mailverify?token=#{token}"
      mail(to: mail, subject: "NCU register mail 認證郵件")
    end
  end

end

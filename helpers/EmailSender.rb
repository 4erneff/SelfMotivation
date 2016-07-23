require 'gmail'

module EmailSender
  EMAIL = 'iv.chernev@gmail.com'
  PASSWORD = ''

  def self.password_forgotten(receiver, key)
    gmail = Gmail.connect(EMAIL, PASSWORD)
    gmail.deliver do
      to receiver
      subject "test"
      html_part do
        content_type 'text/html; charset=UTF-8'
        body "Somebody(probably you) has asked to changed your password. You can do it <a href=\"http://localhost:4567/user/password/forgotten/change?key=#{key}\"> here </a>"
      end
    end
  end
end


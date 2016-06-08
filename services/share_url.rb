require 'pony'
require 'slim'

# Create new URL
class ShareUrl
  def self.call(email:, url_id:)
    begin
      share_info = {email: email, url_id: url_id}
      token_encrypted = SecureMessage.encrypt(share_info)

      Pony.mail(to: share_info[:email],
        subject: "Invitation to view url",
        html_body:  share_email(token_encrypted))
    rescue
      return false
    end
  end

  private_class_method

  def self.share_email(token)
    verification_url = "#{ENV['APP_HOST']}/invitation/#{token}/accept"

    <<~END_EMAIL
      <H1>Invitation to view URL<H1>
      <p>Please <a href=\"#{verification_url}\">click here</a> to accept your inviation to view
      url.</p>
    END_EMAIL
  end
end

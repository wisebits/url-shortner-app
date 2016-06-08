require 'http'

# Return an authenticated user, or nil
class CreateVerifiedUser
  def self.call(username:, email:, password:)
    signed_registration = SecureMessage.sign(
    	{username: username, email: email, password: password})
    response = HTTP.post("#{ENV['API_HOST']}/users/",
      body: signed_registration)
    response.code == 201 ? true : false
  end
end
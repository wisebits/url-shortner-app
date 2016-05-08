require 'http'

# Return an authenticated user, or nil
class CreateVerifiedUser
  def self.call(username:, email:, password:)
    response = HTTP.post("#{ENV['API_HOST']}/users/",
      json: {
        username: username,
        email: email,
        password: password
      })
    response.code == 201 ? true : false
  end
end
require 'http'

# Register a new user
class RegisterNewUser
  # TODO: change this to our api
  HOST = 'http://localhost:8000/api/v1'

  def self.call(username:, email:, password:)
    response = HTTP.post("#{HOST}/users", :json => { username: username, email: email, password: password })
    response.code == 200 ? JSON.parse(response) : nil
  end
end


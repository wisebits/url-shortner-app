require 'http'

# Register a new user
class RegisterNewUser
  # TODO: change this to our api
  HOST = 'http://localhost:8000/api/v1'

  def self.call(username:, email:, password:)
  	req_params = { :username => username, :email => email, :password => password }
    response = HTTP.post("#{HOST}/users", :headers => { "Content-Length" => 0 }, :json => req_params)
    response.code == 200 ? JSON.parse(response) : nil
  end
end

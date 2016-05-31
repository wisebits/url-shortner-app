require 'http'

# Returns an authenticated user, or nil
class FindAuthenticatedUser
  # TODO: change this to our api
  def self.call(username:, password:)
    response = HTTP.post("#{ENV['API_HOST']}/users/authenticate",
                      json: {username: username , password: password})
    puts 'response code'
    puts response
    response.code == 200 ? response.parse : nil
  end
end

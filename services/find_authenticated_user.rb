require 'http'

# Returns an authenticated user, or nil
class FindAuthenticatedUser
  # TODO: change this to our api
  HOST = 'http://localhost:8000/api/v1'

  def self.call(username:, password:)
    response = HTTP.get("#{HOST}/users/#{username}/authenticate",
                        params: {password: password})
    response.code == 200 ? JSON.parse(response) : nil
  end
end

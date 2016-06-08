require 'http'

# Returns an authenticated user, or nil
class FindAuthenticatedUser
  def self.call(credentials)
    response = HTTP.post("#{ENV['API_HOST']}/users/authenticate",
                      body: SecureMessage.sign(credentials.to_hash))
    response.code == 200 ? response.parse : nil
  end
end

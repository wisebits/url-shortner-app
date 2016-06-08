require 'http'

# Create new URL
class CreateNewUrl
  def self.call(auth_token:, owner:, new_url:)
    response =  HTTP.auth("Bearer #{auth_token}")
                    .post("#{ENV['API_HOST']}/users/#{owner['id']}/owned_urls/?",
                          :json => new_url.to_h)
    new_url = response.parse
    response.code == 201 ? new_url : nil
  end
end

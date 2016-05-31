require 'http'

# Create new URL
class CreateNewUrl
  def self.call(full_url:, title:, description:, auth_token:, current_user:)
    response =  #.auth("Bearer #{auth_token}")
                   HTTP.post("#{ENV['API_HOST']}/api/v1/users/#{current_user}/owned_urls/?",
      json: {
        full_url: full_url,
        title: title,
        description: description
      })
    response.code == 201 ? true : false
  end
end

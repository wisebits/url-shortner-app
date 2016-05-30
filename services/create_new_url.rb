require 'http'

# Create new URL
class CreateNewUrl
  def self.call(full_url:, title:, description:)
    response = HTTP.post("#{ENV['API_HOST']}/api/v1/users/#{@current_user['id']}/owned_urls/?",
      json: {
        full_url: full_url,
        title: title,
        description: description
      })
    response.code == 201 ? true : false
  end
end

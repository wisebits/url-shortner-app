require 'http'

# Adds permission to view url
class AddPermissionToUrl
  def self.call(viewer_email:, url_id:, auth_token:)
    config_url = "#{ENV['API_HOST']}/urls/#{url_id}/viewers"

    response = HTTP.accept('application/json')
                   .auth("Bearer #{auth_token}")
                   .post(config_url,
                         json: { email: viewer_email })

    response.code == 201 ? response.parse : nil
  end
end
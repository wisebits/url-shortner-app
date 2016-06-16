require 'http'

# Returns all projects belonging to an account
class GetUrlDetailsByShorturl
  def self.call(shorturl:, auth_token:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .get("#{ENV['API_HOST']}/urls/r/#{shorturl}")
    response.code == 200 ? extract_full_url(response.parse) : nil
  end

  private_class_method

  def self.extract_full_url(url_data)
    url = url_data['data']['full_url']
  end
end
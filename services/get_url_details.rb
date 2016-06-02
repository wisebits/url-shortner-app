require 'http'

# Returns all projects belonging to an account
class GetUrlDetails
  def self.call(url_id:, auth_token:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .get("#{ENV['API_HOST']}/urls/#{url_id}")
    response.code == 200 ? extract_url_details(response.parse) : nil
  end

  private_class_method

  def self.extract_url_details(url_data)
    url = url_data['data']
    views = url_data['relationships']

    all_views = views.map do |view|
      {
        id: view['id'],
        location: view['data']['location'],
        ip_address: view['data']['ip_address']
      }
    end

    { id: url['id'],
      full_url: url['data']['full_url'],
      title: url['data']['title'],
      description: url['data']['description'],
      short_url: url['data']['short_url'],
      views: all_views }
  end
end
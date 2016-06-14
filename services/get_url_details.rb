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
    views = url_data['relationships']['views']

    all_views = views.map do |view|
      { id: view['id'] }.merge(location: view['data'])
    end

    { id: url_data['id'], 'views' => views }
      .merge(url_data['data'])
      .merge(url_data['relationships'])
  end
end
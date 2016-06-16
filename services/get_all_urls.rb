require 'http'

# Return all urls belonging to a  user
class GetAllUrls
  def self.call(current_user:, auth_token:)
    response = HTTP.auth("Bearer #{auth_token}")
                  .get("#{ENV['API_HOST']}/users/#{current_user['id']}/urls")
    response.code == 200 ? extract_urls(response.parse) : nil
  end

  private_class_method

  def self.extract_urls(urls)
    urls['data'].map do |url|
      {
        id: url['id'],
        owner_id: url['relationships']['owner']['id'],
        full_url: url['data']['full_url'],
        title: url['data']['title'],
        description: url['data']['description'],
        short_url: url['data']['short_url'],
        permissions: url['relationships']['viewers'].count,
        views: url['relationships']['views'].count
      }
    end
  end
end
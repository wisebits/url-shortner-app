require 'dry-validation'

NewUrl = Dry::Validation.Form do
  key(:full_url).required
  key(:title).maybe
  key(:description).maybe

  configure do
    config.messages_file = File.join(__dir__, 'new_url_errors.yml')
  end
end
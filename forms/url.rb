require 'dry-validation'

NewURL = Dry::Validation.Form do
  key(:full_url).required
end

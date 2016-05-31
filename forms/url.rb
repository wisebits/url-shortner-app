require 'dry-validation'

NewURL = Dry::Validation.Form do
  key(:full_url).required
  key(:title).maybe
  key(:description).maybe
end

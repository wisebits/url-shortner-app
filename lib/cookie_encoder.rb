require 'jose'

# Provides custom encoding and decoding for cookies with strong encryption
class CookieEncoder
  def encode(cookies)
    SecureMessage.encrypt(cookies) if cookies
  end

  def decode(str)
    SecureMessage.decrypt(str) if str
  end
end
Cloudinary.config do |config|
  config.cloud_name = 'dsgpkeaoh'
  config.api_key = ENV['CLOUDINARY_API_KEY']
  config.api_secret = ENV['CLOUDINARY_API_SECRET']
  config.secure = true
end
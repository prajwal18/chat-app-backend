class UpdateMessageWithPictureJob < ApplicationJob
  queue_as :default

  def perform(message_id, picture)
    picture_file = decode_base64_to_uploaded_file(picture)
    image = Cloudinary::Uploader.upload(picture_file)
    message = Message.find(message_id)
    message.message = image['public_id']
    message.is_picture = true
    message.save
  end

  def decode_base64_to_uploaded_file(file_data)
    decoded_content = Base64.strict_decode64(file_data[:content])
    temp_file = Tempfile.new(file_data[:filename])
    temp_file.binmode
    temp_file.write(decoded_content)
    temp_file.rewind

    ActionDispatch::Http::UploadedFile.new(
      tempfile: temp_file,
      filename: file_data[:filename],
      type: file_data[:content_type]
    )
  end
end

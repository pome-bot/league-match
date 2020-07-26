class ImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
    "default_user_image.png"
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end

  process :convert => 'jpg'
  process resize_to_fit: [100, 100]

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fit: [50, 50]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
  def filename
    super.chomp(File.extname(super)) + '.jpg' if original_filename.present?
  end

  # def filename
  #   time = Time.now
  #   name = time.strftime('%Y%m%d%H%M%S') + '.jpg'
  #   name.downcase
  # end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end
  
  protected
  
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    return model.instance_variable_get(var) if model.instance_variable_get(var)
    width, height = ::MiniMagick::Image.open(file.file)[:dimensions]
    size_with_random = "#{width}x#{height}_#{SecureRandom.uuid}" 
    model.instance_variable_set(var, size_with_random)
  end

  def dimensions
    path.scan(/\d+x\d+/).to_s.scan(/\d+/)
  end

end

require 'audit'

class Upload < ActiveRecord::Base
  validates :file_name,  :presence => true
  validates :user_id,    :presence => true
  validates :secret_key, :presence => true, :uniqueness => true

  validate :data_and_metadata_stored

  belongs_to :user

  after_initialize :generate_secret_key!
  before_destroy :cleanup!

  def data_and_metadata_stored
    unless File.exists?(upload_dir.join(file_name))
      Audit.log("Uploaded file missing for upload in #{upload_dir}, aborting save.")
      return false
    end

    unless File.exists?(upload_dir.join("_metadata"))
      Audit.log("Metadata missing for upload in #{upload_dir}, aborting save.")
      return false
    end
  end

  def upload_dir
    pre = secret_key.slice(0, 2)
    Upload.base_upload_dir.join(pre, secret_key)
  end

  def path
    pre = secret_key.slice(0, 2)
    encoded_name = Rack::Utils.escape_path(file_name)
    "/uploads/#{Rails.env}/#{pre}/#{secret_key}/#{encoded_name}"
  end

  def full_path
    upload_dir.join(file_name)
  end

  def store_upload!(upload)
    if user_id.nil?
      raise Exception.new("Must set user before storing uploaded file.")
    end

    unless Dir.exists?(upload_dir)
      raise Exception.new("Cannot store upload until you've set metadata.")
    end

    Audit.log("User #{user.name} (#{user_id}) creating upload #{secret_key}")

    self.file_name = upload.original_filename

    if file_name == "_metadata"
      raise Exception.new("No uploads named '_metadata', sorry.")
    end

    File.open(full_path, 'wb') do |file|
      file.write(upload.read)
    end

    Audit.log("Uploaded file #{file_name} for #{user.name} (#{user_id}) at #{secret_key}")
  end

  def store_meta!(meta)
    meta_path = upload_dir.join("_metadata")

    if Dir.exists?(upload_dir)
      raise Exception.new("Duplicate secret key (1). That's unpossible!")
    end

    if File.exists?(meta_path)
      raise Exception.new("Attempt to reset metadata on upload.")
    end

    upload_dir.mkpath unless Dir.exists?(upload_dir)

    File.open(meta_path, "w") do |file|
      file.write(meta.to_yaml)
    end
  end

  def generate_secret_key!
    return unless new_record?

    unless secret_key.nil?
      raise Exception.new("Can't generate a second secret key for an upload.")
    end

    self.secret_key = SecureRandom.urlsafe_base64

    if Dir.exists?(upload_dir)
      raise Exception.new("Duplicate secret key (2). That's unpossible!")
    end
  end

  def cleanup!
    Audit.log("Skip cleanup: #{file_name} for #{user.name} (#{user_id}) at #{secret_key}")
  end

  def self.base_upload_dir
    Rails.root.join("public", "uploads", Rails.env)
  end

  def self.cleanup_test_uploads!
    dir = Rails.root.join("public", "uploads", "test").to_s
    if dir.length > 8 && dir =~ /test/
      FileUtils.rm_rf(dir)
    end
  end
end

class Settings
  def self.defaults
    {
      "site_email"   => 'Bottlenose <noreply@example.com>',
      "backup_login" => '',
    }
  end

  def self.clear_test!
    FileUtils.rm(File.expand_path("~/.config/bottlenose/test.json"), force: true)
  end

  def self.file_path
    Pathname.new(File.expand_path("~/.config/bottlenose/#{Rails.env}.json"))
  end

  def self.load_json
    unless File.exists?(file_path)
      return defaults
    end

    JSON.parse(File.read(file_path))
  end

  def self.save_json(cfg)
    FileUtils.mkdir_p(file_path.parent)
    File.write(file_path, cfg.to_json)
  end

  def self.[](key)
    cfg = load_json
    return cfg[key]
  end
end

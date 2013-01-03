class Audit
  def self.log(msg)
    @@log ||= Logger.new(File.open(Rails.root.join("log", "audit-#{Rails.env}.log"), "w"))
    @@log.info("#{Time.now}: #{msg}")
  end
end

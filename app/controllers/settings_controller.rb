class SettingsController < ApplicationController
  before_filter :require_site_admin

  def index
    @cfg = Settings.load_json
  end

  def save
    @cfg = Settings.defaults

    @cfg.each_key do |kk|
      @cfg[kk] = params[kk]
    end

    Settings.save_json(@cfg)

    redirect_to settings_path, notice: "Settings Saved"
  end
end

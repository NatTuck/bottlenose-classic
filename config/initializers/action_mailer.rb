
# Set default hostname for emailed URLs.
ActionMailer::Base.default_url_options[:host] = `hostname -f`.chomp

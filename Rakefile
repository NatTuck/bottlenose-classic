#!/usr/bin/env rake
# -*- ruby -*-
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Bottlenose::Application.load_tasks

task :restart do
  system("bundle exec rake assets:precompile")
  system("sudo /usr/local/bin/restart-apache.sh")
end

task :restart_apache do
  system("sudo /usr/local/bin/restart-apache.sh")
end

task :install do
  system("cd sandbox/src && make install")
end

task :clean_uploads do
  system("rm -rf public/assignments")
  system("mkdir public/assignments")
  system("touch public/assignments/empty")

  system("mkdir public/assignments/grading")
  system("touch public/assignments/grading/empty")

  system("rm -rf public/submissions")
  system("mkdir public/submissions")
  system("touch public/submissions/empty")
end

namespace :db do
  task :nuke do
    puts
    puts "This will destroy the database!"
    puts
    puts "Press CTRL+C now if you're running this on the"
    puts "production server like Mark."
    puts
    puts "Otherwise, press enter to continue."
    $stdin.readline
    system("rake db:drop")
    system("rake clean_uploads")
    system("rake db:create")
    system("rake db:migrate")
    system("rake db:fixtures:load")
  end
end

namespace :test do
  task :short do
    puts "\trake test:units"
    system("(rake test:units) 2>&1 | grep failures")

    puts "\trake test:functionals"
    system("(rake test:functionals) 2>&1 | grep failures")

    puts "\trake test:integration"
    system("(rake test:integration) 2>&1 | grep failures")
  end
end

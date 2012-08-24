#!/usr/bin/env rake
# -*- ruby -*-
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Bottlenose::Application.load_tasks

namespace :db do
  task :nuke do
    system("rake db:drop")
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

#!/usr/bin/env ruby

APP_PATH = File.expand_path('../../config/application',  __FILE__)
require File.expand_path('../../config/boot',  __FILE__)
require APP_PATH
Rails.application.require_environment!

assign_id = 34

assign = Assignment.find(assign_id)
course = assign.course

assign.submissions.each do |sub|
  next unless sub.created_at > Time.now

  fixed_time = sub.created_at - 5.hours

  sub.created_at = fixed_time
  #sub.save!

  puts "Old time: #{sub.created_at}"
  puts "New time: #{fixed_time}"
end

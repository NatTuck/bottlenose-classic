#!/usr/bin/env ruby

APP_PATH = File.expand_path('../../config/application',  __FILE__)
require File.expand_path('../../config/boot',  __FILE__)
require APP_PATH
Rails.application.require_environment!

assign_id = 34

assign = Assignment.find(assign_id)
course = assign.course

assign.submissions.each do |sub|
  team = sub.team
  user = sub.user

  if team.start_date > Time.now.to_date
    puts "Sub id: #{sub.id}"
    puts "User: #{user.name} (#{user.id})"
    puts "Is: #{team.member_names}"
    right_team = user.active_team(course)
    puts "Should be: #{right_team.member_names}" 
    puts

    sub.team = right_team
    #sub.save!
  end
end

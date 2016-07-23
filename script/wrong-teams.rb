#!/usr/bin/env ruby

APP_PATH = File.expand_path('../../config/application',  __FILE__)
require File.expand_path('../../config/boot',  __FILE__)
require APP_PATH
Rails.application.require_environment!

assign_id = 34

aa = Assignment.find(assign_id)
course = aa.course

course.assignments.each do |assign|
  next unless assign.team_subs?

  assign.submissions.each do |sub|
    team = sub.team
    user = sub.user

    right_team = user.team_at(course, sub.created_at)

    if team.id != right_team.id
      puts "Sub id: #{sub.id}"
      puts "User: #{user.name} (#{user.id})"
      puts "Is: #{team.member_names}"
      puts "Should be: #{right_team.member_names} (#{right_team.id})" 
      puts

      sub.team_id = right_team.id
      sub.save!
    end
  end
  
  assign.update_best_subs!
end

#!/usr/bin/env ruby

APP_PATH = File.expand_path('../../config/application',  __FILE__)
require File.expand_path('../../config/boot',  __FILE__)
require APP_PATH
Rails.application.require_environment!

course = Course.find(4)
puts "Team audit for course: #{course.name} (#{course.id})"

course.assignments.each do |assign|
  next unless assign.team_subs?

  assign.submissions.each do |sub|
    team = sub.team
    user = sub.user
    ureg = sub.user.registration_for(course)

    if team.start_date > sub.created_at
      puts "Sub id: #{sub.id}"
      puts "User: #{user.name} (#{user.id})"
      puts "Is: #{team.member_names}"
      right_team = user.team_at(course, sub.created_at)
      puts "Should be: #{right_team.member_names} (#{right_team.id})" 
      puts

      sub.team_id = right_team.id
      #sub.save!
    end

    team.users.each do |tu|
      tr = tu.registration_for(course)

      u_team = tu.team_at(course, sub.created_at)
      unless u_team.id == team.id
        puts "Team mismatch."
        puts "Assign: #{sub.assignment.name}"
        puts "Start: #{team.start_date}"
        puts "Sub date: #{sub.created_at}"
	puts
	puts "Submitter: #{user.name} #{user.id}"
        puts "Submitter tags: #{ureg.tags}"
        puts "Their team: #{team.member_names} #{team.id}"
	puts
	puts "Conflict user: #{tu.name}"
	puts "Tags: #{tr.tags}"
        puts "Their team: #{u_team.member_names} #{u_team.id}"
        puts "Start: #{u_team.start_date}"
        puts
	puts "--"
	puts
      end
    end
  end
  
  assign.update_best_subs!
end

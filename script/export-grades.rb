#!/usr/bin/env ruby

APP_PATH = File.expand_path('../../config/application',  __FILE__)
require File.expand_path('../../config/boot',  __FILE__)
require APP_PATH
Rails.application.require_environment!

course_id = 4

course = Course.find(course_id)

puts "Name\tEmail\tSection\tExam1%\tExam2%\tQuizzes(15)\tPSets\tDropped"

course.active_registrations.each do |reg|
  user = reg.user
  row  = []

  # Name and Email
  row << user.invert_name
  row << user.email

  # Section
  row << "??"
  
  # Exams
  # buckets = 6, 7
  e1b = course.buckets.find(6)
  row << e1b.points_ratio(user)

  e2b = course.buckets.find(7)
  row << e2b.points_ratio(user)
  
  # Quizzes, drop 5
  # bucket = 9
  q_points = course.buckets.find(9).points_earned(user).to_i
  row << [10, q_points].min

  # Psets, drop 1
  # bucket = 8
  psb = course.buckets.find(8)
  
  subs = []
  psb.assignments.each do |aa|
    best = aa.best_sub_for(user) ||
      Submission.new(assignment_id: aa.id, user_id: user.id)
    subs << best
  end

  lowest = subs.min_by {|ss| (ss.score + 1) / (ss.assignment.points_available + 1) }
  points = psb.points_earned(user) - lowest.score
  total  = psb.points_available(user) - lowest.assignment.points_available
 
  row << points / total 
  row << lowest.assignment.name

  puts row.join("\t")
end

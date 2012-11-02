# -*- coding: utf-8 -*-
module ApplicationHelper
  def select_user_hash(users = nil)
    users ||= User.all
    hash = {}
    users.each do |user|
      hash[user.name] = user.id
    end
    hash
  end

  def select_course_hash
    hash = {}
    Course.all.each do |course|
      hash[course.name] = course.id
    end
    hash
  end

  def show_score(score, assignment = nil)
    assignment ||= @assignment

    if score.nil?
      score = '∅'
    else
      score = score.round(1)
    end

    return score if assignment.nil?
    if assignment.hide_grading?
      if @logged_in_user.course_admin?(@course)
        "(hidden #{score})"
      else
        "not ready"
      end
    else
      score
    end
  end

  def status_image(sub)
    return image_tag("/assets/null-mark.png", :height => 32) if (sub.nil? || sub.new_record?)

    if sub.raw_score.nil? and sub.teacher_score.nil?
      if sub.created_at < (Time.now - 10.minutes)
        return image_tag("/assets/wait-mark.gif", :height => 32)
      else
        return image_tag("/assets/crash-mark.png", :height => 32)
      end
    end

    return image_tag("/assets/cross-mark.png", :height => 32) if sub.score == 0

    if sub.score == sub.assignment.points_available 
      return image_tag("/assets/check-mark.png", :height => 32) 
    end

    return image_tag("/assets/cminus-mark.png", :height => 32)
  end

  def registration_assignment_submissions_path(reg, assign)
    "/registrations/#{reg.id}/submissions_for_assignment/#{assign.id}"
  end

  def user_assignment_submissions_path(user, assign)
    reg = Registration.find_by_user_id_and_course_id(user.id, assign.course.id)
    registration_assignment_submissions_path(reg, assign)
  end
end

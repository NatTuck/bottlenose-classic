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
      score = "∅"
    end

    return score if assignment.nil?

    if assignment.hide_grading?
      if current_user.course_admin?(@course)
        "(hidden #{score})"
      else
        "not ready"
      end
    else
      score
    end
  end

  def status_image(sub)
    if (sub.nil? || sub.new_record?)
      return image_tag("null-mark.png", height: 32)
    end

    if sub.auto_score.nil? and sub.teacher_score.nil?
      unless sub.assignment.has_grading?
        return image_tag("question-mark.png", height: 32)
      end

      if sub.created_at < (Time.now - 10.minutes)
        return image_tag("crash-mark.png", height: 32)
      else
        return image_tag("wait-mark.gif", height: 32)
      end
    end

    if sub.score == 0
      if sub.auto_score == 0 || sub.teacher_score == 0
        return image_tag("cross-mark.png", height: 32)
      else
        return image_tag("question-mark.png", height: 32)
      end
    end

    if sub.score >= sub.assignment.points_available
      return image_tag("check-mark.png", height: 32)
    end

    if sub.score < (sub.assignment.points_available / 2)
      return image_tag("sad-mark.png", height: 32)
    end

    return image_tag("cminus-mark.png", height: 32)
  end

  def registration_assignment_submissions_path(reg, assign)
    "/registrations/#{reg.id}/submissions_for_assignment/#{assign.id}"
  end

  def user_assignment_submissions_path(user, assign)
    reg = Registration.find_by_user_id_and_course_id(user.id, assign.course.id)
    registration_assignment_submissions_path(reg, assign)
  end

  def registration_show_toggle_path(reg_id)
    "/registrations/#{reg_id}/toggle_show"
  end

  def new_chapter_assignment_path(ch)
    new_course_assignment_path(ch.course) + "?chapter_id=#{ch.id}"
  end
end

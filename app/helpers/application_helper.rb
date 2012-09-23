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
      score = "no data"
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

  def registration_assignment_submissions_path(reg, assign)
    "/registrations/#{reg.id}/submissions_for_assignment/#{assign.id}"
  end

  def user_assignment_submissions_path(user, assign)
    reg = Registration.find_by_user_id_and_course_id(user.id, assign.course.id)
    registration_assignment_submissions_path(reg, assign)
  end
end

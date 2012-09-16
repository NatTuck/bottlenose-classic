module ApplicationHelper
  def select_user_hash
    hash = {}
    User.all.each do |user|
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
end

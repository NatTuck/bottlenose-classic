module RegistrationsHelper
  def score_source(sub)
    return "n/a" if sub.nil?
    return "Human" if sub.teacher_score
    return "Computer" if sub.auto_score
    "None"
  end
end

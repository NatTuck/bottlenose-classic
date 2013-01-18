class GuestUser
  def id
    -1
  end

  def guest?
    true
  end

  def email
    "guest@example.com"
  end

  def name
    "Guest User"
  end

  def site_admin?
    false
  end

  def course_admin?(*_)
    false
  end

  def registrations
    []
  end

  def courses
    Course.where(private: false)
  end

  def answers
    []
  end

  def submissions
    []
  end

  def registration_for(course)
    nil
  end

  def send_auth_link_email!(base_url)
    raise Exception.new("No auth link for Guest")
  end

  def auth_key
    raise Exception.new("No auth_key for Guest")
  end
end

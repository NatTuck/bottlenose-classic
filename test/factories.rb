
FactoryGirl.define do
  sequence :user_name do |n|
    letters = ('A'..'Z').to_a
    first = letters[(n * 17) % 26] + "#{n}"
    last  = letters[(n * 13) % 26] + "#{n}"
    "#{first} #{last}"
  end

  factory :user do
    name  { generate(:user_name) }
    password "password"
    email { name.downcase.gsub(/\W/, '_') + "@example.com" }
    site_admin false

    factory :admin_user do
      site_admin true
    end
  end

  factory :term do
    sequence(:name) {|n| "Fall #{2010 + n}" }
    archived false
  end

  factory :course do
    term

    sequence(:name) {|n| "Computing #{n}" }
    footer "Link to Piazza: *Link*"
  end

  factory :assignment do
    course
    bucket
    association :blame, factory: :user

    sequence(:name) {|n| "Homework #{n}" }
    due_date (Time.now + 7.days)

    after(:build) do |asg|
      asg.bucket.course_id = asg.course_id
    end
  end

  factory :upload do
    user

    file_name "none"
    secret_key { SecureRandom.hex }
  end

  factory :submission do
    assignment
    user
    upload

    after(:build) do |sub|
      unless sub.user.registration_for(sub.course)
        create(:registration, user: sub.user, course: sub.course)
      end

      sub.upload.user_id = sub.user_id
    end
  end

  factory :registration do
    user
    course

    teacher false
    show_in_lists true
  end

  factory :reg_request do
    user
    course

    notes "Let me in!"
  end

  factory :bucket do
    course
    name "Default"
    weight 0.375
  end

  factory :team do
    course

    after(:build) do |team|
      u1 = create(:user)
      u2 = create(:user)

      r1 = create(:registration, user: u1, course: team.course)
      r2 = create(:registration, user: u2, course: team.course)

      team.users = [u1, u2]
      team.start_date = Time.now - 2.days
    end
  end
end

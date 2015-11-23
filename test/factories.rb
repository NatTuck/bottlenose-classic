
FactoryGirl.define do
  sequence :user_name do |n|
    letters = ('A'..'Z').to_a
    first = letters[(n * 17) % 26] + "#{n}"
    last  = letters[(n * 13) % 26] + "#{n}"
    "#{first} #{last}"
  end

  factory :user do
    name  { generate(:user_name) }
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

  factory :chapter do
    course

    sequence(:name) {|n| "Chapter #{n}" }
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
      sub.upload.user_id = sub.user_id
      reg = create(:registration, 
                   user_id: sub.user.id,
                   course_id: sub.assignment.course.id)
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
end

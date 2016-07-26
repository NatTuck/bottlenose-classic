
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

    after(:create) do |cc|
      TeamSet.create_solo!(cc)
      TeamSet.create(name: "Simple Teams", course: cc)
    end
  end

  factory :assignment do
    course
    bucket
    team_set { course.solo_team_set }
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
    team { 
      tt = Team.new(course: assignment.course, team_set: assignment.team_set)
      tt.users = [user]
      tt.save!
      tt
    }

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
    team_set { course.team_sets.last }

    after(:build) do |team|
      u1 = create(:user)
      u2 = create(:user)

      r1 = create(:registration, user: u1, course: team.course)
      r2 = create(:registration, user: u2, course: team.course)

      team.users = [u1, u2]
    end
  end

  factory :team_set do
    name "A Team Set"
    course
  end
end

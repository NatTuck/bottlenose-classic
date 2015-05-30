ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all

  # Add more helper methods to be used by all tests here...
  include FactoryGirl::Syntax::Methods
  
  def make_standard_course
    @ken      = create(:admin_user)
    @fred     = create(:user)
    @john     = create(:user)
    @cs101    = create(:course, public: true)
    @fred_reg = create(:registration, course: @cs101, user: @fred, teacher: true)
    @john_reg = create(:registration, course: @cs101, user: @john)
  end

  def assign_upload(assign, suffix)
    base = Rails.root.join('test', 'fixtures', 'files')
    base.join(assign, "#{assign}-#{suffix}")
  end

  def assign_upload_obj(assign, suffix)
    fixture_file_upload(assign_upload(assign, suffix), 'application/octet-stream')
  end

  def make_assignment(ch, name)
    aa = build(:assignment, chapter: ch, name: name)
    aa.assignment_file = assign_upload_obj(name, 'assign.tar.gz')
    aa.grading_file    = assign_upload_obj(name, 'grading.tar.gz')
    aa.save_uploads!
    aa.save!
    
    aa
  end

  def make_submission(uu, aa, file)
    upl = build(:upload)
    upl.store_meta!({
      type:       "Submission",
      user:       "Test (0)",
      date:       Time.now.strftime("%Y/%b/%d %H:%M:%S %Z")
    })
    upl.store_upload!(assign_upload_obj(aa.name, file))
    upl.save!

    sub = create(
      :submission, 
      assignment: aa,
      user: uu,
      upload_id: upl.id,
    )
    sub.save_upload!
    sub.save!

    sub
  end
end

class ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
  def supports_disable_referential_integrity?
    false
  end
end

DatabaseCleaner.strategy = :truncation

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  # Stop ActiveRecord from wrapping tests in transactions
  self.use_transactional_fixtures = false

  teardown do
    DatabaseCleaner.clean       # Truncate the database
    Capybara.reset_sessions!    # Forget the (simulated) browser state
    Capybara.use_default_driver # Revert Capybara.current_driver to Capybara.default_driver
    
    Upload.cleanup_test_uploads!
  end
end


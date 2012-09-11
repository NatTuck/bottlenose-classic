require 'test_helper'

class GradeSubmissionTest < ActionDispatch::IntegrationTest

  setup do
    @john = users(:john)
    @fred = users(:fred)

    @tars_dir = Rails.root.join('test', 'fixtures', 'files')
    @pub_dir  = Rails.root.join('public')
  end

  test "submit and grade a submission" do
    # Add test assignment.
    visit "http://test.host/main/auth?email=#{@fred.email}&key=#{@fred.auth_key}"

    click_link 'Your Courses'
    click_link 'Organization of Programming Languages'
    click_link 'Intro to Scheme'
    click_link 'Hello, World'
    click_link 'Edit this Assignment'

    assign_file = @tars_dir.join('HelloWorld.tar.gz')
    attach_file 'Assignment file', assign_file
    grading_file = @tars_dir.join('HelloWorld-grading.tar.gz')
    attach_file 'Grading file', grading_file
    click_button 'Update Assignment'

    @assignment = Assignment.find_by_name("Hello, World")

    assert File.exists?(@assignment.assignment_full_path)
    assert File.exists?(@assignment.grading_full_path)

    # Log in as a student.
    visit "http://test.host/main/auth?email=#{@john.email}&key=#{@john.auth_key}"

    click_link 'Your Courses'
    click_link 'Organization of Programming Languages'
    click_link 'Intro to Scheme'
    click_link 'Hello, World'
    click_link 'New Submission'

    fill_in 'Student notes', :with => "grade_submission_test"
    attach_file 'Upload', assign_file
    click_button 'Create Submission'

    repeat_until(60) do
      sleep 2
      @submission = Submission.find_by_student_notes("grade_submission_test")
      not @submission.raw_score.nil?
    end

    assert_equal @submission.raw_score, 100
    
    assert File.exists?(@submission.file_full_path)

    # Clean up files.
    @submission.destroy

    assert_equal false, File.exists?(@submission.file_full_path)

    @assignment.destroy

    assert_equal false, File.exists?(@assignment.assignment_full_path)
    assert_equal false, File.exists?(@assignment.grading_full_path)
  end

  def repeat_until(timeout)
    t0 = Time.now
    result = false
    until result or Time.now > t0 + timeout
      result = yield
    end
  end
end

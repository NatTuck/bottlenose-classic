require 'test_helper'

class GradeSubmissionTest < ActionDispatch::IntegrationTest

  setup do
    @john = users(:john)
    @fred = users(:fred)
    @alan = users(:alan)

    @tars_dir = Rails.root.join('test', 'fixtures', 'files')
    @pub_dir  = Rails.root.join('public')
  end

  test "correct sandbox scripts installed" do
    sandbox = Rails.root.join("sandbox/scripts")
    install = Pathname.new("/usr/local/bottlenose/scripts")

    %W{build-assignment.sh teardown-directory.sh grading-prep.sh
       setup-directory.sh test-assignment.sh
    }.each do |script|
      assert File.exists?(install.join(script)), "Script installed?"
      ssum = `cat "#{sandbox.join(script)}" | md5sum`
      isum = `cat "#{install.join(script)}" | md5sum`
      assert_equal ssum, isum, "Installed version should match"
    end
  end

  test "teacher sets ignore late penalty flag" do
    @assignment = Assignment.find_by_name("Hello, World")
    @submission = submissions(:alan_hello)

    assert_equal @submission.late_penalty, 0.4
    assert_equal @submission.ignore_late_penalty?, false

    visit "http://test.host/main/auth?email=#{@fred.email}&key=#{@fred.auth_key}"    
    visit 'http://test.host/' + edit_submission_path(@submission)

    check 'submission[ignore_late_penalty]'
    click_button 'Set Teacher Score'

    @submission = Submission.find(@submission.id)
    assert_equal @submission.ignore_late_penalty?, true
  end

  test "teacher manually submit a grade" do
    @assignment = Assignment.find_by_name("Lambda Time")

    areg0  = @alan.registration_for(@assignment.course)
    score0 = areg0.assign_score

    visit "http://test.host/main/auth?email=#{@fred.email}&key=#{@fred.auth_key}"    
    click_link 'Your Courses'
    click_link '01. Organization of Programming Languages'
    click_link 'The Substitution Model'
    click_link 'Lambda Time'
    click_link 'Manually Add Student Grade'

    select 'Alan Rosenthal',  :from => 'submission[user_id]'
    fill_in 'submission[teacher_notes]', :with => 'manually entered grade'
    fill_in 'submission[teacher_score]', :with => '85'
    click_button 'Save changes'

    @submission = Submission.find_by_teacher_notes('manually entered grade')
    assert_equal @alan.id, @submission.user_id
    assert_equal @submission.score, 85

    # Make sure score summary updates properly.
    areg1 = @alan.registration_for(@assignment.course)
    assert_not_equal score0, areg1.assign_score
  end

  test "submit and grade a submission" do
    # Add test assignment.
    visit "http://test.host/main/auth?email=#{@fred.email}&key=#{@fred.auth_key}"

    click_link 'Your Courses'
    click_link '01. Organization of Programming Languages'
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

    # TODO: Figure out how assignment destruction should work.
    # @assignment.destroy

    # assert_equal false, File.exists?(@assignment.assignment_full_path)
    # assert_equal false, File.exists?(@assignment.grading_full_path)
  end

  test "submit and grade a single file submission with specially valued tests" do
    # Add test assignment.
    visit "http://test.host/main/auth?email=#{@fred.email}&key=#{@fred.auth_key}"

    click_link 'Your Courses'
    click_link '01. Organization of Programming Languages'
    click_link 'Intro to Scheme'
    click_link 'Hello, World'
    click_link 'Edit this Assignment'

    assign_file = @tars_dir.join('hello.c')
    attach_file 'Assignment file', assign_file
    grading_file = @tars_dir.join('HelloWorld-single-grading.tar.gz')
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

    assert_equal @submission.raw_score, 75
    
    assert File.exists?(@submission.file_full_path)

    # Clean up files.
    @submission.destroy

    assert_equal false, File.exists?(@submission.file_full_path)
  end

  private

  def repeat_until(timeout)
    t0 = Time.now
    result = false
    until result or Time.now > t0 + timeout
      result = yield
    end
  end
end

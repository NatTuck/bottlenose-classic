require 'test_helper'

class GradeSubmissionTest < ActionDispatch::IntegrationTest
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
end

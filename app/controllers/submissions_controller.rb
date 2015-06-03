class SubmissionsController < ApplicationController
  before_filter :require_teacher, :except => [:new, :create, :show]
  before_filter :require_student
  prepend_before_filter :find_submission_and_assignment

  def index
    @submissions = @assignment.submissions
  end

  def show
    unless @logged_in_user.course_admin?(@course) or 
        @logged_in_user.id == @submission.user_id
      show_error "That's not your submission."
      redirect_to @assignment
    end
  end

  def new
    @submission = Submission.new
    @submission.assignment_id = @assignment.id
    @submission.user_id = @logged_in_user.id
  end

  def edit
  end

  def create
    @submission = Submission.new(submission_params)
    @submission.assignment_id = @assignment.id

    if @logged_in_user.course_admin?(@course)
      @submission.user_id ||= @logged_in_user.id
    else
      @submission.user_id = @logged_in_user.id
      @submission.ignore_late_penalty = false
    end

    @submission.save_upload!

    if @submission.save
      @submission.grade!
      respond_to do |format|
        format.html do
          redirect_to @submission, notice: 'Submission was successfully created.'
        end
        format.js   { render action: "show", sub: @submission }
      end
    else
      @submission.cleanup!
      respond_to do |format|
        format.html { render action: "new"  }
        format.js   { render action: "show", sub: @submission }
      end
    end
  end

  def update
    if @submission.update_attributes(submission_params)
      respond_to do |format|
        format.html { redirect_to @submission, notice: 'Submission was successfully updated.' }
        format.js   { render action: "show", sub: @submission }
      end
    else
      respond_to do |format|
        format.html { render action: "edit" }
        format.js   { render action: "show", sub: @submission }
      end
    end
  end

  def destroy
    @submission = Submission.find(params[:id])
    redirect_to @submission, :error => "Submission#destroy disabled."

    # @submission.destroy
    # redirect_to assignment_submissions_url(@assignment)
  end

  def manual_grade
    @submission = Submission.new
    @submission.assignment_id = @assignment.id
    @submission.ignore_late_penalty = true

    @users = @course.users
  end

  private

  def find_submission_and_assignment
    if params[:id]
      @submission = Submission.find(params[:id])
      @assignment = @submission.assignment
    end

    if params[:assignment_id]
      @assignment = Assignment.find(params[:assignment_id])
    end

    @chapter = @assignment.chapter
    @course  = @chapter.course
  end

  def submission_params
    params[:submission].permit(:assignment_id, :user_id, :student_notes,
                               :auto_score, :calc_score,:updated_at, :upload,
                               :grading_output, :grading_uid,
                               :teacher_score, :teacher_notes,
                               :ignore_late_penalty, :upload_file)
  end
end

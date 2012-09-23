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
    @submission = Submission.new(params[:submission])
    @submission.assignment_id = @assignment.id

    if @logged_in_user.course_admin?(@course)
      @submission.user_id ||= @logged_in_user.id
    else
      @submission.user_id = @logged_in_user.id
      @submission.ignore_late_penalty = false
    end

    if @submission.save
      @submission.grade!
      redirect_to @submission, notice: 'Submission was successfully created.'
    else
      @submission.cleanup!
      render action: "new"
    end
  end

  def update
    @up = Submission.new(params[:submission])

    unless @up.teacher_score.nil?
      @submission.teacher_score = @up.teacher_score
      @submission.teacher_notes = @up.teacher_notes
      @submission.save!
      redirect_to @submission, notice: 'Teacher score set.'
      return
    end

    if @submission.update_attributes(params[:submission])
      redirect_to @submission, notice: 'Submission was successfully updated.'
    else
      @submission.cleanup!
      render action: "edit"
    end
  end

  def destroy
    @submission = Submission.find(params[:id])
    @submission.destroy

    redirect_to assignment_submissions_url(@assignment)
  end

  def manual_grade
    @submission = Submission.new
    @submission.assignment_id = @assignment.id
    @submission.file_name = "none"
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
end

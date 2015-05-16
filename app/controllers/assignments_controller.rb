class AssignmentsController < ApplicationController
  before_filter :require_teacher, :except => [:show]
  before_filter :require_course_permission
  prepend_before_filter :find_assignment_and_chapter

  def index
    @assignments = @chapter.assignments
    @assignments = Assignment.all
  end

  def show
    @submissions = @assignment.submissions.where(user_id: @logged_in_user.id)
  end

  def new
    @assignment = Assignment.new
    @assignment.chapter_id = @chapter.id
    @assignment.due_date = (Time.now + 1.month).to_date
    @assignment.points_available = 100
  end

  def edit
  end

  def create
    @assignment = Assignment.new(assignment_params)
    @assignment.blame_id = @logged_in_user.id

    if @assignment.save
      @assignment.save_uploads!
      redirect_to @assignment, notice: 'Assignment was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @assignment.update_attributes(assignment_params)
      @assignment.save_uploads!
      redirect_to @assignment, notice: 'Assignment was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @assignment.destroy
    show_notice "Assignment has been deleted."
    redirect_to @chapter
  end

  def tarball
    tb = SubTarball.new(@assignment.id)
    tb.update!
    redirect_to tb.path
  end

  private

  def find_assignment_and_chapter
    if params[:id]
      @assignment = Assignment.find(params[:id]) 
      @chapter    = @assignment.chapter
    else
      @chapter    = Chapter.find(params[:chapter_id])
    end

    @course  = @chapter.course
  end

  def assignment_params
    params[:assignment].permit(:name, :chapter_id, :assignment, :due_date,
                               :points_available, :hide_grading, :blame_id,
                               :assignment_file, :grading_file, :solution_file)
  end
end

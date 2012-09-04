class AssignmentsController < ApplicationController
  before_filter :require_teacher, :except => [:show]
  before_filter :require_logged_in_user
  prepend_before_filter :find_assignment_and_chapter

  def index
    @assignments = @chapter.assignments
    @assignments = Assignment.all
  end

  def show
  end

  def new
    @assignment = Assignment.new
    @assignment.chapter_id = @chapter.id
  end

  def edit
  end

  def create
    @assignment = Assignment.new(params[:assignment])

    if @assignment.save
      redirect_to @assignment, notice: 'Assignment was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @assignment.update_attributes(params[:assignment])
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
end

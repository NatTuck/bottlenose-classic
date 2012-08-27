class ChaptersController < ApplicationController
  before_filter :find_chapter, :except => [:index, :new, :create]
  before_filter :find_course,  :only   => [:index, :new, :create]
  before_filter :require_logged_in_user, :only   => [:index, :show]
  before_filter :require_teacher,        :except => [:index, :show]

  def index
    @chapters = @course.chapters
  end

  def show
  end

  def new
    @chapter = Chapter.new
    @chapter.course_id = @course.id
  end

  def edit
  end

  def create
    @chapter = Chapter.new(params[:chapter])

    if @chapter.save
      redirect_to [@course, @chapter], notice: 'Chapter was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @chapter.update_attributes(params[:chapter])
      redirect_to [@course, @chapter], notice: 'Chapter was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @chapter.destroy
    redirect_to course_chapters_url(@course)
  end

  private

  def find_chapter
    find_course

    if @course.nil?
      show_error "No such course."
      redirect_to courses_url
      return
    end

    @chapter = Chapter.find(params[:id])

    if @chapter.course_id != @course.id
      show_error "Chapter does not match course"
      redirect_to @course
      return
    end
  end
end

class ChaptersController < ApplicationController
  before_filter :require_logged_in_user, :only   => [:show]
  before_filter :require_teacher,        :except => [:show]
  prepend_before_filter :find_course,    :only   => [:index, :new, :create]
  prepend_before_filter :find_chapter,   :except => [:index, :new, :create]


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
      redirect_to @chapter, notice: 'Chapter was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @chapter.update_attributes(params[:chapter])
      redirect_to @chapter, notice: 'Chapter was successfully updated.'
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
    @chapter = Chapter.find(params[:id])
    @course  = @chapter.course

    unless params[:course_id].nil?
      show_error "Must use unnested route."
      redirect_to @chapter
      return
    end
  end
end

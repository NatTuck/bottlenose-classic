class LessonsController < ApplicationController
  before_filter :require_logged_in_user, :only   => [:show]
  before_filter :require_teacher,        :except => [:show]
  prepend_before_filter :find_chapter,   :only   => [:index, :new, :create]
  prepend_before_filter :find_lesson,    :except => [:index, :new, :create]

  def index
    @lessons = @chapter.lessons
  end

  def show
    @answer = Answer.new()
    @reg = Registration.find_by_user_id_and_course_id(@logged_in_user.id, @course.id)

    @user_answers = @lesson.answers.where(:registration_id => @reg.id)
    @right_answer = @user_answers.any? {|a| a.score == 100 }
  end

  def new
    @lesson = Lesson.new
    @lesson.chapter_id = @chapter.id
  end

  def edit
  end

  def create
    @lesson = Lesson.new(params[:lesson])

    if @lesson.save
      redirect_to @lesson, notice: 'Lesson was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @lesson.update_attributes(params[:lesson])
      redirect_to @lesson, notice: 'Lesson was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @lesson.destroy
    redirect_to chapter_lessons_url(@chapter)
  end

  private 

  def find_chapter
    if @chapter.nil?
      @chapter = Chapter.find(params[:chapter_id])
    end

    if @course.nil?
      @course  = @chapter.course
    end
  end

  def find_lesson
    @lesson  = Lesson.find(params[:id])
    @chapter = @lesson.chapter
    @course  = @chapter.course
  end
end

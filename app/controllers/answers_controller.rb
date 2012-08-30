class AnswersController < ApplicationController
  before_filter :require_logged_in_user, :only   => [:create]
  before_filter :require_teacher,        :except => [:create]
  prepend_before_filter :find_lesson,    :only   => [:index, :new, :create]
  prepend_before_filter :find_answer,    :except => [:index, :new, :create]

  def index
    @answers = @lesson.answers
  end

  def show
  end

  def new
    @answer = Answer.new
  end

  def edit
    show_error "Edit answer form not implemented."
    redirect_to chapter_answers_path(@chapter)
  end

  def create
    @answer = Answer.new(params[:answer])

    reg = Registration.find_by_user_id_and_course_id(@logged_in_user.id, @course.id)

    if reg.nil?
      show_error "Must be registered to answer questions."
      redirect_to @lesson
      return
    end

    @answer.registration_id = reg.id
    @answer.lesson_id       = @lesson.id

    if @answer.save
      #redirect_to @answer, notice: 'Answer was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @answer.update_attributes(params[:answer])
      redirect_to @answer, notice: 'Answer was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @answer.destroy
    format.html { redirect_to answers_url }
  end

  private

  def find_lesson
    @lesson  = Lesson.find(params[:lesson_id]) if @lesson.nil?
    @chapter = @lesson.chapter if @chapter.nil?
    @course  = @chapter.course if @course.nil?
  end

  def find_answer
    @answer  = Answer.find(params[:id])
    @lesson  = @answer.lesson
    @chapter = @lesson.chapter
    @course  = @chapter.course
  end
end

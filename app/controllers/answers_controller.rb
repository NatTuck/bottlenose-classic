class AnswersController < ApplicationController
  before_filter :require_logged_in_user, :only => [:create]
  before_filter :require_teacher,        :only => [:destroy]
  prepend_before_filter :find_lesson

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
      @saved = true
    else
      @saved = false
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy
    show_notice "Answer was deleted."
    redirect_to @lesson
  end

  private

  def find_lesson
    if params[:lesson_id]
      @lesson = Lesson.find(params[:lesson_id])
    else
      @answer = Answer.find(params[:id])
      @lesson = @answer.lesson
    end
    @chapter = @lesson.chapter if @chapter.nil?
    @course  = @chapter.course if @course.nil?
  end
end

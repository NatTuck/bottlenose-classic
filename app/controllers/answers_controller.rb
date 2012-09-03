class AnswersController < ApplicationController
  before_filter :require_logged_in_user, :only => [:create]
  before_filter :require_teacher,        :only => [:destroy]
  prepend_before_filter :find_question

  def create
    @answer = Answer.new(params[:answer])

    @answer.user_id     = @logged_in_user.id
    @answer.question_id = @question.id

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
    redirect_to @question.lesson
  end

  private

  def find_question
    if params[:question_id]
      @question = Question.find(params[:question_id])
    else
      @answer = Answer.find(params[:id])
      @question = @answer.question
    end

    @lesson  = @question.lesson if @lesson.nil?
    @chapter = @lesson.chapter if @chapter.nil?
    @course  = @chapter.course if @course.nil?
  end
end

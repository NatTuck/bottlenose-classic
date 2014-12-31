class AnswersController < ApplicationController
  before_filter :require_student
  before_filter :require_teacher, :only => [:destroy]
  prepend_before_filter :find_question

  def create
    @answer = Answer.new(answer_params)

    @answer.user_id     = @logged_in_user.id
    @answer.question_id = @question.id
    @answer.attempts    = 1

    if @answer.save
      @saved = true
      render action: 'edit'
    else
      @errors = @answer.errors.messages.to_json
      @saved  = false
      render action: 'edit'
    end
  end

  def update
    @answer = Answer.find(params[:id])

    @answer.user_id     = @logged_in_user.id
    @answer.question_id = @question.id
    @answer.attempts    = (@answer.attempts||1) + 1

    if @answer.update_attributes(params[:answer])
      @saved = true
      render action: 'edit'
    else
      @errors = @answer.errors.messages.to_json
      @saved  = false
      render action: 'edit'
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

  def answer_params
    params[:answer].permit(:answer, :question_id, :user_id, :attempts)
  end
end

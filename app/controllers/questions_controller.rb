class QuestionsController < ApplicationController
  before_filter :require_teacher
  prepend_before_filter :find_question_and_lesson

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new(params[:question])

    if @question.save
      redirect_to [:edit, @question], notice: 'Question was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @question.update_attributes(params[:question])
      redirect_to [:edit, @question], notice: 'Question was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    show_notice "Question deleted."
    @question.destroy
    redirect_to @lesson
  end

  private

  def find_question_and_lesson
    if params[:id]
      @question = Question.find(params[:id]) 
      @lesson   = @question.lesson or raise Exception.new("WTF!")
    else
      @lesson   = Lesson.find(params[:lesson_id])
    end

    @chapter = @lesson.chapter
    @course  = @chapter.course
  end
end

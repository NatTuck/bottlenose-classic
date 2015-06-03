class GradeTypesController < ApplicationController
  before_action :set_grade_type, only: [:show, :edit, :update, :destroy]
  before_action :set_course

  # GET /grade_types
  def index
    @grade_type  = GradeType.new(course_id: @course.id)
    @grade_types = GradeType.all
  end

  # GET /grade_types/1
  def show
  end

  # GET /grade_types/new
  def new
    @grade_type = GradeType.new(course_id: @course.id)
  end

  # GET /grade_types/1/edit
  def edit
  end

  # POST /grade_types
  def create
    @grade_type = GradeType.new(grade_type_params)
    @grade_type.course_id = @course.id

    if @grade_type.save
      redirect_to course_grade_types_path(@course), 
        notice: 'Grade type was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /grade_types/1
  def update
    if @grade_type.update(grade_type_params)
      redirect_to course_grade_types_url(@course), 
        notice: 'Grade type was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /grade_types/1
  def destroy
    @grade_type.destroy
    redirect_to course_grade_types_url(@course), 
      notice: "Grade type '#{@grade_type.name}' was successfully removed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grade_type
      @grade_type = GradeType.find(params[:id])
    end

    def set_course
      @course = Course.find(params[:course_id])
    end

    # Only allow a trusted parameter "white list" through.
    def grade_type_params
      params.require(:grade_type).permit(:course_id, :name, :weight)
    end
end

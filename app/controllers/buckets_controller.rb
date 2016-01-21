class BucketsController < ApplicationController
  before_action :set_bucket, only: [:show, :edit, :update, :destroy]
  before_action :set_course
  before_action :setup_breadcrumbs

  # GET /course/3/buckets
  def index
    @bucket  = Bucket.new(course_id: @course.id)
    @buckets = @course.buckets
  end

  # GET /course/3/buckets/1
  def show
    raise Exception.new("Show is not used.")
  end

  # GET /course/3/buckets/new
  def new
    add_breadcrumb "New Bucket"

    @bucket = Bucket.new(course_id: @course.id)
  end

  # GET /course/3/buckets/2/edit
  def edit
    add_breadcrumb @bucket.name
  end

  # POST /course/3/buckets
  def create
    @bucket = Bucket.new(bucket_params)
    @bucket.course_id = @course.id

    if @bucket.save
      redirect_to course_buckets_path(@course),
        notice: 'Bucket was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /course/3/buckets/1
  def update
    if @bucket.update(bucket_params)
      redirect_to course_buckets_url(@course),
        notice: "Bucket '#{@bucket.name}' was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /course/3/buckets/1
  def destroy
    @bucket.destroy
    redirect_to course_buckets_url(@course),
      notice: "Bucket '#{@bucket.name}' was successfully removed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bucket
      @bucket = Bucket.find(params[:id])
    end

    def set_course
      @course = Course.find(params[:course_id])
    end

    def setup_breadcrumbs
      add_course_breadcrumbs(@course)
      add_breadcrumb "Buckets", course_buckets_path(@course)
    end

    # Only allow a trusted parameter "white list" through.
    def bucket_params
      params.require(:bucket).permit(:course_id, :name, :weight)
    end
end

class GradingJobsController < ApplicationController
  before_filter :require_site_admin

  before_action :set_grading_job, only: [:show, :edit, :update, :destroy]

  # GET /grading_jobs
  def index
    @grading_jobs = GradingJob.all
  end

  # GET /grading_jobs/1
  def show
  end

  # GET /grading_jobs/new
  def new
    @grading_job = GradingJob.new
  end

  # GET /grading_jobs/1/edit
  def edit
  end

  # POST /grading_jobs
  def create
    @grading_job = GradingJob.new(grading_job_params)

    if @grading_job.save
      redirect_to @grading_job, notice: 'Grading job was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /grading_jobs/1
  def update
    if @grading_job.update(grading_job_params)
      redirect_to @grading_job, notice: 'Grading job was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /grading_jobs/1
  def destroy
    @grading_job.destroy
    redirect_to grading_jobs_url, notice: 'Grading job was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grading_job
      @grading_job = GradingJob.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def grading_job_params
      params.require(:grading_job).permit(:submission_id, :started_at)
    end
end

class TeamsController < ApplicationController
  before_filter :require_teacher

  before_action :set_course
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :setup_breadcrumbs

  # GET /teams
  def index
    partition = @course.teams.partition(&:active?)
    @active_teams = partition.first
    @inactive_teams = partition.second
    @students_without_active_team = students_without_active_team
  end

  # GET /teams/1
  def show
    add_breadcrumb "Team ##{@team.id}"
  end

  # GET /teams/new
  def new
    add_breadcrumb "New Team"

    @team = Team.new
    @team.course_id = @course.id

    @teams = @course.teams.select(&:active?)
    @others = students_without_active_team
  end

  # GET /teams/1/edit
  def edit
    @others = students_without_active_team
  end

  def divorce
    @team = Team.find(params[:team_id])
    @team.update_attribute(:end_date, Date.current)
    redirect_to :back
  end

  # POST /teams
  def create
    @team = Team.new(team_params)

    users = params["users"] || []
    @team.users = users.map {|u_id| User.find(u_id.to_i) }

    if @team.save
      redirect_to new_course_team_path(@course), notice: 'Team was successfully created.'
    else
      @others = students_without_active_team
      render :new
    end
  end

  # PATCH/PUT /teams/1
  def update
    users = params["users"] || []

    new_ids = users.map {|u_id| u_id.to_i }.sort
    old_ids = @team.users.map {|uu| uu.id }.sort

    if new_ids != old_ids
      if @team.submissions.empty?
        @team.users = new_ids.map {|u_id| User.find(u_id) }
      else
        show_error "Can't change team members. Team has submissions."
        redirect_to edit_course_team_path(@course, @team)
        return
      end
    end

    if @team.update(team_params)
      redirect_to course_team_path(@course, @team), notice: 'Team was successfully updated.'
    else
      redirect_to edit_course_team_path(@course, @team)
    end
  end

  # DELETE /teams/1
  def destroy
    if @team.submissions.empty?
      @team.destroy
      redirect_to course_teams_path(@course), notice: 'Team was successfully destroyed.'
    else
      show_error "Can't delete. Team has submissions."
      redirect_to course_teams_path(@course)
    end
  end

  private
  def students_without_active_team
    # TODO: Optimize.
    @course.students.reject do |student|
      student.teams.where(course: @course).any? { |t| t.active? }
    end
  end

  def setup_breadcrumbs
    add_root_breadcrumb
    add_breadcrumb @course.name, @course
    add_breadcrumb "Teams", course_teams_path(@course)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_team
    @team = Team.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def team_params
    params.require(:team).permit(:course_id, :start_date, :end_date)
  end
end

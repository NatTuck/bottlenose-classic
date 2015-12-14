class TeamsController < ApplicationController
  before_filter :require_teacher

  before_action :set_course
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :setup_breadcrumbs

  # GET /teams
  def index
    @teams = @course.teams
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

    @others = other_users
  end

  # GET /teams/1/edit
  def edit
    @others = other_users
  end

  # POST /teams
  def create
    @team = Team.new(team_params)

    users = params["users"] || []
    @team.users = users.map {|u_id| User.find(u_id.to_i) }

    if @team.save
      redirect_to course_team_path(@course, @team), notice: 'Team was successfully created.'
    else
      @others = other_users
      render :new
    end
  end

  # PATCH/PUT /teams/1
  def update
    users = params["users"] || []
    @team.users = users.map {|u_id| User.find(u_id.to_i) }

    if @team.update(team_params)
      redirect_to course_team_path(@course, @team), notice: 'Team was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /teams/1
  def destroy
    @team.destroy
    redirect_to course_teams_path(@course), notice: 'Team was successfully destroyed.'
  end

  private
  def other_users
    @course.students.find_all {|uu| not @team.users.include?(uu) }
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
    params.require(:team).permit(:course_id, :start_date)
  end
end


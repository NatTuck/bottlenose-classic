class TeamsController < ApplicationController
  before_filter :require_teacher

  before_action :set_course
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :setup_breadcrumbs

  # GET /course/1/team_status
  def status
    @table = []

    @students = @course.active_registrations.each do |reg|
      uu = reg.user

      @course.assignments.each do |aa|
        next unless aa.team_subs?
	team = uu.team_at(@course, aa.due_date)

      	row = {} 
        row[:student] = uu.name
        row[:tags] = reg.tags
        row[:assign] = aa.name
        row[:due_date]  = aa.due_date
        row[:team] = team.nil? ? "" : team.member_names   

	unless team.nil? 
	  row[:conflicts] = []
	  team.users.each do |tu|
            ut = tu.team_at(@course, aa.due_date)
            if ut.id != team.id
              row[:conflicts] << tu.name
            end
          end 
        end
        @table << row
      end
    end 
  end

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


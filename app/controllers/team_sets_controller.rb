class TeamSetsController < ApplicationController
  before_filter :require_teacher
  before_action :set_course
  before_action :setup_breadcrumbs

  before_action :set_team_set, only: [:show, :edit, :update, :destroy, :clone]

  # GET /course/4/team_sets
  def index
    TeamSet.update_solo!(@course)

    @team_sets = @course.team_sets.order(:created_at).all
  end

  # GET /course/4/team_sets/1
  def show
    @teams   = @team_set.teams
    @extras  = @team_set.extra_students
  end

  # GET /course/4/team_sets/new
  def new
    @team_set = TeamSet.new
    @team_set.course_id = @course.id
  end

  # GET /course/4/team_sets/1/edit
  def edit
  end

  # POST /course/4/team_sets
  def create
    @team_set = TeamSet.new(team_set_params)
    @team_set.course_id = @course.id

    if @team_set.save
      redirect_to [@course, @team_set], 
        notice: 'Team set was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /course/4/team_sets/1
  def update
    if @team_set.name == "Solo"
      redirect_to [:edit, @course, @team_set], alert: "Can't update Solo team set"
      return
    end

    if @team_set.update(team_set_params)
      redirect_to [@course, @team_set], notice: 'Team set was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /course/4/team_sets/1
  def destroy
    if @team_set.name == "Solo"
      redirect_to course_team_sets_path(@course), 
        alert: "Can't delete Solo team set"
      return
    end

    @team_set.destroy
    redirect_to course_team_sets_path(@course), 
      notice: 'Team set was successfully destroyed.'
  end

  # POST /course/4/team_sets/1/clone
  def clone
    ts = @team_set.dup
    ts.name = "#{@team_set.name} Clone"
    ts.save!

    @team_set.teams.each do |tt0|
      tt1 = tt0.dup
      tt1.team_set = ts
      tt1.save!

      tt0.team_users.each do |tu0|
        tu1 = tu0.dup
        tu1.team = tt1
        tu1.team_set = ts
        tu1.save!
      end
    end
    
    redirect_to [@course, ts], notice: "Team Set cloned."
  end

  private

  def set_team_set
    @team_set = TeamSet.find(params[:id])
    add_breadcrumb "TeamSet ##{@team_set.id}"
  end

  # Only allow a trusted parameter "white list" through.
  def team_set_params
    params.require(:team_set).permit(:name)
  end

  def setup_breadcrumbs
    add_root_breadcrumb
    add_breadcrumb @course.name, @course
    add_breadcrumb "Teams", course_team_sets_path(@course)
  end

  def set_course
    @course = Course.find(params[:course_id])
  end
end

class TeamSetsController < ApplicationController
  before_action :set_team_set, only: [:show, :edit, :update, :destroy]

  # GET /team_sets
  def index
    @team_sets = TeamSet.all
  end

  # GET /team_sets/1
  def show
  end

  # GET /team_sets/new
  def new
    @team_set = TeamSet.new
  end

  # GET /team_sets/1/edit
  def edit
  end

  # POST /team_sets
  def create
    @team_set = TeamSet.new(team_set_params)

    if @team_set.save
      redirect_to @team_set, notice: 'Team set was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /team_sets/1
  def update
    if @team_set.update(team_set_params)
      redirect_to @team_set, notice: 'Team set was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /team_sets/1
  def destroy
    @team_set.destroy
    redirect_to team_sets_url, notice: 'Team set was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team_set
      @team_set = TeamSet.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def team_set_params
      params.require(:team_set).permit(:name, :course_id)
    end
end

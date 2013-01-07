class TermsController < ApplicationController
  before_filter :require_site_admin
  
  def index
    @terms = Term.all_sorted
  end

  def show
    @term = Term.find(params[:id])
  end

  def new
    @term = Term.new
  end

  def edit
    @term = Term.find(params[:id])
  end

  def create
    @term = Term.new(params[:term])

    if @term.save
      redirect_to @term, notice: 'Term was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @term = Term.find(params[:id])

    if @term.update_attributes(params[:term])
      redirect_to @term, notice: 'Term was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @term = Term.find(params[:id])
    @term.destroy

    redirect_to terms_url
  end
end

class TermsController < ApplicationController
  before_filter :require_site_admin
  before_filter :setup_breadcrumbs

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
    @term = Term.new(term_params)

    if @term.save
      redirect_to @term, notice: 'Term was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @term = Term.find(params[:id])

    if @term.update_attributes(term_params)
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

  private

  def setup_breadcrumbs
    add_root_breadcrumb
    add_breadcrumb "Courses", courses_path
    add_breadcrumb "Terms"
  end

  def term_params
    params[:term].permit(:name, :archived)
  end
end

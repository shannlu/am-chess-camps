class FamiliesController < ApplicationController
  before_action :set_family, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def index
    @families = Family.all.alphabetical.paginate(:page => params[:families]).per_page(12)
  end

  def show
    #@past_camps_using = @curriculum.camps.past.chronological
  end

  def edit
  end

  def new
    @family = Family.new
  end

  def create
    @family = Family.new(family_params)
    if @family.save
      redirect_to family_path(@family), notice: "#{@family.family_name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    @family.update(family_params)
    if @family.save
      redirect_to family_path(@family), notice: "#{@family.family_name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @family.destroy
    redirect_to families_url, notice: "#{@family.family_name} was removed from the system."
  end

  private
    def set_family
      @family = Family.find(params[:id])
    end

    def family_params
      params.require(:family).permit(:family_name, :parent_first_name, :user_id, :active)
    end
end

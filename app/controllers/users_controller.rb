class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def index
    @users = User.alphabetical.paginate(page: params[:users]).per_page(15)
  end

  def new
    @user = User.new
  end

  def edit
    @user.role = "instructor" if current_user.role?(:instructor)
    @user.role = "parent" if current_user.role?(:parent)
  end

  def show
    if current_user.role?(:parent)
      if !Family.where(user_id: @user.id).empty?
        @name = Family.where(user_id: @user.id).first.parent_name
        @family = Family.where(user_id: @user.id).first
      end
    end
  end

  def create
    @user = User.new(user_params)
		if @user.save
			session[:user_id] = @user.id
			create_cart
      render action: 'dashboard'
		else
			render action: 'new'
		end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = "Successfully updated user."
      redirect_to user_path(@user.id)
    else
      render action: 'edit'
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_url, notice: "Successfully removed user from the system."
    else
      render action: 'show'
    end
  end

  def dashboard
    @curriculums = Curriculum.active.alphabetical
    @active_families = Family.joins(:registrations).select('families.*').group(:student_id).order(' count(student_id) desc').first(5)
    @camps = Camp.joins(:registrations).select('camps.*').group(:student_id).order(' count(student_id) desc').first(5)
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :role, :email, :phone, :active, family_attributes: [:id, :family_name, :parent_first_name])
    end

end

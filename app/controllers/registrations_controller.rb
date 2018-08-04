class RegistrationsController < ApplicationController
  include AppHelpers::Cart
  before_action :set_registration, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def index
    @registrations = Registration.all.alphabetical
    @camps = Camp.all.alphabetical.paginate(:page => params[:camps]).per_page(12)
    @students = Student.all.alphabetical.paginate(:page => params[:students]).per_page(12)
    @families = Family.all.alphabetical
  end

  def show
    # For sidebar card
    #@upcoming_camps_at_location = @location.camps.upcoming.chronological

  end

  def edit
  end

  def new
    @registration = Registration.new
  end

  def create
    @registration = Registration.new(registration_params)
    if @registration.save
      redirect_to registration_path(@registration), notice: "#{@registration.student.proper_name} is registered for #{@registration.camp.name}."
    else
      render action: 'new'
    end
  end

  def checkout
    regs = get_array_of_ids_for_generating_registrations
    if regs.nil? || regs.length == 0
			redirect_to cart_path, alert: "You have no selected registrations."
		end
    @cost = calculate_total_cart_registration_cost
		@registration = Registration.new
  end

  def place
    @cost = calculate_total_cart_registration_cost
    ids_array = get_array_of_ids_for_generating_registrations
    paid_count = 0
    ids_array.each do |ids|
      @registration = Registration.new(registration_params)
      @registration.expiration_year = Integer(params[:registration][:expiration_year])
      @registration.expiration_month = Integer(params[:registration][:expiration_month])
      @registration.credit_card_number = params[:registration][:credit_card_number]
      @registration.camp_id = Integer(ids_array[0][0]) #19
      @registration.student_id = Integer(ids_array[0][1]) #252

      if @registration.save
  			@registration.pay
        paid_count += 1
  		end
    end
    if paid_count == ids_array.length
      clear_cart
      redirect_to registrations_path, notice: "Successfully completed registration!"
    else
      render action: 'checkout'
    end
  end


  def confirmation
  end

  def add
    # add_registration_to_cart(1, 39)
    add_registration_to_cart(params[:registration][:camp_id], params[:registration][:student_id])
  end

  def remove
    # remove_registration_from_cart("17", "253")
    remove_registration_from_cart(params[:ids][0], params[:ids][1])
    redirect_to cart_path, notice: "Successfully removed registration from cart."
  end

  def update
  end

  def empty
    clear_cart
  end

  # def cancel
  # end

  # def destroy
  #   @registration.destroy
  #   redirect_to registrations_url, notice: "#{@registration.name} was removed from the system."
  # end

  def cart
    @cost = calculate_total_cart_registration_cost
    # registration_ids = get_array_of_ids_for_generating_registrations
    # @registrations = Array.new
    # unless registration_ids.nil?
    #   registration_ids.each do |reg_id|
    #     if !Registration.find_by_id(reg_id).nil?
    #       @registrations.push(Registration.find_by_id(reg_id))
    #     end
    #   end
    # end
  end

  private
    def set_registration
      @registration = Registration.find(params[:id])
    end

    def registration_params
      params.require(:registration).permit(:camp_id, :student_id, :payment)
    end
end

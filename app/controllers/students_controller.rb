class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def index
    @students = Student.all.alphabetical.paginate(:page => params[:students]).per_page(12)
  end

  def show
    @past_camps = @student.camps.past.chronological
    @upcoming_camps = @student.camps.upcoming.chronological
  end

  def edit
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      redirect_to student_path(@student), notice: "#{@student.proper_name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @student.update(student_params)
      redirect_to student_path(@student), notice: "#{@student.proper_name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @student.destroy
    redirect_to students_url, notice: "#{@student.proper_name} was removed from the system."
  end

  private
    def set_student
      @student = Student.find(params[:id])
    end

    def student_params
      params.require(:student).permit(:first_name, :last_name, :family_id, :date_of_birth, :rating, :active)
    end
end

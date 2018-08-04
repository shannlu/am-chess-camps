class HomeController < ApplicationController
  def index
  end

  def about
  end

  def contact
  end

  def privacy
  end

  def search
    @query = params[:query]
    @camps = Camp.search(@query)
    @curriculums = Curriculum.search(@query)
    @locations = Location.search(@query)
    @instructors = Instructor.search(@query)
    @users = User.search(@query)
    @families = Family.search(@query)
    @students = Student.search(@query)
    @total_hits = @camps.size + @curriculums.size + @locations.size + @instructors.size + @users.size + @families.size + @students.size
  end

end

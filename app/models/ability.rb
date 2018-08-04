class Ability
  include CanCan::Ability

  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user

    # set authorizations for different user roles
    if user.role? :admin
      # they get to do it all
      can :manage, :all

    elsif user.role? :instructor
      # can read information related to curriculums, locations, and camps
      can :read, Curriculum
      can :read, Location
      can :read, Camp
      can :read, Instructor

      # they can read their own profile
      can :show, User do |u|
        u.id == user.id
      end

      can :dashboard, User

      # they can update their own profile
      can :update, User do |u|
        u.id == user.id
      end

      can :show, Registration 
      can :show, Student
      can :show, Family


    elsif user.role? :parent
      can :read, Curriculum
      can :read, Location
      can :read, Camp
      can :read, Instructor
      can :manage, Registration
      can :create, Family

      can :manage, Student do |s|
        s.family_id == Family.where(user_id: user.id).first.id
      end

      can :show, User do |u|
        u.id == user.id
      end

      can :update, User do |u|
        u.id == user.id
      end

      can :dashboard, User

      can :show, Family do |f|
        f.id == Family.where(user_id: user.id).first.id
      end

      can :update, Family do |f|
        f.id == User.where(user_id: user.id).first.id
      end


    else
      can :read, Curriculum
      can :read, Location
      can :read, Camp
      can :read, Instructor
      can :create, Family
      can :create, User

    end
  end
end

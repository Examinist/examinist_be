class CoordinatorPortal::FacultyPolicy < ApplicationPolicy
  def index?
    true
  end

  class Scope < Scope
    def resolve 
      user.faculties
    end
  end
end

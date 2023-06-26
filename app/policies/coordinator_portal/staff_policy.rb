class CoordinatorPortal::StaffPolicy < ApplicationPolicy
  def index?
    true
  end

  def update?
    true
  end

  class Scope < Scope
    def resolve
      user.staffs
    end
  end
end

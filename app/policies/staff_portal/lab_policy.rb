class StaffPortal::LabPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  class Scope < Scope
    def resolve
      user.labs
    end
  end
end

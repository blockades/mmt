# frozen_string_literal: true

module MembersHelper
  def my_profile?
    @member == current_member
  end
end

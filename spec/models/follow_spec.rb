require 'spec_helper'

describe Follow do
  context "has validations" do
  end

  # This is implemented by each controller it seems
  pending "returns followings for a given type and instance" do
    user = FactoryGirl.create(:user)
    good = FactoryGirl.create(:good)
    user.follow(good)
    Follow.following("User", 1).should have(1).items
  end
end


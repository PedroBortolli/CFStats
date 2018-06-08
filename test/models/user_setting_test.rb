require 'test_helper'


class UserSettingTest < ActiveSupport::TestCase
  include Api
  include DatabaseHelper

  def setup
  	@u1 = UserSetting.new(:settings => [], :username => "tourist", :friends => [], 
  		:contests => [], :handle => "tourist")
	@u2 = UserSetting.new(:settings => [], :username => "i_iiii_iiiii_ii", :friends => [], 
		:contests => ['120','1500', '9500', '666'], :handle => "tourist")  
  end

  test "users must have a non-empty username" do
  	assert @u1.username != ""
  	assert @u2.username != ""
  end

  test "usernames must be different" do
    assert @u1.username != @u2.username
  end

  test "handle is a codeforces handle" do
  	assert validate(@u1.handle, "user")
  	assert validate(@u2.handle, "user")
  end

  test "usernames must have a limit of characters" do
  	assert (@u1.username).length >= 3 && (@u1.username).length <= 30
  	assert (@u2.username).length >= 3 && (@u2.username).length <= 30
  end
end

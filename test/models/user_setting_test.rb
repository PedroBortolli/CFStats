require 'test_helper'


class UserSettingTest < ActiveSupport::TestCase
  include Api
  include DatabaseHelper

  def setup
  	@tests = Array.new(10)

  	@tests[0] = UserSetting.new(:settings => [], :username => "algumusernameae", :friends => [], 
  		:contests => [], :handle => "Brelf")
	@tests[1] = UserSetting.new(:settings => [], :username => "igual", :friends => [], 
		:contests => ['120','150', '950'], :handle => "pedrobortolli")
	@tests[2] = UserSetting.new(:settings => [], :username => "igual2", :friends => [], 
		:contests => ['120','150', '950', '666'], :handle => "nakamura")
	@tests[3] = UserSetting.new(:settings => [], :username => "muito", :friends => [], 
		:contests => ['120','150', '950', '666'], :handle => "gafeol")
	@tests[4] = UserSetting.new(:settings => [], :username => "..2", :friends => [], 
		:contests => ['120','100', '101821', '666'], :handle => "pedroteosousa")
	@tests[5] = UserSetting.new(:settings => [], :username => ",ll", :friends => [], 
  		:contests => [], :handle => "juniorandrade")
	@tests[6] = UserSetting.new(:settings => [], :username => "igual111", :friends => [], 
		:contests => ['120','500', '950', '666'], :handle => "tourist")
	@tests[7] = UserSetting.new(:settings => [], :username => "igual333", :friends => [], 
		:contests => ['120','150', '950', '666'], :handle => "petr")
	@tests[8] = UserSetting.new(:settings => [], :username => ".....", :friends => [], 
		:contests => ['332','150', '500', '666'], :handle => "kobus")
	@tests[9] = UserSetting.new(:settings => [], :username => "..3", :friends => [], 
		:contests => ['120','100', '900', '666'], :handle => "yancouto")
  end

  test "users must have a non-empty username" do
  	for i in 0..@tests.length-1
	  	assert (@tests[i]).username != ""
	end
  end

  test "usernames must be different" do
  	for i in 0..@tests.length-1
	  for j in i+1..@tests.length-1
	  	assert @tests[i].username != @tests[j].username
	  end
	end
  end

  test "handle is a codeforces handle" do
  	for i in 1..@tests.length-1
	  assert validate(@tests[i].handle, "handle")
	end
  end

  test "usernames must have a limit of characters" do
  	for i in 0..@tests.length-1
  	  assert (@tests[i].username).length >= 3 && (@tests[i].username).length <= 30
	end
  end

  test "contests need to be valid" do
  	for i in 0..@tests.length-1
  	  for j in 0..@tests[i].contests.length-1
  	  	assert validate(@tests[i].contests[j], "contest")
  	  end
	end
  end
end

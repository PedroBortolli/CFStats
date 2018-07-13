require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Api
  include DatabaseHelper

  setup do
      @p_right = {"utf8"=>"✓", "param1"=>"pedrobortolli", "param2"=>"tiago.napoli", "commit"=>"Compare!"}
      @p_wrong = {"utf8"=>"✓", "param1"=>"trollnoexisto", "param2"=>"f7gs7dkb093ks4", "commit"=>"Compare!"}
  end

  test "should get about url" do
  	get about_url
    assert_response :success
  end

  test "should get result url" do
  	get result_url
    assert_response :success
  end

  test "should get search url" do
  	get search_url
    assert_response :success
  end

  test "should get result right" do
  	get result_url(@p_right)
    assert_response :success
  end

  test "should get result wrong" do
  	get result_url(@p_wrong)
    assert_response :success
    assert_select "body", "Please provide 2 valid Codeforces handles!"
  end



end

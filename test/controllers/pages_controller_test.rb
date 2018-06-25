require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Api
  include DatabaseHelper

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

end

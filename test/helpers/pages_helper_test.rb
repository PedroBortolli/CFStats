require 'test_helper'

class PagesHelperTest < ActionView::TestCase
  include Api
  include DatabaseHelper

  test "ratings must have user-gray color" do
    rating = 1000
    assert color(rating) == 'rated-user user-gray'
  end

  test "ratings must have user-green color" do
    rating = 1350
    assert color(rating) =='rated-user user-green'
  end

  test "ratings must have user-cyan color" do
    rating = 1512
    assert color(rating) == 'rated-user user-cyan'
  end

  test "ratings must have user-blue color" do
    rating = 1830
    assert color(rating) == 'rated-user user-blue'
  end

  test "ratings must have user-violet color" do
    rating = 2018
    assert color(rating) == 'rated-user user-violet'
  end

  test "ratings must have user-orange color" do
    rating = 2333
    assert color(rating) == 'rated-user user-orange'
  end

  test "ratings must have user-red color" do
    rating = 2555
    assert color(rating) == 'rated-user user-red'
  end
end

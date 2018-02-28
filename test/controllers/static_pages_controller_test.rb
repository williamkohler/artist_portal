require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = 'Artist Portal'
    @user = users(:bill)
  end

  test 'should get home' do
    get root_path
    assert_response :success
    assert_select 'title', 'Artist Portal'
  end

  test 'should get about' do
    get about_path
    assert_response :success
    assert_select 'title', 'About | Artist Portal'
  end
end

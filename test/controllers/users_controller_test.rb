require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:standard)
    @admin = users(:admin)
    @other_user = users(:other)
  end

  test 'should redirect index when not logged in' do
    get users_path
    assert_redirected_to login_path
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect edit when logged in as wrong user' do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as wrong user' do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'admin user should update admin attribute via the web' do
    log_in_as(@admin)
    assert @admin.admin?
    assert_not @other_user.admin?
    patch user_path(@other_user, params: { admin: true })
    assert @other_user.reload.admin?
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  # TODO: should redirect destroy when non admin

  test 'standard user should not be able to destroy other users' do
    log_in_as(@user)
    assert_not @user.admin
    assert_no_difference 'User.count' do
      delete user_path(@other_user)
    end
  end

  test 'admin user should be able to destroy other users' do
    log_in_as(@admin)
    assert @admin.admin
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
  end


end

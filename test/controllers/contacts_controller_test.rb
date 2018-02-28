require 'test_helper'

class ContactsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @standard_user = users(:standard)
    @contact = contacts(:bill)
  end

  test 'users should be able to visit contact pages' do
    # Admin user
    log_in_as @admin
    get contacts_path
    assert_response :success
    get edit_contact_path @contact
    assert_response :success
    get new_contact_path
    assert_response :success
    # Standard User
    log_in_as @standard_user
    get contacts_path
    assert_response :success
    get edit_contact_path @contact
    assert_response :success
    get new_contact_path
    assert_response :success
  end

  test 'users should be able to create contacts' do
    log_in_as @standard_user
    assert_difference 'Contact.count', 1 do
      post contacts_path params: { contact: { name: 'Contact Name',
                                              email: 'example@email.com' } }
    end
  end

  test 'standard users should not be able to destroy users' do
    log_in_as @standard_user
    assert_no_difference 'User.count' do
      delete user_path @admin
    end
  end

  test 'admin users should be able to destroy users' do
    log_in_as @admin
    assert_difference 'User.count', -1 do
      delete user_path @standard_user
    end
  end
end

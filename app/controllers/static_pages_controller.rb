## app/controllers/static_pages_controller.rb
class StaticPagesController < ApplicationController
  include ShowsHelper
  before_action :logged_in_user, only: %i[test about]

  def home
    redirect_to current_user if logged_in?
  end

  def help; end

  def about; end

  def contact; end

  def test; end

end

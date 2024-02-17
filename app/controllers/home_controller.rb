class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def set_current_shop
    session[:current_shop_id] = params[:shop_id]
  end
end

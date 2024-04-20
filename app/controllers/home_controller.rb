class HomeController < ApplicationController
  before_action :authenticate_user!, :current_shop
  before_action :current_shop, only: [:index]

  def index;end

  def set_current_shop
    session[:current_shop_id] = params[:shop_id]
  end

end

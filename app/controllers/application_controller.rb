class ApplicationController < ActionController::Base
  def current_shop_id
    session[:current_shop_id]
  end

  def authenticate_current_shop!
    redirect_to root_path, alert: '请设置店铺' unless current_shop_id.present?
  end
end

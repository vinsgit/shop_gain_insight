class ApplicationController < ActionController::Base
  include Pagy::Backend

  helper_method :current_shop
  def current_shop
    @current_shop ||= ::Shop.find(session[:current_shop_id]) if session[:current_shop_id]
  end

  def redirect_unless_current_shop
    redirect_to root_path, alert: '请设置店铺' unless current_shop.present?
  end

  def import_service(file)
    Sheet::Processor.new(file, current_shop.id)
  end

  def set_skus
    @skus = current_shop.skus
  end
end

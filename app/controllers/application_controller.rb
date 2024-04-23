class ApplicationController < ActionController::Base
  include Pagy::Backend

  helper_method :current_shop

  before_action :set_locale

  def current_shop
    @current_shop ||= ::Shop.find(session[:current_shop_id]) if session[:current_shop_id].present?
  end

  def redirect_unless_current_shop
    redirect_to root_path, alert: t('please_set_current_shop') unless current_shop.present?
  end

  # Initialize a new instance of the Sheet::Processor for importing data
  def import_service(file)
    Sheet::Processor.new(file, current_shop.id)
  end

  def set_skus
    @skus = current_shop.skus
  end

  private

  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end
end

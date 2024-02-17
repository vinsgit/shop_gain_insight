# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def current_shop_id
    session[:current_shop_id]
  end
end

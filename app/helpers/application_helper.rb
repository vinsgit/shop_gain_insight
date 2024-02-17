# frozen_string_literal: true

module ApplicationHelper
  def current_shop_id
    session[:current_shop_id]
  end
end

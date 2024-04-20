# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def is_new_or_create?
    action_name.in?(['new', 'create'])
  end
end

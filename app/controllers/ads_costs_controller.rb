# frozen_string_literal: true

class AdsCostsController < ApplicationController
  before_action :authenticate_current_shop!

  def new;end

  def create
    params[:files].compact_blank.each do |file|
      ::AdPdf::Base.new(file.path).update!
    end
  end

end

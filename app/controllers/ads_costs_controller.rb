# frozen_string_literal: true

class AdsCostsController < ApplicationController
  before_action :redirect_unless_current_shop

  def new;end

  def create
    params[:files].compact_blank.each do |file|
      ad_pdf_service(file).update!
    end
  end

  private

  def ad_pdf_service(file)
    ::AdPdf::Processor.new(file.path)
  end
end

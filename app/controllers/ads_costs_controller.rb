# frozen_string_literal: true

class AdsCostsController < ApplicationController
  before_action :redirect_unless_current_shop

  def new;end

  def create
    params[:files].compact_blank.map do |file|
      ad_pdf_service(file).update!
    end

    redirect_to new_ads_cost_path, notice: t('success')
  end

  private

  def ad_pdf_service(file)
    ::AdPdf::Processor.new(file.path)
  end
end

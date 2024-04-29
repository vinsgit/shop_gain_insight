# frozen_string_literal: true

class ProcurementsController < ApplicationController
  before_action :redirect_unless_current_shop
  before_action :set_skus, only: [:new, :edit]
  before_action :set_procurement, only: [:edit, :update]

  def index
    @q = @current_shop.procurements.includes(:sku).ransack(params[:q])
    @pagy, @procurements = pagy(@q.result, items: 25)
  end

  def new
    @procurement = Procurement.new(purchased_at: Date.current.strftime("%Y-%m-%d"))
  end

  def edit
  end

  def create
    if params.dig(:procurement, :file).present? || params.dig(:procurement, :file2).present?
      handle_import
    else
      create_procurement_record
    end
  end

  def update
    if @procurement.update(procurement_params)
      redirect_to procurements_path, notice: '更新成功'
    else
      set_skus

      render :new
    end
  end

  private

  def procurement_params
    params.require(:procurement).permit(:sku_id, :qty, :unit_price, :total_price, :delivery_fee, :received_qty, :note, :purchased_at)
  end

  # Perform import of procurement data from the sheetfile
  def perform_import!
    import_service(params[:procurement][:file]).perform!
  end

  # Handle file import, redirecting based on success or failure
  def handle_import
    begin
      if perform_import!
        redirect_to procurements_path, notice: '创建成功'
      else
        redirect_to procurements_path, alert: '导入文件列名改变，请检查文件或联系管理员'
      end
    rescue Sheet::Errors::AttributeError => e
      redirect_to procurements_path, alert: "以下SKU（或对应链接）不存在，请检查：#{JSON.parse(e.message).join(' || ')}"
    end
  end

  def create_procurement_record
    @procurement = Procurement.new(procurement_params)
    if @procurement.save
      redirect_to procurements_path, notice: '创建成功'
    else
      set_skus

      render :new
    end
  end

  def set_procurement
    @procurement = @current_shop.procurements.find(params[:id])
  end
end

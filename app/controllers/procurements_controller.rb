# frozen_string_literal: true

class ProcurementsController < ApplicationController
  before_action :authenticate_current_shop!

  def index
    @q = Procurement.includes(:sku).ransack(params[:q])
    @pagy, @procurements = pagy(@q.result, items: 25)
  end

  def new
    @procurement = Procurement.new(purchased_at: Date.current.strftime("%Y-%m-%d"))
    @skus = Sku.all
  end

  def edit
    @skus = Sku.all
    @procurement = Procurement.find(params[:id])
  end

  def create
    if params.dig(:procurement, :file).present? || params.dig(:procurement, :file2).present?
      begin
        if perform_import!
          redirect_to procurements_path, notice: '创建成功'
        else
          redirect_to procurements_path, alert: '导入文件列名改变，请检查文件或联系管理员'
        end
      rescue Sheet::Errors::AttributeError => e
        redirect_to procurements_path, alert: "以下SKU（或对应链接）不存在，请检查：#{JSON.parse(e.message).join(' || ')}"
      end
    else
      @procurement = Procurement.new(procurement_params)
      if @procurement.save
        redirect_to procurements_path, notice: '创建成功'
      else
        @skus = Sku.all
        render :new
      end
    end
  end

  def update
    @procurement = Procurement.find(params[:id])
    if @procurement.update(procurement_params)
      redirect_to procurements_path, notice: '更新成功'
    else
      @skus = Sku.all
      render :new
    end
  end

  private

  def procurement_params
    params.require(:procurement).permit(:sku_id, :qty, :unit_price, :total_price, :delivery_fee, :received_qty, :note, :purchased_at)
  end

  def perform_import!
    do_import(params[:procurement][:file])
  end

  def do_import(file)
    import_service(file).perform!
  end
end

# frozen_string_literal: true

class ShipmentsController < ApplicationController
  before_action :authenticate_current_shop!

  def index
    @q = Shipment.ransack(params[:q])
    @pagy, @shipments = pagy(@q.result, items: 25)
  end

  def new
    @shipment = Shipment.new(transaction_at: Time.current)
  end

  def edit
    @shipment = Shipment.find(params[:id])
  end

  def create
    if params.dig(:shipment, :file).present? || params.dig(:shipment, :file2).present?
      if perform_import!
        redirect_to shipments_path, notice: '创建成功'
      else
        redirect_to shipments_path, alert: '导入文件列名改变，请检查文件或联系管理员'
      end
    else
      shipment = Shipment.new(shipment_params)
      if shipment.save
        redirect_to shipments_path, notice: '创建成功'
      else
        render :new
      end
    end
  end

  def update
    shipment = Shipment.find(params[:id])
    if shipment.update(shipment_params)
      redirect_to shipments_path, notice: '更新成功'
    else
      render :new
    end
  end

  private

  def shipment_params
    params.require(:shipment).permit(:transaction_at, :aws_order_ref, :order_ref, :total_fee, :channel)
  end

  def perform_import!
    result1 = do_import(params[:shipment][:file])
    result2 = params[:shipment][:file].present? ? do_import(params[:shipment][:file2]) : true

    result1 && result2
  end

  def do_import(file)
    import_service(file).perform!(current_shop_id)
  end
end

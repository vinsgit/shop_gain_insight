# frozen_string_literal: true

class ShipmentsController < ApplicationController
  before_action :authenticate_current_shop!

  def index
    @q = Shipment.ransack(params[:q])
    @pagy, @shipments = pagy(@q.result(distinct: true), items: 25)
  end

  def new
    @shipment = Shipment.new(transaction_at: Time.current)
  end

  def edit
    @shipment = Shipment.find(params[:id])
  end

  def create
    if params.dig(:shipment, :file).present?
      success = shipment_import_service.perform!(current_shop_id)
      if success
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

  def shipment_import_service
    Sheet::Shipment::Base.new(params[:shipment][:file])
  end
end

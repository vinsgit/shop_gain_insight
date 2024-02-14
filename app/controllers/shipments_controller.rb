# frozen_string_literal: true

class ShipmentsController < ApplicationController
  def index
    @shipments = Shipment.all
  end

  def new
    @shipment = Shipment.new
  end

  def edit
    @shipment = Shipment.find(params[:id])
  end

  def create
    shipment = Shipment.new(shipment_params)
    if shipment.save
      redirect_to shipments_path, notice: '创建成功'
    else
      render :new
    end
  end

  def update
    shipment = Shipment.find(params[:id])
    # TODO
  end

  private

  def shipment_params
    params.require(:shipment).permit(:transaction_at, :aws_order_ref, :order_ref, :total_fee, :channel)
  end
  def shipment_import_service
    Sheet::Shipment::Import.new(params[:shipment][:file])
  end
end

# frozen_string_literal: true

class ShipmentsController < ApplicationController
  before_action :redirect_unless_current_shop
  before_action :set_shipment, only: [:edit, :update]

  def index
    @q = @current_shop.shipments.ransack(params[:q])
    @pagy, @shipments = pagy(@q.result, items: 25)
  end

  def new
    @shipment = Shipment.new(transaction_at: Time.current)
  end

  def edit;end

  def create
    if params.dig(:shipment, :file).present? || params.dig(:shipment, :file2).present?
      handle_import
    else
      create_shipment_record
    end
  end

  def update
    if @shipment.update(shipment_params)
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
    case shipment_params[:channel]
    when 'sf'
      results = [params[:shipment][:file], params[:shipment][:file2]].map do |file|
        import_service(file).perform!
      end

      results.all? { |result| result == true }
    else
      import_service(params[:shipment][:file]).perform!
    end
  end

  def handle_import
    if perform_import!
      redirect_to shipments_path, notice: '创建成功'
    else
      redirect_to shipments_path, alert: '表格数量或列名不符合要求，请检查文件或联系管理员'
    end
  end

  def create_shipment_record
    shipment = @current_shop.shipments.new(shipment_params)
    if shipment.save
      redirect_to shipments_path, notice: '创建成功'
    else
      render :new
    end
  end

  def find_shipment
    Shipment.find(params[:id])
  end

  def set_shipment
    @shipment = @current_shop.shipments.find(params[:id])
  end
end

# frozen_string_literal: true

class DeliveryRecordsController < ApplicationController
  before_action :authenticate_current_shop!

  def index
    @q = DeliveryRecord.includes(:sku).ransack(params[:q])
    @pagy, @delivery_records = pagy(@q.result, items: 25)
  end

  def new
    @delivery_record = DeliveryRecord.new
    @skus = Sku.all
  end

  def edit
    @skus = Sku.all
    @delivery_record = DeliveryRecord.find(params[:id])
  end

  def create
    if params.dig(:delivery_record, :file).present?
      begin
        if perform_import!
          redirect_to delivery_records_path, notice: '创建成功'
        else
          redirect_to delivery_records_path, alert: '导入文件列名改变，请检查文件或联系管理员'
        end
      rescue Sheet::Errors::AttributeError => e
        redirect_to delivery_records_path, alert: "以下SKU（或对应链接）不存在，请检查：#{JSON.parse(e.message).join(' || ')}"
      end
    else
      @delivery_record = DeliveryRecord.new(delivery_record_params)
      @delivery_record.shop_id = current_shop_id
      if @delivery_record.save
        redirect_to delivery_records_path, notice: '创建成功'
      else
        @skus = Sku.all
        render :new
      end
    end
  end

  def update
    @delivery_record = DeliveryRecord.find(params[:id])
    if @delivery_record.update(delivery_record_params)
      redirect_to delivery_records_path, notice: '更新成功'
    else
      @skus = Sku.all
      render :new
    end
  end

  private

  def delivery_record_params
    params.require(:delivery_record).permit(:sku_id, :arrived_count, :sent_count, :deliver_at)
  end

  def perform_import!
    import_service(params[:delivery_record][:file]).perform!
  end

end

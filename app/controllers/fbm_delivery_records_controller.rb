# frozen_string_literal: true

class FbmDeliveryRecordsController < ApplicationController
  before_action :redirect_unless_current_shop
  before_action :set_skus, only: [:new, :edit]
  before_action :set_delivery_record, only: [:edit, :update]

  def index
    @q = @current_shop.fbm_delivery_records.includes(:sku).ransack(params[:q])
    @pagy, @fbm_delivery_records = pagy(@q.result, items: 25)
  end

  def new
    @fbm_delivery_record = FbmDeliveryRecord.new
  end

  def edit;end

  def create
    if params.dig(:fbm_delivery_record, :file).present?
      handle_import
    else
      create_deliver_record
    end
  end

  def update
    if @fbm_delivery_record.update(fbm_delivery_record_params)
      redirect_to fbm_delivery_records_path, notice: '更新成功'
    else
      @skus = Sku.all

      render :new
    end
  end

  private

  def fbm_delivery_record_params
    params.require(:fbm_delivery_record).permit(:sku_id, :arrived_count, :sent_count, :deliver_at)
  end

  def perform_import!
    import_service(params[:fbm_delivery_record][:file]).perform!
  end

  def handle_import
    begin
      if perform_import!
        redirect_to fbm_delivery_records_path, notice: '创建成功'
      else
        redirect_to fbm_delivery_records_path, alert: '导入文件列名改变，请检查文件或联系管理员'
      end
    rescue Sheet::Errors::AttributeError => e
      redirect_to fbm_delivery_records_path, alert: "以下SKU（或对应链接）不存在，请检查：#{JSON.parse(e.message).join(' || ')}"
    end
  end

  def create_deliver_record
    @fbm_delivery_record = FbmDeliveryRecord.new(fbm_delivery_record_params)
    @fbm_delivery_record.shop_id = @current_shop.id
    if @fbm_delivery_record.save
      redirect_to fbm_delivery_records_path, notice: '创建成功'
    else
      set_skus

      render :new
    end
  end

  def set_delivery_record
    @fbm_delivery_record = @current_shop.fbm_delivery_records.find(params[:id])
  end
end

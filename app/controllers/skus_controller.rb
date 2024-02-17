# frozen_string_literal: true

class SkusController < ApplicationController
  before_action :authenticate_current_shop!

  def index
    @skus = Sku.all
  end

  def new
    @sku = Sku.new
  end

  def edit
    @sku = Sku.find(params[:id])
  end

  def create
    if params.dig(:sku, :file).present?
      success = sku_import_service.perform!(current_shop_id)
      if success
        redirect_to skus_path, notice: '创建成功'
      else
        redirect_to skus_path, alert: '导入文件列名改变，请检查文件或联系管理员'
      end
    else
      sku = Sku.new(sku_params)
      if sku.save
        redirect_to skus_path, notice: '创建成功'
      else
        render :new
      end
    end
  end

  def update
    sku = Sku.find(params[:id])
    if sku.update(sku_params)
      redirect_to skus_path, notice: '更新成功'
    else
      render :new
    end
  end

  private

  def sku_params
    params.require(:sku).permit(:name).merge(shop_id: current_shop_id)
  end

  def sku_import_service
    import_service(params[:sku][:file])
  end
end

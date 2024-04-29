# frozen_string_literal: true

class SkusController < ApplicationController
  before_action :redirect_unless_current_shop
  before_action :set_skus, only: [:index, :edit, :create, :update]
  before_action :set_sku, only: [:edit, :update]

  def index
    @q = @skus.ransack(params[:q])
    @pagy, @skus = pagy(@q.result, items: 25)
  end

  def new
    @sku = Sku.new
  end

  def edit;end

  def create
    if params.dig(:sku, :file).present?
      if import_service(params[:sku][:file]).perform!
        redirect_to skus_path, notice: '创建成功'
      else
        redirect_to skus_path, alert: '导入文件列名改变，请检查文件或联系管理员'
      end
    else
      sku = @skus.new(sku_params)
      if sku.save
        redirect_to skus_path, notice: '创建成功'
      else
        render :new
      end
    end
  end

  def update
    if @sku.update(sku_params)
      redirect_to skus_path, notice: '更新成功'
    else
      render :new
    end
  end

  private

  def sku_params
    params.require(:sku).permit(:name, :price).merge(shop_id: @current_shop.id)
  end

  def set_sku
    @sku = @skus.find(params[:id])
  end
end

# frozen_string_literal: true

class SkusController < ApplicationController
  before_action :authenticate_current_shop!

  def index
    @q = Sku.ransack(params[:q])
    @pagy, @skus = pagy(@q.result, items: 25)
  end

  def new
    @sku = Sku.new
  end

  def edit
    @sku = Sku.find(params[:id])
  end

  def create
    if params.dig(:sku, :file).present?
      if do_import!
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

  def do_import!
    import_service(params[:sku][:file]).perform!
  end
end

# frozen_string_literal: true

class SkusController < ApplicationController
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
    sku = Sku.new(sku_params)
    if sku.save
      redirect_to skus_path, notice: '创建成功'
    else
      render :new
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
    params.require(:sku).permit(:name)
  end
end

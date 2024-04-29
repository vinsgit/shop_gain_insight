# frozen_string_literal: true

class ShopsController < ApplicationController
  before_action :set_shop, only: [:edit, :update]

  def index
    @shops = Shop.all
  end

  def new
    @shop = Shop.new
  end

  def edit;end

  def create
    shop = Shop.new(shop_params)
    if shop.save
      redirect_to shops_path, notice: '创建成功'
    else
      render :new
    end
  end


  def update
    if @shop.update(shop_params)
      redirect_to shops_path, notice: '更新成功'
    else
      render :new
    end
  end

  private

  def shop_params
    params.require(:shop).permit(:name)
  end

  def set_shop
    @shop = Shop.find(params[:id])
  end
end

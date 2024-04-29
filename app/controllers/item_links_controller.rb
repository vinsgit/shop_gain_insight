# frozen_string_literal: true

class ItemLinksController < ApplicationController
  before_action :redirect_unless_current_shop
  before_action :set_item_link, only: [:edit, :update]
  before_action :set_sku_ids, only: [:edit, :update]

  def index
    @item_links = @current_shop.item_links.includes(:skus)
  end

  def new
    @item_link = ItemLink.new
  end

  def edit;end

  def create
    item_link = ItemLink.new(item_link_params)
    if item_link.save
      redirect_to item_links_path, notice: '创建成功'
    else
      render :new
    end
  end

  def update
    if @item_link.update(item_link_params)
      redirect_to item_links_path, notice: '更新成功'
    else
      render :new
    end
  end

  private

  def set_item_link
    @item_link = @current_shop.item_links.find(params[:id])
  end

  def item_link_params
    params.require(:item_link).permit(:name, set_: []).merge(shop_id: current_shop.id)
  end

  def set_sku_ids
    @sku_ids = @item_link.skus.ids
  end
end

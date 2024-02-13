# frozen_string_literal: true

class ItemLinksController < ApplicationController
  def index
    @item_links = ItemLink.all.includes(:skus)
  end

  def new
    @item_link = ItemLink.new
  end

  def edit
    @item_link = ItemLink.find(params[:id])
    @sku_ids = @item_link.skus.ids
  end

  def create
    item_link = ItemLink.new(item_link_params)
    if item_link.save
      redirect_to item_links_path, notice: '创建成功'
    else
      render :new
    end
  end

  def update
    item_link = ItemLink.find(params[:id])
    @sku_ids = item_link.skus.ids
    if item_link.update(item_link_params)
      redirect_to item_links_path, notice: '更新成功'
    else
      render :new
    end
  end

  private

  def item_link_params
    params.require(:item_link).permit(:name, sku_ids: [])
  end
end

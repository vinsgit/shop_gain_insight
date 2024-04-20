# frozen_string_literal: true

class AwsOrdersController < ApplicationController
  before_action :redirect_unless_current_shop
  before_action :set_skus, only: [:new, :edit]

  def index
    @q = @current_shop.aws_orders.includes(:sku).ransack(params[:q])
    @pagy, @aws_orders = pagy(@q.result(distinct: true), items: 25)
  end

  def new
    @aws_order = AwsOrder.new
  end

  def create
    begin
      if import_service(params[:aws_order][:file]).perform!
        redirect_to aws_orders_path, notice: '创建成功'
      else
        redirect_to aws_orders_path, alert: '导入文件列名改变，请检查文件或联系管理员'
      end
    rescue Sheet::Errors::AttributeError => e
      redirect_to aws_orders_path, alert: "系统出错了，请联系管理员"
    end
  end

  def edit
    @aws_order = @current_shop.aws_orders.find(params[:id])
  end

  def update
    @aws_order = @current_shop.aws_orders.find(params[:id])
    @aws_order.update(permitted_params)
  end

  private

  def permitted_params
    params.require(:aws_order).permit(:sku_id, :order_ref, :merchant_order_ref, :amt, :promotion_ref, :desc, :amend_amt, :note, :posted_at)
  end
end

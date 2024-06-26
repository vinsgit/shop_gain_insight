# frozen_string_literal: true

class InvestorsController < ApplicationController
  before_action :redirect_unless_current_shop
  before_action :set_investor, only: [:edit, :update]

  def index
    @investors = @current_shop.investors
  end

  def new
    @investor = Investor.new
  end

  def edit;end

  def create
    @investor = @current_shop.investors.new(investor_params)
    if @investor.save
      redirect_to investors_path, notice: '创建成功'
    else
      render :new
    end
  end

  def update
    if @investor.update(investor_params)
      redirect_to investors_path, notice: '更新成功'
    else
      render :new
    end
  end

  private

  def investor_params
    params.require(:investor).permit(:name, equity_allocation_records_attributes: [:id, :ratio, :start_at, :end_at, :_destroy])
  end

  def set_investor
    @investor = @current_shop.investors.find(params[:id])
  end
end

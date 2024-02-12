# frozen_string_literal: true

class InvestorsController < ApplicationController
  def index
    @investors = Investor.all
  end

  def new
    @investor = Investor.new
  end

  def edit
    @investor = Investor.find(params[:id])
  end

  def create
    investor = Investor.new(investor_params)
    if investor.save
      redirect_to investors_path, notice: '创建成功'
    else
      render :new
    end
  end

  def update
    investor = Investor.find(params[:id])
    if investor.update(investor_params)
      redirect_to investors_path, notice: '更新成功'
    else
      render :new
    end
  end

  private

  def investor_params
    params.require(:investor).permit(:name, equity_allocation_records_attributes: [:id, :ratio, :start_at, :end_at, :_destroy])
  end

end

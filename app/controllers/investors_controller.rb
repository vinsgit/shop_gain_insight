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
      investor.save_allocation(**allocation_records_params)
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
    params.require(:investor).permit(:name)
  end

  def allocation_records_params
    hash = params.require(:investor).permit(equity_allocation_record: %i[start_at end_at ratio]).require('equity_allocation_record').to_h

    {
      ratio: hash['ratio'],
      start_at: hash['start_at'],
      end_at: hash['end_at']
    }
  end
end

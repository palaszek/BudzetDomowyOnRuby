class IncomesController < ApplicationController
  def new
    @wallet = Wallet.find(params[:wallet_id])
  end

  def create
    @wallet = Wallet.find(params[:wallet_id])
    @income = @wallet.incomes.new(income_params)

    if @income.save
      redirect_to wallet_path(@wallet)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def income_params
    params.require(:income).permit(:title, :amount)
  end
end

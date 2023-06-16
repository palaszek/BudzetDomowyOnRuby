class SpendingsController < ApplicationController

  def new
    @wallet = Wallet.find(params[:wallet_id])
    @spending = @wallet.spendings.new
  end

  def create
    @wallet = Wallet.find(params[:wallet_id])
    @spending = @wallet.spendings.new(spending_params)

    if @spending.save
      redirect_to wallet_path(@wallet)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def spending_params
    params.require(:spending).permit(:title, :amount, :category_id)
  end
end

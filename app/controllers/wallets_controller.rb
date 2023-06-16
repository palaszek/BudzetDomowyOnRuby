class WalletsController < ApplicationController
  helper_method :transactions_chart_data
  before_action :authenticate_user!
  def index
    @user = User.find(current_user.id)
    @wallets = @user.wallets.all
  end
  def show
    @user = User.find(current_user.id)
    @wallet = @user.wallets.find(params[:id])
    @incomes = @wallet.incomes.all
    @spendings = @wallet.spendings.all
    @transactions = (@incomes + @spendings).sort_by(&:created_at).reverse

    @dostepnesrodki = 0
    @dostepnesrodki = @incomes.sum(:amount)
    @dostepnesrodki -=@spendings.sum(:amount)
  end

  def new
    @user=User.find(params[:user_id])
    @wallet=@user.wallets.new
  end
  def create
    @user = User.find(current_user.id)
    @wallet = @user.wallets.create(wallet_params)

    #if @user.save
    redirect_to wallet_path(@wallet)
    #else
    # flash.alert = @user.errors.full_messages
    # render :new, status: :unprocessable_entity
    #end
  end
  def confirm
    @wallet = Wallet.find(params[:id])
    user_id = params[:wallet][:user_id]
    @user = User.find(user_id)
    if(@user.wallets.where(name: @wallet.name))
      flash.alert = "Użytkownik #{@user.nick} jest już przypisany do tego portfela"
    else
      @user.wallets << @wallet
      flash.alert = "Pomyślnie dodano użytkownika #{@user.nick} do portfela #{@wallet.name}"

      end

    redirect_to @wallet
  end



  private

  def wallet_params
    params.require(:wallet).permit(:name)
  end
  def transactions_chart_data
    chart_data = []
    Category.all do |category|
      spending_name = category.spendings.name
      chart_data[spending_name] ||= {}
      chart_data[spending_name][category.created_at] ||= 0
      chart_data[spending_name][category.created_at] += category.amount
    end
    chart_data.map { |category, data| {name: category, data: created_at}}
  end
end

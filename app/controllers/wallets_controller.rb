class WalletsController < ApplicationController
  helper_method :transactions_chart_data
  before_action :authenticate_user!
  def index
    @wallets = Wallet.all
  end
  def show
    @user = User.find(current_user.id)
    @wallet = @user.wallets.first
    @incomes = @wallet.incomes.all
    @spendings = @wallet.spendings.all
    @transactions = (@incomes + @spendings).sort_by(&:created_at).reverse

    @dostepnesrodki = 0
    @dostepnesrodki = @incomes.sum(:amount)
    @dostepnesrodki -=@spendings.sum(:amount)
  end

  def new
  end

  private

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

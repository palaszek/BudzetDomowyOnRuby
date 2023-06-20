class WalletsController < ApplicationController
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
    @spending_data = @spendings.group(:category_id).sum(:amount)

    # Pobierz wszystkie kategorie z modelu Category
    @categories = Category.all

    # Utwórz pusty hash, który będzie przechowywał dane do wykresu kołowego
    @chart_data = {}

    # Przeiteruj przez dane o wydatkach
    @spending_data.each do |category_id, amount|
      # Znajdź nazwę kategorii na podstawie jej ID
      category_name = @categories.find_by(id: category_id)&.name

      # Dodaj dane do wykresu kołowego tylko, jeśli znaleziono nazwę kategorii
      if category_name
        @chart_data[category_name] = amount
      end
    end
  end

  def new
    @user=User.find(params[:user_id])
    @wallet=@user.wallets.new
  end
  def create
    @user = User.find(current_user.id)
    @wallet = @user.wallets.create(wallet_params)
    redirect_to wallet_path(@wallet)

    end
  def confirm
    @wallet = Wallet.find(params[:id])
    user_id = params[:wallet][:user_id]
    @user = User.find(user_id)
    if @user.wallets.where(name: @wallet.name) == []
      @user.wallets << @wallet
      flash.alert = "Pomyślnie dodano użytkownika #{@user.nick} do portfela #{@wallet.name}"
    else

      flash.alert = "Użytkownik #{@user.nick} jest już przypisany do tego portfela"
      end
    redirect_to @wallet
  end

  def destroy
    @user = User.find(current_user.id)
    @wallet = Wallet.find(params[:id])
    @wallet.destroy
    redirect_to wallets_path
  end

  def generate_pdf
    @user = User.find(current_user.id)
    @wallet = @user.wallets.find(params[:id])
    @incomes = @wallet.incomes.all
    @spendings = @wallet.spendings.all
    @transactions = (@incomes + @spendings).sort_by(&:created_at).reverse

    @dostepnesrodki = 0
    @dostepnesrodki = @incomes.sum(:amount)
    @dostepnesrodki -=@spendings.sum(:amount)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = Prawn::Document.new

        pdf.font_families["pdfFont"] = {
          normal: "#{Rails.root}/app/assets/fonts/Roboto-Bold.ttf"
        }

        pdf.font "pdfFont"


        pdf.text "Budzet domowy - #{@wallet.name}"

        pdf.move_down 30
        pdf.text "Historia Transakcji:"
        pdf.move_down 10

        @transactions.each do |transaction|
          pdf.text "#{transaction.created_at.strftime('%Y-%m-%d %H:%M:%S')}"
          if transaction.is_a? Income
            pdf.text "Przychód:"
          else
            pdf.text "Wydatek:"
          end
          pdf.text "#{transaction.title} #{transaction.amount}zł"
          pdf.move_down 30
        end
        pdf.text "#{@wallet.name} - dostępne środki: #{@dostepnesrodki}zł"

        send_data pdf.render, filename: 'wallet.pdf', type: 'application/pdf', disposition: 'inline'
      end
    end
  end
  private

  def wallet_params
    params.require(:wallet).permit(:name)
  end
end

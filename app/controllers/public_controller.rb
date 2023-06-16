class PublicController < ApplicationController
  def home
  end

  def destroy
    @user = User.find(current_user.id)
    @user.destroy

    if @user.destroy
      redirect_to root_url, notice: "Usunięto Użytkownika"
    end
  end
end

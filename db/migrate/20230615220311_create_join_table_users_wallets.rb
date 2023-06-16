class CreateJoinTableUsersWallets < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :wallets do |t|
       t.index [:user_id, :wallet_id]
       t.index [:wallet_id, :user_id]
    end
  end
end

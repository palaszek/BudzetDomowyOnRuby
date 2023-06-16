class CreateIncomes < ActiveRecord::Migration[7.0]
  def change
    create_table :incomes do |t|
      t.float :amount
      t.string :title
      t.references :wallet, null: false, foreign_key: true

      t.timestamps
    end
  end
end

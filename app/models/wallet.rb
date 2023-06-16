class Wallet < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :incomes
  has_many :spendings

  validates :name, presence: true, length: {maximum: 30}
end

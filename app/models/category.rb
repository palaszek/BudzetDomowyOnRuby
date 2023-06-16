class Category < ApplicationRecord
  has_many :incomes
  has_many :spendings
  validates :name, presence: true
end

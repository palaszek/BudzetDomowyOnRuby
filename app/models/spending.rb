class Spending < ApplicationRecord
  belongs_to :wallet
  belongs_to :category
  validates :title, presence: true
  validates :amount, presence: true

  accepts_nested_attributes_for :wallet
end

class Income < ApplicationRecord
  belongs_to :wallet
  validates :title, presence: true
  validates :amount, presence: true
end

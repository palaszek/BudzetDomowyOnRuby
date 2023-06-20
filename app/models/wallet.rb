class Wallet < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :incomes, dependent: :destroy
  has_many :spendings, dependent: :destroy

  validates :name, presence: true, length: {maximum: 30}
  validate :name_presence

  private
  def name_presence
    errors.add(:name, "must be present") if name.blank?
  end
end

class Quotation < ActiveRecord::Base

  has_one :person, dependent: :destroy
  has_one :policy, dependent: :destroy
  has_one :vehicle, dependent: :destroy
  has_many :incidents, dependent: :destroy

  validates :premium, presence: true, numericality: true
  validates :calculation_date, presence: true
  validates :code, presence: true, uniqueness: true

end

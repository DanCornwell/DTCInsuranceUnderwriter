class Quotation < ActiveRecord::Base

  has_one :person, dependent: :destroy

  validates :premium, presence: true, numericality: true
  validates :calculation_date, presence: true
  validates :code, presence: true, uniqueness: true

end

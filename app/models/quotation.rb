class Quotation < ActiveRecord::Base
  before_save {self.code = code.downcase}

  has_one :person, dependent: :destroy

  validates :premium, presence: true, numericality: true
  validates :calculation_date, presence: true
  validates :code, presence: true, uniqueness: { case_sensitive: false }

end

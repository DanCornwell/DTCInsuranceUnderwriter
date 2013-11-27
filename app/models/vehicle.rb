class Vehicle < ActiveRecord::Base

  belongs_to :quotation

  validates :registration, presence:true
  validates :mileage, presence:true, numericality: true
  validates :estimated_value, presence:true, numericality: {greater_than: 0}
  validates :parking, presence:true, inclusion: {in: ["In a garage", "On a driveway", "On a street"]}
  validates_date :start_date, presence:true, :on_or_after => lambda {Date.current}
  validates :quotation_id, presence:true, numericality: true

end

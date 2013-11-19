class Incident < ActiveRecord::Base

  belongs_to :quotation

  validates :quotation_id, presence:true, numericality: true
  validates_date :incident_date, presence:true, :before => lambda {Date.current}
  validates :claim_sum, presence:true, numericality: true
  validates :incident_type, presence:true, inclusion: {in: ["Head on collision", "Single vehicle collision", "Intersection collision"]}
  validates :description, presence:true

end

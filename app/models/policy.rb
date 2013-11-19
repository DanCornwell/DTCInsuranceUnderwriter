class Policy < ActiveRecord::Base

  belongs_to :quotation

  validates :quotation_id, presence:true, numericality: true
  validates :excess, presence:true, numericality: true
  validates :breakdown_cover, presence: true, inclusion: {in: ["At home", "Roadside", "European", "No breakdown cover"]}
  validates :windscreen_cover, presence: true, inclusion: {in: %w(Yes No)}

end

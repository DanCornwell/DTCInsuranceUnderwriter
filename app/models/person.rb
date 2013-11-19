class Person < ActiveRecord::Base

  belongs_to :quotation

  validates :quotation_id, presence:true, numericality: true
  validates :forename, presence:true, format: {with: /\A[a-zA-Z]+\z/}
  validates :surname, presence:true, format: {with: /\A[a-zA-Z]+\z/}
  validates :email, presence:true, format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}
  validates_date :dob, presence:true, :on_or_before => lambda {17.years.ago}
  validates :telephone, presence:true, length: {maximum: 11}, format: {with: /\A[0-9]+\z/}
  validates :street, presence:true, format: {with: /\A[A-Za-z0-9 _]*[A-Za-z0-9][A-Za-z0-9 _]*\z/}
  VALID_PLACE_NAME_REGEX = /\A[A-Za-z _]*[A-Za-z][A-Za-z _]*\z/
  validates :city, presence:true, format: {with: VALID_PLACE_NAME_REGEX}
  validates :county, presence:true, format: {with: VALID_PLACE_NAME_REGEX}
  validates :postcode, presence:true, format: {with: /[a-zA-Z]{2}[0-9]{1,2}\s{0,1}[0-9]{1}[a-zA-Z]{2}/}
  validates :license_type, presence:true, inclusion: {in: %w(Full Provisional) }
  validates :license_period, presence:true, numericality: true
  validates :occupation, presence:true
  validates :number_incidents, presence:true, numericality: true

end

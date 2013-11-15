class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.integer :quotation_id
      t.string :title
      t.string :forename
      t.string :surname
      t.string :email
      t.date :dob
      t.string :telephone
      t.string :street
      t.string :city
      t.string :county
      t.string :postcode
      t.string :license_type
      t.integer :license_period
      t.string :occupation

      t.timestamps
    end
  end
end

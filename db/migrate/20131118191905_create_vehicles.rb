class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :registration
      t.integer :mileage
      t.integer :estimated_value
      t.string :parking
      t.date :start_date
      t.integer :quotation_id

      t.timestamps
    end
  end
end

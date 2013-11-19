class CreateIncidents < ActiveRecord::Migration
  def change
    create_table :incidents do |t|
      t.date :incident_date
      t.integer :claim_sum
      t.string :type
      t.string :description
      t.integer :quotation_id

      t.timestamps
    end
  end
end

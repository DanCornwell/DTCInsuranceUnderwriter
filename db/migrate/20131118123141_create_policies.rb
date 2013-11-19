class CreatePolicies < ActiveRecord::Migration
  def change
    create_table :policies do |t|
      t.integer :excess
      t.string :breakdown_cover
      t.string :windscreen_cover
      t.integer :quotation_id

      t.timestamps
    end
  end
end

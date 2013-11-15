class CreateQuotations < ActiveRecord::Migration
  def change
    create_table :quotations do |t|
      t.integer :premium
      t.date :calculation_date

      t.timestamps
    end
  end
end

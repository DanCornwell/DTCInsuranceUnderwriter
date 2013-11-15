class AddColumnNumberIncidentsToPerson < ActiveRecord::Migration
  def change
    add_column :quotations, :number_incidents, :integer
  end
end

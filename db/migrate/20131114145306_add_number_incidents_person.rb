class AddNumberIncidentsPerson < ActiveRecord::Migration
  def change
    add_column :people, :number_incidents, :integer
  end
end

class RemoveNumberIncidentsQuotations < ActiveRecord::Migration
  def change
    remove_column :quotations, :number_incidents
  end
end

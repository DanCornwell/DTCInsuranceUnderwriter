class AddIndexToQuotationsCode < ActiveRecord::Migration
  def change
    add_index :quotations, :code, unique: true
  end
end

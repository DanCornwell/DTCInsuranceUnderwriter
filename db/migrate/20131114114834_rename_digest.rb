class RenameDigest < ActiveRecord::Migration
  def change
    rename_column :quotations, :password_digest, :code
  end
end

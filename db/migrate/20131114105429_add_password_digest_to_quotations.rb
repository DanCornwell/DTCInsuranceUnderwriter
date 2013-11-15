class AddPasswordDigestToQuotations < ActiveRecord::Migration
  def change
    add_column :quotations, :password_digest, :string
  end
end

class AddIsVerifiedToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :is_verified, :boolean
  end
end

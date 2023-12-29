class CreateOtps < ActiveRecord::Migration[7.1]
  def change
    create_table :otps do |t|
      t.string :otp, null: false

      t.datetime :expires_at, null: false

      t.references :user, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end

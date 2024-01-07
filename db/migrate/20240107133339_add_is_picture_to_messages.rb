class AddIsPictureToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :is_picture, :boolean
  end
end

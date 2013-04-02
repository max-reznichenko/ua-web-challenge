class CreateImageAttachments < ActiveRecord::Migration
  def change
    create_table :image_attachments do |t|
      t.integer :product_id
    end

    add_index :image_attachments, :product_id
  end
end

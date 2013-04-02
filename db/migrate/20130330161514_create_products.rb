class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :price, limit: 8
      t.decimal :discount_value, precision: 2, scale: 2
      t.integer :stock_count, limit: 6
      t.integer :sub_category_id
      t.integer :brand_id
      t.boolean :is_top_seller

      t.timestamps
    end

    add_index :products, :brand_id
  end
end

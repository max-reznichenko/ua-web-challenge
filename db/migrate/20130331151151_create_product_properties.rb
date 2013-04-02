class CreateProductProperties < ActiveRecord::Migration
  def change
    create_table :product_properties do |t|
      t.string :name
      t.string :value
      t.string :value
      t.boolean :is_primary
      t.integer :product_id
    end

    add_index :product_properties, :product_id

    # For filtering purposes
    add_index :product_properties, :name
    add_index :product_properties, :value
  end
end

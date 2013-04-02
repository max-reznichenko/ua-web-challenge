class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :value, limit: 1
      t.integer :product_id
      t.integer :user_id

      t.timestamps
    end

    add_index :ratings, :product_id
    add_index :ratings, :user_id
  end
end

class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :product_id
      t.integer :user_id
      t.text :positive_description
      t.text :negative_description
      t.text :custom_description

      t.timestamps
    end

    add_index :reviews, :product_id
    add_index :reviews, :user_id
  end
end

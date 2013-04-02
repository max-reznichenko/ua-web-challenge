class Rating < ActiveRecord::Base
  attr_accessible :product_id, :user_id, :value

  belongs_to :user
  belongs_to :product
end

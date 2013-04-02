class Review < ActiveRecord::Base
  attr_accessible :custom_description, :positive_description, :negative_description

  belongs_to :product
  belongs_to :user
end

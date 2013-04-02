class ImageAttachment < ActiveRecord::Base
  attr_accessible :attachment, :product_id

  belongs_to :product
  has_attached_file :attachment, :styles => { :medium => "300x300>", :thumb => "100x100>" }
end

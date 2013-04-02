class Product < ActiveRecord::Base
  attr_accessible :name, :description

  belongs_to :sub_category
  has_many :product_properties
  belongs_to :brand
  has_many :reviews
  has_many :ratings
  has_many :image_attachments

  def human_primary_properties
    product_properties.where(:is_primary => true).map(&:value).join(' / ')
  end

  def human_secondary_properties
    product_properties.where(:is_primary => false).map(&:value).join(' / ')
  end

  define_index do
    indexes :name
    indexes :description
  end

end

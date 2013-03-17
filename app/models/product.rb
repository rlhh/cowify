class Product < ActiveRecord::Base
  attr_accessible :available, :item_ID, :name, :static_image

  validates :item_ID, :uniqueness => true

  has_many :lots
end

class Lot < ActiveRecord::Base
      attr_accessible :active, :content_ID, :grade, :grade_num, :image, :included, 
  :inventory_ID, :location, :not_included, :notes, :page, :price, :product_id, :row

  default_scope order ('grade_num DESC')
  validates :inventory_ID, :uniqueness => true

  belongs_to :product

end

# == Schema Information
#
# Table name: lots
#
#  id             :integer          not null, primary key
#  product_id     :integer          not null
#  cowboom_lot_id :integer          not null
#  content_id     :integer          not null
#  price          :decimal(12, 4)   not null
#  grade          :string(255)
#  grade_num      :integer          default(10)
#  included       :string(255)
#  location       :string(255)
#  not_included   :string(255)
#  notes          :string(255)
#  active         :boolean          default(FALSE), not null
#  image          :string(255)
#  page           :integer          not null
#  row            :integer          not null
#  created_at     :datetime
#  updated_at     :datetime
#

class Lots < ActiveRecord::Base
end

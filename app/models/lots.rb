# == Schema Information
#
# Table name: lots
#
#  id           :integer          not null, primary key
#  active       :boolean          default(FALSE), not null
#  content_ID   :integer          not null
#  grade        :string(255)
#  grade_num    :integer          default(10)
#  image        :string(255)
#  included     :string(255)
#  inventory_ID :integer          not null
#  location     :string(255)
#  not_included :string(255)
#  notes        :string(255)
#  page         :integer          not null
#  price        :decimal(12, 4)   not null
#  product_id   :integer          not null
#  row          :integer          not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Lots < ActiveRecord::Base
end
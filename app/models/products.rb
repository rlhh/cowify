# == Schema Information
#
# Table name: products
#
#  id           :integer          not null, primary key
#  available    :boolean          default(FALSE), not null
#  cowboom_id   :integer          not null
#  name         :string(255)      not null
#  static_image :string(255)      not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Products < ActiveRecord::Base
end

class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.boolean :available
      t.integer :item_ID
      t.string :name
      t.string :static_image

      t.timestamps
    end
  end
end

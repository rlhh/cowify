class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.boolean :available, null: false, default: false
      t.integer :item_ID, null: false, :unique => true
      t.string :name, null: false
      t.string :static_image, null: false

      t.timestamps
    end
  end
end

class CreateLots < ActiveRecord::Migration
  def change
    create_table :lots do |t|
      t.boolean :active
      t.integer :content_ID
      t.string :grade
      t.integer :grade_num
      t.string :image
      t.string :included
      t.integer :inventory_ID
      t.string :location
      t.string :not_included
      t.string :notes
      t.integer :page
      t.decimal :price
      t.integer :product_id
      t.integer :row

      t.timestamps
    end
  end
end

class CreateLots < ActiveRecord::Migration
  def change
    create_table :lots do |t|
      t.boolean :active, null: false, default: false
      t.integer :content_ID, null: false
      t.string :grade
      t.integer :grade_num
      t.string :image
      t.string :included
      t.integer :inventory_ID, null: false
      t.string :location
      t.string :not_included
      t.string :notes
      t.integer :page, null: false
      t.decimal :price, null: false
      t.integer :product_id, null: false
      t.integer :row, null: false

      t.timestamps
    end
  end
end

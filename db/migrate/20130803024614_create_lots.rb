class CreateLots < ActiveRecord::Migration
  def change
    create_table :lots do |t|
      t.integer :product_id,      null: false
      t.integer :cowboom_lot_id,  null: false
      t.integer :content_id,      null: false
      t.decimal :price,           null: false, precision: 12, scale: 4
      t.string  :grade
      t.integer :grade_num,       default: 10
      t.string  :included
      t.string  :location
      t.string  :not_included
      t.string  :notes
      t.boolean :active,          null: false, default: false
      t.string  :image
      t.integer :page,            null: false
      t.integer :row,             null: false

      t.timestamps
    end
  end
end

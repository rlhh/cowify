class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :cowboom_id,    null: false,  unique: true
      t.string  :name,          null: false
      t.boolean :available,     null: false,  default: false
      t.string  :static_image,  null: false

      t.timestamps
    end
  end
end

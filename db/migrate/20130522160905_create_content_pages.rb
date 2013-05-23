class CreateContentPages < ActiveRecord::Migration
  def change
    create_table :content_pages do |t|
      t.references :theme
      t.string :title
      t.text :content
      t.integer :item_order, :default => 0
      t.timestamps
    end

    add_index :content_pages, :title
    add_index :content_pages, :item_order
  end
end

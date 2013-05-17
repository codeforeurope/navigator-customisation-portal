class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.references :user
      t.string :name
      t.text :description
      t.boolean :is_searchable, :default => false	
      t.timestamps
    end

    add_index :themes, :name
    add_index :themes, :is_searchable
  end
end

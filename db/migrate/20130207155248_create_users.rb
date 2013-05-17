class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :firstname
      t.string :lastname
      t.boolean :agree_terms_and_conditions, :default => false	
      t.integer :roles_mask, :default => 0
      t.timestamps
    end

    add_index :users, :username
  end
end

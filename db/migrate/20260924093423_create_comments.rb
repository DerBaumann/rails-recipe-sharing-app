class CreateComments < ActiveRecord::Migration[8.1]
  def change
    create_table :comments do |t|
      t.string :title, null: false
      t.text :body
      t.integer :rating, null: false
      t.references :recipe, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :comments, [ :recipe_id, :author_id ], unique: true
  end
end

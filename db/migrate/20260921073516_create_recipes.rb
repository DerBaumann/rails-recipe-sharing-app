class CreateRecipes < ActiveRecord::Migration[8.1]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.integer :prep_time_minutes, null: false, default: 0
      t.text :instructions, null: false
      t.boolean :is_published, null: false, default: false

      t.timestamps
    end
  end
end

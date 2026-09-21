class CreateIngredients < ActiveRecord::Migration[8.1]
  def change
    create_table :ingredients do |t|
      t.string :name, null: false
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.string :unit, null: false
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end

require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  setup do
    @member1 = users(:member1)
    @recipe = recipes(:carbonara)
  end

  test "should be invalid without a title" do
    recipe = Recipe.new(instructions: "Boil water...", prep_time_minutes: 20, user: @member1)
    assert_not recipe.valid?
    assert_includes recipe.errors[:title], "can't be blank"
  end

  test "should be invalid with negative preparation time" do
    recipe = Recipe.new(title: "Pasta", instructions: "Cook", prep_time_minutes: -5, user: @member1)
    assert_not recipe.valid?
  end

  test "should save recipe with nested ingredients inside a transaction" do
    assert_difference [ "Recipe.count", "Ingredient.count" ], 1 do
      Recipe.create!(
        title: "Pesto Pasta",
        instructions: "Blend ingredients and mix with pasta",
        prep_time_minutes: 15,
        user: @member1,
        ingredients_attributes: [ { name: "Basil", amount: 50, unit: "g" } ]
      )
    end
  end
end

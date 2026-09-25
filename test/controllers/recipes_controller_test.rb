# require "test_helper"
#
# class RecipesControllerTest < ActionDispatch::IntegrationTest
#   setup do
#     @recipe = recipes(:one)
#   end
#
#   test "should get index" do
#     get recipes_url
#     assert_response :success
#   end
#
#   test "should get new" do
#     get new_recipe_url
#     assert_response :success
#   end
#
#   test "should create recipe" do
#     assert_difference("Recipe.count") do
#       post recipes_url, params: { recipe: { instructions: @recipe.instructions, is_published: @recipe.is_published, prep_time_minutes: @recipe.prep_time_minutes, title: @recipe.title } }
#     end
#
#     assert_redirected_to recipe_url(Recipe.last)
#   end
#
#   test "should show recipe" do
#     get recipe_url(@recipe)
#     assert_response :success
#   end
#
#   test "should get edit" do
#     get edit_recipe_url(@recipe)
#     assert_response :success
#   end
#
#   test "should update recipe" do
#     patch recipe_url(@recipe), params: { recipe: { instructions: @recipe.instructions, is_published: @recipe.is_published, prep_time_minutes: @recipe.prep_time_minutes, title: @recipe.title } }
#     assert_redirected_to recipe_url(@recipe)
#   end
#
#   test "should destroy recipe" do
#     assert_difference("Recipe.count", -1) do
#       delete recipe_url(@recipe)
#     end
#
#     assert_redirected_to recipes_url
#   end
# end

require "test_helper"

class RecipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @member1 = users(:member1)
    @member2 = users(:member2)
    @recipe = recipes(:carbonara)
  end

  def sign_in_as(user)
    post session_path, params: { email_address: user.email_address, password: "P4ssw0rd!" }
  end

  test "should redirect unauthenticated guest accessing protected route" do
    get new_recipe_path
    assert_response :redirect
  end

  test "should deny access when user tries to edit another user's recipe" do
    sign_in_as(@member2)
    get edit_recipe_path(@recipe)
    assert_includes [ 403, 302 ], response.status
  end

  test "should create recipe and generate activity log upon success" do
    sign_in_as(@member1)

    assert_difference [ "Recipe.count", "ActivityLog.count" ], 1 do
      post recipes_path, params: {
        recipe: {
          title: "Vegetable Soup",
          instructions: "Boil water and add chopped vegetables",
          prep_time_minutes: 20,
          is_published: true
        }
      }
    end

    assert_response :redirect
    assert_equal "recipes#create", ActivityLog.last.action
  end

  test "should return HTTP 422 when recipe creation fails validation" do
    sign_in_as(@member1)

    assert_no_difference "Recipe.count" do
      post recipes_path, params: {
        recipe: { title: "", instructions: "Invalid recipe without title" }
      }
    end

    assert_response :unprocessable_entity
  end
end

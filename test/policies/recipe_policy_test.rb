require "test_helper"

class RecipePolicyTest < ActiveSupport::TestCase
  setup do
    @admin = users(:admin)
    @owner = users(:member1)
    @other_user = users(:member2)
    @recipe = recipes(:carbonara)
    @draft = recipes(:draft_mousse)
  end

  test "author can update and destroy own recipe" do
    assert RecipePolicy.new(@owner, @recipe).update?
    assert RecipePolicy.new(@owner, @recipe).destroy?
  end

  test "non-author user cannot update or destroy recipe" do
    assert_not RecipePolicy.new(@other_user, @recipe).update?
    assert_not RecipePolicy.new(@other_user, @recipe).destroy?
  end

  test "admin can update and destroy any recipe" do
    assert RecipePolicy.new(@admin, @recipe).update?
    assert RecipePolicy.new(@admin, @recipe).destroy?
  end

  test "guests do not see drafts in policy scope" do
    scope = RecipePolicy::Scope.new(nil, Recipe).resolve
    assert_includes scope, @recipe
    assert_not_includes scope, @draft
  end
end

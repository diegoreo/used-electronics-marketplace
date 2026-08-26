require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login
    @category = categories(:clothes)
  end

  test "should get index" do
    get categories_url
    assert_response :success
  end

  test "should get new" do
    get new_category_url
    assert_response :success
  end

  test "should create category" do
    assert_difference("Category.count") do
      post categories_url, params: { category: { name: @category.name } }
    end

    assert_redirected_to categories_url
  end


  test "should get edit" do
    get edit_category_url(@category)
    assert_response :success
  end

  test "should update category" do
    patch category_url(@category), params: { category: { name: @category.name } }
    assert_redirected_to categories_url
  end

  test "should destroy category" do
    assert_difference("Category.count", -1) do
      delete category_url(@category)
    end

    assert_redirected_to categories_url
  end

  test "does not allow a non-admin to view categories index" do
    login(users(:maria))
    get categories_url
    assert_redirected_to products_path
  end

  test "does not allow a non-admin to view the new category form" do
    login(users(:maria))
    get new_category_url
    assert_redirected_to products_path
  end

  test "does not allow a non-admin to create a category" do
    login(users(:maria))
    assert_no_difference("Category.count") do
      post categories_url, params: { category: { name: "Nueva categoria" } }
    end
    assert_redirected_to products_path
  end

  test "does not allow a non-admin to view the edit category form" do
    login(users(:maria))
    get edit_category_url(@category)
    assert_redirected_to products_path
  end

  test "does not allow a non-admin to update a category" do
    login(users(:maria))
    patch category_url(@category), params: { category: { name: "Hackeado" } }
    assert_redirected_to products_path
    assert_not_equal "Hackeado", @category.reload.name
  end

  test "does not allow a non-admin to destroy a category" do
    login(users(:maria))
    assert_no_difference("Category.count") do
      delete category_url(@category)
    end
    assert_redirected_to products_path
  end
end

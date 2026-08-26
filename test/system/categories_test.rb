require "application_system_test_case"

class CategoriesTest < ApplicationSystemTestCase
  setup do
    @category = categories(:clothes)
    login_as users(:paco)
  end

  test "visiting the index" do
    visit categories_url
    assert_selector "h1", text: "Categorias"
  end

  test "should create category" do
    visit new_category_url
    fill_in "Nombre", with: "Jardín"
    find("input[type=submit]").click

    assert_text "Tu categoria se ha creado correctamente"
  end

  test "should update Category" do
    visit edit_category_url(@category)
    fill_in "Nombre", with: "Ropa y calzado"
    find("input[type=submit]").click

    assert_text "Tu categoria se ha actualizado correctamente"
  end

  test "should destroy Category" do
    visit categories_url
    within "#category_#{@category.id}" do
      accept_confirm { click_on "Borrar" }
    end

    assert_text "Tu categoria se ha eliminado correctamente"
  end

  test "a non-admin cannot manage categories" do
    login_as users(:maria)
    visit categories_url

    assert_current_path products_path
    assert_text "No tienes permisos para esta accion"
  end

  private

  def login_as(user)
    visit new_session_path
    fill_in "login", with: user.email
    fill_in "password", with: "testme"
    find("input[type=submit]").click
    assert_text "Bienvenido!"
  end
end

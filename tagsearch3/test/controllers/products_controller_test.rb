require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, product: { tag1: @product.tag1, tag2: @product.tag2, tag3: @product.tag3, tag4: @product.tag4, tag5: @product.tag5, tag6: @product.tag6, tag7: @product.tag7, tag8: @product.tag8, tag9: @product.tag9, tag: @product.tag }
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, id: @product
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product
    assert_response :success
  end

  test "should update product" do
    patch :update, id: @product, product: { tag1: @product.tag1, tag2: @product.tag2, tag3: @product.tag3, tag4: @product.tag4, tag5: @product.tag5, tag6: @product.tag6, tag7: @product.tag7, tag8: @product.tag8, tag9: @product.tag9, tag: @product.tag }
    assert_redirected_to product_path(assigns(:product))
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, id: @product
    end

    assert_redirected_to products_path
  end
end

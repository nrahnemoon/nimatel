require 'test_helper'

class RetailersControllerTest < ActionController::TestCase
  setup do
    @retailer = retailers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:retailers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create retailer" do
    assert_difference('Retailer.count') do
      post :create, retailer: { address: @retailer.address, city: @retailer.city, contact: @retailer.contact, contact_title: @retailer.contact_title, country: @retailer.country, email: @retailer.email, fax_number: @retailer.fax_number, gender: @retailer.gender, has_calling_card: @retailer.has_calling_card, industry: @retailer.industry, name: @retailer.name, num_employees: @retailer.num_employees, phone_number: @retailer.phone_number, sales: @retailer.sales, sic: @retailer.sic, sic_description: @retailer.sic_description, state: @retailer.state, website: @retailer.website, zip: @retailer.zip }
    end

    assert_redirected_to retailer_path(assigns(:retailer))
  end

  test "should show retailer" do
    get :show, id: @retailer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @retailer
    assert_response :success
  end

  test "should update retailer" do
    put :update, id: @retailer, retailer: { address: @retailer.address, city: @retailer.city, contact: @retailer.contact, contact_title: @retailer.contact_title, country: @retailer.country, email: @retailer.email, fax_number: @retailer.fax_number, gender: @retailer.gender, has_calling_card: @retailer.has_calling_card, industry: @retailer.industry, name: @retailer.name, num_employees: @retailer.num_employees, phone_number: @retailer.phone_number, sales: @retailer.sales, sic: @retailer.sic, sic_description: @retailer.sic_description, state: @retailer.state, website: @retailer.website, zip: @retailer.zip }
    assert_redirected_to retailer_path(assigns(:retailer))
  end

  test "should destroy retailer" do
    assert_difference('Retailer.count', -1) do
      delete :destroy, id: @retailer
    end

    assert_redirected_to retailers_path
  end
end

require 'test_helper'

class FaucetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @faucet = faucets(:one)
  end

  test "should get index" do
    get faucets_url
    assert_response :success
  end

  test "should get new" do
    get new_faucet_url
    assert_response :success
  end

  test "should create faucet" do
    assert_difference('Faucet.count') do
      post faucets_url, params: { faucet: { frequency: @faucet.frequency, payment: @faucet.payment, reward: @faucet.reward, site_name: @faucet.site_name } }
    end

    assert_redirected_to faucet_url(Faucet.last)
  end

  test "should show faucet" do
    get faucet_url(@faucet)
    assert_response :success
  end

  test "should get edit" do
    get edit_faucet_url(@faucet)
    assert_response :success
  end

  test "should update faucet" do
    patch faucet_url(@faucet), params: { faucet: { frequency: @faucet.frequency, payment: @faucet.payment, reward: @faucet.reward, site_name: @faucet.site_name } }
    assert_redirected_to faucet_url(@faucet)
  end

  test "should destroy faucet" do
    assert_difference('Faucet.count', -1) do
      delete faucet_url(@faucet)
    end

    assert_redirected_to faucets_url
  end
end

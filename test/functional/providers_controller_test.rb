require 'test_helper'

class ProvidersControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Provider.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Provider.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Provider.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to provider_url(assigns(:provider))
  end

  def test_edit
    get :edit, :id => Provider.first
    assert_template 'edit'
  end

  def test_update_invalid
    Provider.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Provider.first
    assert_template 'edit'
  end

  def test_update_valid
    Provider.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Provider.first
    assert_redirected_to provider_url(assigns(:provider))
  end

  def test_destroy
    provider = Provider.first
    delete :destroy, :id => provider
    assert_redirected_to providers_url
    assert !Provider.exists?(provider.id)
  end
end

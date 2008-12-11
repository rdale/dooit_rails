require 'test_helper'

class VtodosControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:vtodos)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_vtodo
    assert_difference('Vtodo.count') do
      post :create, :vtodo => { }
    end

    assert_redirected_to vtodo_path(assigns(:vtodo))
  end

  def test_should_show_vtodo
    get :show, :id => vtodos(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => vtodos(:one).id
    assert_response :success
  end

  def test_should_update_vtodo
    put :update, :id => vtodos(:one).id, :vtodo => { }
    assert_redirected_to vtodo_path(assigns(:vtodo))
  end

  def test_should_destroy_vtodo
    assert_difference('Vtodo.count', -1) do
      delete :destroy, :id => vtodos(:one).id
    end

    assert_redirected_to vtodos_path
  end
end

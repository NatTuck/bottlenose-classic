require 'test_helper'

class BucketsControllerTest < ActionController::TestCase
  setup do
    @cs101  = create(:course, name: "Fundies 1")
    @bucket = create(:bucket, name: "Problem Sets", 
                              weight: 0.5, course_id: @cs101.id)
  end

  test "should get index" do
    get :index, {course_id: @cs101.id}
    assert_response :success
    assert_not_nil assigns(:buckets)
  end

  test "should get new" do
    get :new, {course_id: @cs101.id}
    assert_response :success
  end

  test "should create bucket" do
    assert_difference('Bucket.count') do
      post :create, course_id: @cs101, bucket: { 
        course_id: @bucket.course_id, 
        name: "Foos", 
        weight: @bucket.weight
      }
    end

    assert_redirected_to course_buckets_path(@cs101)
  end

  test "should show bucket" do
    get :show, course_id: @cs101, id: @bucket
    assert_response :success
  end

  test "should get edit" do
    get :edit, course_id: @cs101, id: @bucket
    assert_response :success
  end

  test "should update bucket" do
    patch :update, course_id: @cs101, 
                   id: @bucket, bucket: { 
      course_id: @bucket.course_id, 
      name: "Bars", 
      weight: 0.88 
    }

    assert_redirected_to course_buckets_path(@cs101)
  end

  test "should destroy bucket" do
    assert_difference('Bucket.count', -1) do
      delete :destroy, course_id: @cs101, id: @bucket
    end

    assert_redirected_to course_buckets_path(@cs101)
  end
end

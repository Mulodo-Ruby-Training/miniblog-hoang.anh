require 'test_helper'
# encoding: utf-8
module V1
  class PostTest < ActiveSupport::TestCase

   # funtion to test create a post successfully
    def test_create_post_successfully
      user_id = 28
      data = {
          title: "Chupa chups",
          content: "Gingerbread bear claw muffin danish danish marzipan. Toffee lollipop wafer carrot cake dessert.",
          description: "Chocolate tootsie roll lemon drops. Chupa chups chocolate bar apple pie",
          image: "chocolate.png",
          status: 1,
          user_id: user_id
      }
      post = V1::Post.insert_post(data)
      actual = post[:meta][:code]
      expected = 200
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    # funtion to test create a post unsuccessfully
    def test_create_post_unsuccessfully
      user_id = 28
      data = {
          title: "",
          content: "Gingerbread bear claw muffin danish danish marzipan. Toffee lollipop wafer carrot cake dessert.",
          description: "Chocolate tootsie roll lemon drops. Chupa chups chocolate bar apple pie",
          image: "chocolate.png",
          status: 1,
          user_id: user_id
      }
      post = V1::Post.insert_post(data)
      actual = post[:meta][:code]
      expected = 1001
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    # funtion to test update a post successfully
    def test_update_post_successfully
      post_id = 1
      data = {
          title: "Roll lemon",
          content: "Gingerbread bear claw muffin danish danish marzipan. Toffee lollipop wafer carrot cake dessert.",
          description: "Chocolate tootsie roll lemon drops. Chupa chups chocolate bar apple pie",
          image: "chocolate.png",
          status: 1
      }
      post = V1::Post.update_post(post_id,data)
      actual = post[:meta][:code]
      expected = 200
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    # funtion to test update a post unsuccessfully
    def test_update_post_unsuccessfully
      post_id = 1
      data = {
          title: "",
          content: "Gingerbread bear claw muffin danish danish marzipan. Toffee lollipop wafer carrot cake dessert.",
          description: "Chocolate tootsie roll lemon drops. Chupa chups chocolate bar apple pie",
          image: "chocolate.png",
          status: 1
      }
      post = V1::Post.update_post(post_id,data)
      actual = post[:meta][:code]
      expected = 1001
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    # funtion to test delete a post successfully
    def test_delete_post_successfully
      post_id = 1
      post = V1::Post.delete_post(post_id)
      actual = post[:meta][:code]
      expected = 200
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    # funtion to test delete a post unsuccessfully
    def test_delete_post_unsuccessfully
      post_id = 1
      post = V1::Post.delete_post(post_id)
      actual = post[:meta][:code]
      expected = 1001
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    #function to test change status a post successfully
    def test_active_or_deactive_post_successfully
      post_id = 1
      status = true
      post = V1::Post.active_or_deactive_post(post_id,status)
      actual = post[:meta][:code]
      expected = 200
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end
    
    #function to test change status a post unsuccessfully
    def test_active_or_deactive_post_unsuccessfully
      post_id = 1
      status = ""
      post = V1::Post.active_or_deactive_post(post_id,status)
      actual = post[:meta][:code]
      expected = 2503
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    private
      #function to show name of method which is excuted
      def this_method_name
          caller[0] =~ /`([^']*)'/ and $1
      end
  end
end
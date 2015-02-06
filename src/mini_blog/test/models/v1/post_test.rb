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

    private
      #function to show name of method which is excuted
      def this_method_name
          caller[0] =~ /`([^']*)'/ and $1
      end
  end
end
require 'test_helper'
module V1
  class CommentTest < ActiveSupport::TestCase

    #function to test creating comment successfully
    def test_function_create_comment_successfully
      data = {
        user_id: 28,
        post_id: 1,
        content: "This is a comment"
      }
      comment = V1::Comment.create_comment(data)
      actual = comment[:meta][:code]
      expected = 200
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    #function to test creating comment unsuccessfully
    def test_function_create_comment_unsuccessfully
      data = {
        user_id: "wrong_id",
        post_id: 1,
        content: "This is a comment"
      }
      comment = V1::Comment.create_comment(data)
      actual = comment[:meta][:code]
      expected = 1001
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    #function to test editing comment successfully
    def test_function_edit_comment_successfully
      comment_id = 1
      data = {
        user_id: 28,
        post_id: 2,
        content: "This is a comment (edit)"
      }
      comment = V1::Comment.edit_comment(comment_id,data)
      actual = comment[:meta][:code]
      expected = 200
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    #function to test editing comment unsuccessfully
    def test_function_edit_comment_unsuccessfully
      comment_id = 1
      data = {
        user_id: "wrong_id",
        post_id: "wrong_id",
        content: "This is a comment"
      }
      comment = V1::Comment.edit_comment(comment_id,data)
      actual = comment[:meta][:code]
      expected = 3005
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    #function to test deleting comment successfully
    def test_function_delete_comment_successfully
      comment_id = 1
      user_id = 28
      comment = V1::Comment.delete_comment(comment_id,user_id)
      actual = comment[:meta][:code]
      expected = 200
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    #function to test deleting comment unsuccessfully
    def test_function_delete_comment_unsuccessfully
      comment_id = "wrong_id"
      user_id = "wrong_id"
      comment = V1::Comment.delete_comment(comment_id,user_id)
      actual = comment[:meta][:code]
      expected = 3001
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    private
      #function to show name of method which is excuted
      def this_method_name
          caller[0] =~ /`([^']*)'/ and $1
      end

  end
end
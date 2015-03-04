module V1
  class CommentsControllerTest < ActionController::TestCase

    # function to test creating comment which happens successfully
    def test_create_successfully
      data = {
        user_id: 28,
        post_id: 1,
        content: "This is a comment"
      }
      expected = 200
      resp = Net::HTTP.post_form(URI.parse('http://localhost:3000/v1/comments'),data)
      actual = JSON.parse(resp.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s
    end

     # function to test creating comment which happens unsuccessfully
    def test_create_unsuccessfully
      data = {
        user_id: "wrong-id",
        post_id: 1,
        content: "This is a comment"
      }
      expected = 3002
      resp = Net::HTTP.post_form(URI.parse('http://localhost:3000/v1/comments'),data)
      actual = JSON.parse(resp.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s
    end

    # function to test editing comment which happens successfully
    def test_edit_successfully
      comment_id = 1
      data = {
        user_id: 28,
        post_id: 2,
        content: "This is a comment (edit)"
      }
      expected = 200
      resp = Net::HTTP.post_form(URI.parse('http://localhost:3000/v1/comments/#{comment_id}'),data)
      actual = JSON.parse(resp.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s
    end

    # function to test editing comment which happens unsuccessfully
    def test_edit_unsuccessfully
      comment_id = 1
      data = {
        user_id: "wrong-id",
        post_id: "wrong-id",
        content: "This is a comment (edit)"
      }
      expected = 200
      resp = Net::HTTP.post_form(URI.parse('http://localhost:3000/v1/comments/#{comment_id}'),data)
      actual = JSON.parse(resp.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s
    end

  end
end
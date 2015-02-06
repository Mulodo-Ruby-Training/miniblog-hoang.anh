module V1
  class PostsControllerTest < ActionController::TestCase
   # funtion to test create post
    def test_create_post
      data = {
          title: "Chupa chups",
          content: "Gingerbread bear claw muffin danish danish marzipan. Toffee lollipop wafer carrot cake dessert.",
          description: "Chocolate tootsie roll lemon drops. Chupa chups chocolate bar apple pie",
          image: "chocolate.png",
          status: 1
      }
      expected = 200
      resp = Net::HTTP.post_form(URI.parse('http://localhost:3000/v1/posts'),data)
      actual = JSON.parse(resp.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s
    end
  end
end
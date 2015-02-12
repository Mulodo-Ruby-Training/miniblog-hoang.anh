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

    # funtion to test update post
    def test_update_post
      data = {
          title: "Roll lemon",
          content: "Gingerbread bear claw muffin danish danish marzipan. Toffee lollipop wafer carrot cake dessert.",
          description: "Chocolate tootsie roll lemon drops. Chupa chups chocolate bar apple pie",
          image: "chocolate.png",
          status: 1
      }
      expected = 200
      post_id = 1
      uri = URI.parse('http://localhost:3000/v1/posts/'+post_id.to_s)
      http = Net::HTTP.new(uri.host,uri.port)
      request = Net::HTTP::Put.new(uri.path)
      request.set_form_data(data)
      response = http.request(request)
      actual = JSON.parse(response.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s
    end

    # funtion to test delete post
    def test_delete_post
      expected = 200
      post_id = 1
      uri = URI.parse('http://localhost:3000/v1/posts/'+post_id.to_s)
      http = Net::HTTP.new(uri.host,uri.port)
      request = Net::HTTP::Delete.new(uri.path)
      request.set_form_data(data)
      response = http.request(request)
      actual = JSON.parse(response.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s
    end

    def test_change_status
      expected = 200
      post_id = 1
      data = {
        status: 1
      }
      uri = URI.parse('http://localhost:3000/v1/posts/'+post_id.to_s+'/status')
      http = Net::HTTP.new(uri.host,uri.port)
      request = Net::HTTP::Put.new(uri.path)
      request.set_form_data(data)
      response = http.request(request)
      actual = JSON.parse(response.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s
    end

    private
      #function to show name of method which is excuted
      def this_method_name
          caller[0] =~ /`([^']*)'/ and $1
      end

  end
end
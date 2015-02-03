module V1
  class UsersControllerTest < ActionController::TestCase
   # funtion to test create user account when it's successful
    def test_create_user_successful
      data = {
        username: "viet-anh-mulodo",
        password: "hoangvietanh91",
        password_confirmation: "hoangvietanh91",
        firstname: "Anh",
        lastname: "Hoang",
        avatar: "avatar.png",
        address: "111D Ly Chinh Thang",
        city: "Ho Chi Minh",
        email: "viet.anh@mulodo.sl",
        mobile: "0309433343545",
        gender: 1,
        birthday: "1991/10/10"
      }
      expected = 200
      resp = Net::HTTP.post_form(URI.parse('http://localhost:3000/v1/users'),data)
      actual = JSON.parse(resp.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s
    end

    # funtion to test create user account when it's unsuccessful
    def test_create_user_unsuccessful
      data = {
        username: "",
        password: "hoangvietanh91",
        password_confirmation: "hoangvietanh91",
        firstname: "Anh",
        lastname: "Hoang",
        avatar: "avatar.png",
        address: "111D Ly Chinh Thang",
        city: "Ho Chi Minh",
        email: "viet.anh@mulodo.sl",
        mobile: "0309433343545",
        gender: 1,
        birthday: "1991/10/10"
      }
      expected = 1001
      resp = Net::HTTP.post_form(URI.parse('http://localhost:3000/v1/users'),data)
      actual = JSON.parse(resp.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s
    end

     # funtion to test login function when it's successful
    def test_login_successful
      data = {
        username:"viet-anh-mulodo",
        password: "hoangvietanh91"
      }
      expected = 200
      resp = Net::HTTP.post_form(URI.parse('http://localhost:3000/v1/users/login'),data)
      actual = JSON.parse(resp.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s
    end

     # funtion to test login function when it's unsuccessful
    def test_login_unsuccessful
      data = {
        username:"viet-anh-mulodo",
        password: "wrong-password"
      }
      expected = 1003
      resp = Net::HTTP.post_form(URI.parse('http://localhost:3000/v1/users/login'),data)
      actual = JSON.parse(resp.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s
    end

    # funtion to test update user function when it's successful
    def test_update_successful
     data = {
        firstname: "Anh",
        lastname: "Hoang",
        avatar: "avatar.png",
        address: "111D Ly Chinh Thang",
        city: "Ho Chi Minh",
        email: "anh@gmallds.sl",
        mobile: "0309433343545",
        gender: 1,
        birthday: "1991/10/10"
      }

      user_id = 28
      expected = 200
      uri = URI.parse('http://localhost:3000/v1/users/'+user_id.to_s)

      http = Net::HTTP.new(uri.host,uri.port)
      request = Net::HTTP::Put.new(uri.path)
      request.set_form_data(data)
      response = http.request(request)
      actual = JSON.parse(response.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s
    end

    # funtion to test update user function when it's unsuccessful
    def test_update_unsuccessful
     data = {
        firstname: "",
        lastname: "Hoang",
        avatar: "avatar.png",
        address: "111D Ly Chinh Thang",
        city: "Ho Chi Minh",
        email: "anh@gmallds.sl",
        mobile: "0309433343545",
        gender: 1,
        birthday: "1991/10/10"
      }

      user_id = 28
      expected = 1002
      uri = URI.parse('http://localhost:3000/v1/users/'+user_id.to_s)

      http = Net::HTTP.new(uri.host,uri.port)
      request = Net::HTTP::Put.new(uri.path)
      request.set_form_data(data)
      response = http.request(request)
      actual = JSON.parse(response.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s
    end

    def test_logout_successful
      # data = nil
      user_id = 28
      expected = 200
      resp = Net::HTTP.post_form(URI.parse('http://localhost:3000/v1/users/logout'),{id:user_id})
      actual = JSON.parse(resp.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s   
    end

    def test_logout_unsuccessful
      # data = nil
      user_id = "wrong-password"
      expected = 1005
      resp = Net::HTTP.post_form(URI.parse('http://localhost:3000/v1/users/logout'),{id:user_id})
      actual = JSON.parse(resp.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s   
    end

    # funtion to test change user password function when it's successful
    def test_change_password_successful
      data = {
        current_password: "1234567890",
        password: "new-password",
        password_confirmation: "new-password"
      }

      user_id = 34
      expected = 200
      uri = URI.parse('http://localhost:3000/v1/users/'+user_id.to_s+'/password')

      http = Net::HTTP.new(uri.host,uri.port)
      request = Net::HTTP::Put.new(uri.path)
      request.set_form_data(data)
      response = http.request(request)
      actual = JSON.parse(response.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s
    end

    # funtion to test change user password function when it's unsuccessful
    def test_change_password_unsuccessful
      data = {
        current_password: "1234567890",
        password: "new-password",
        password_confirmation: "newer-password"
      }

      user_id = 34
      expected = 1001
      uri = URI.parse('http://localhost:3000/v1/users/'+user_id.to_s+'/password')

      http = Net::HTTP.new(uri.host,uri.port)
      request = Net::HTTP::Put.new(uri.path)
      request.set_form_data(data)
      response = http.request(request)
      actual = JSON.parse(response.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s
    end

    # funtion to test get user info function when it's successful
    def test_show_user_info_successful
      user_id = 34
      expected = 200
      response = Net::HTTP.get(URI.parse('http://localhost:3000/v1/users/'+user_id))
      actual = JSON.parse(response.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s
    end

    # funtion to test get user info function when it's unsuccessful
    def test_show_user_info_unsuccessful
      user_id = "wrong-id"
      expected = 2004
      response = Net::HTTP.get(URI.parse('http://localhost:3000/v1/users/'+user_id))
      actual = JSON.parse(response.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s
    end

    # funtion to test search user function when it's successful
    def test_search_user_successful
      keyword = "anh"
      expected = 200
      response = Net::HTTP.get(URI.parse('http://localhost:3000/v1/users/search/'+keyword))
      actual = JSON.parse(response.body)
      result = assert_equal(expected,actual['meta']['code'])
      puts this_method_name + " - " + result.to_s
    end

    # funtion to test search user function when it's unsuccessful
    def test_search_user_unsuccessful
      keyword = ""
      expected = 1001
      response = Net::HTTP.get(URI.parse('http://localhost:3000/v1/users/search/'+keyword))
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
require 'test_helper'
module V1
  class UserTest < ActiveSupport::TestCase

   # funtion to test create user account
    def test_create_user
      data = {
        username: "hoang.anh",
        password: "hoangvietanh91",
        password_confirmation: "hoangvietanh91",
        firstname: "Anh",
        lastname: "Hoang",
        avatar: "avatar.png",
        address: "111D Ly Chinh Thang",
        city: "Ho Chi Minh",
        email: "sdeqvvfq@gmallds.sl",
        mobile: "0309433343545",
        gender: 1,
        birthday: "1991/10/10"
      }
      user = V1::User.new(data)
      actual = user.save
      expected = true
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    # function to validate that user input 
    def test_validate_user_info
      data = {
        username: "",
        password: "hoangvietanh91",
        password_confirmation: "hoangvietanh",
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
      #Call function insert_user in model V1::User
      user = V1::User.insert_user(data)

      #Get value code which is returned when call function insert_user
      actual = user[:meta][:code]

      expected = 1001
      #Show result of this function(true=>pass)
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    #function to test checking username && password existed or not
    def test_function_check_username_and_password_existed
      username = "viet-anh-mulodo"
      password = "hoangvietanh91"
      actual = V1::User.check_username_and_password_existed(username,password)
      expected = true
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    #function to test login successfully function
    def test_function_login_successfully
      username = "viet-anh-mulodo"
      password = "hoangvietanh91"
      result = V1::User.login(username,password)
      actual = result[:meta][:code]
      expected = 200
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    #function to test login unsuccessfully function
    def test_function_login_unsuccessfully
      username = "viet-anh-mulodo"
      password = "abc"
      result = V1::User.login(username,password)
      actual = result[:meta][:code]
      expected = 1003
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    #function to test update user's info successfully
    def test_function_update_user_successfully
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
      #Call function insert_user in model V1::User
      user = V1::User.update_user(user_id,data)

      #Get value code which is returned when call function insert_user
      actual = user[:meta][:code]

      expected = 200
      #Show result of this function(true=>pass)
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    #function to test update user's info unsuccessfully
    def test_function_update_user_unsuccessfully
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
      #Call function insert_user in model V1::User
      user = V1::User.update_user(user_id,data)

      #Get value code which is returned when call function insert_user
      actual = user[:meta][:code]

      expected = 1001
      #Show result of this function(true=>pass)
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    #function to test update token successfully
    def test_function_update_token_successfully
      user_id = 28
      #Get value boolean which is returned when call function update_token
      actual = V1::User.update_token(user_id)

      expected = true
      #Show result of this function(true=>pass)
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    #function to test update token unsuccessfully
    def test_function_update_token_unsuccessfully
      user_id = "wrong-id"
      #Get value boolean which is returned when call function update_token
      actual = V1::User.update_token(user_id)

      expected = false
      #Show result of this function(true=>pass)
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    #function to test change user password successfully
    def test_function_change_user_password_successfully
      data = {
        current_password: "1234567890",
        password: "new-password",
        password_confirmation: "new-password"
      }
      user_id = 28
      #Call function change_user_password in model V1::User
      user = V1::User.change_user_password(user_id,data)

      #Get value code which is returned when call function change_user_password
      actual = user[:meta][:code]

      expected = 200
      #Show result of this function(true=>pass)
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    #function to test change user password unsuccessfully
    def test_function_change_user_password_unsuccessfully
      data = {
        current_password: "1234567890",
        password: "new-password",
        password_confirmation: "newer-password"
      }
      user_id = 28
      #Call function change_user_password in model V1::User
      user = V1::User.change_user_password(user_id,data)

      #Get value code which is returned when call function change_user_password
      actual = user[:meta][:code]

      expected = 1001
      #Show result of this function(true=>pass)
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    #function to test get user info successfully
    def test_function_get_user_info_successfully
      user_id = 28

      #Call function get_user_info in model V1::User
      user = V1::User.get_user_info(user_id)

      #Get value code which is returned when call function get_user_info
      actual = user[:meta][:code]

      expected = 200
      #Show result of this function(true=>pass)
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    #function to test get user info unsuccessfully
    def test_function_get_user_info_unsuccessfully
      user_id = 28

      #Call function get_user_info in model V1::User
      user = V1::User.get_user_info(user_id)

      #Get value code which is returned when call function get_user_info
      actual = user[:meta][:code]

      expected = 2004
      #Show result of this function(true=>pass)
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    #function to test search user info successfully
    def test_function_search_user_successfully
      keyword = "anh"

      #Call function search_user_by_name in model V1::User
      user = V1::User.search_user_by_name(keyword)

      #Get value code which is returned when call function search_user_by_name
      actual = user[:meta][:code]

      expected = 200
      #Show result of this function(true=>pass)
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    #function to test search user info unsuccessfully
    def test_function_search_user_unsuccessfully
      keyword = ""

      #Call function search_user_by_name in model V1::User
      user = V1::User.search_user_by_name(keyword)

      #Get value code which is returned when call function search_user_by_name
      actual = user[:meta][:code]

      expected = 1001
      #Show result of this function(true=>pass)
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    #function to test get all post of user successfully
    def test_function_get_all_post_user_successfully

      posts = V1::User.get_all_post_user

      actual = posts[:meta][:code]

      expected = 200
      
      #Show result of this function(true=>pass)
      puts this_method_name + " - " +assert_equal(expected, actual).to_s
    end

    private
      #function to show name of method which is excuted
      def this_method_name
          caller[0] =~ /`([^']*)'/ and $1
      end

  end
end

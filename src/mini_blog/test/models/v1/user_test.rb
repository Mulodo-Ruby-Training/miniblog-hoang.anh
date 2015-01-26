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

    private
      #function to show name of method which is excuted
      def this_method_name
          caller[0] =~ /`([^']*)'/ and $1
      end

  end
end

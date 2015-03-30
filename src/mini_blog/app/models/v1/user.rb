require 'date'
require "digest"
require 'carrierwave/orm/activerecord'
module V1
  class User < ActiveRecord::Base
    #Relationship to posts and comments
    has_many :post, dependent: :destroy
    has_many :comment, dependent: :destroy

    #Encrypt password(using salt & hash) before info of user is saved
    before_create :encrypt_password
    search_syntax do
      search_by :text do |scope, phrases|
        columns = [:firstname, :lastname, :username]
        scope.where_like(columns => phrases)
      end
    end

    mount_uploader :avatar, ImageUploader

    #validate values not allow null
    validates_presence_of :username
    validates_presence_of :password
    validates_presence_of :firstname
    validates_presence_of :lastname
    validates_presence_of :gender
    validates_presence_of :email

    #validate min & max length of values
    validates :username, length: {minimum: 3}
    validates :password, length: {minimum: 6}

    #validate retype password & new password match password
    validates :password, confirmation: true

    #validate only exist one value
    validates :username, :email, uniqueness: true

    #validate format of email
    validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

    #validate format of birthday
    validate :check_birthday_valid

    #function to insert user info into DB
    def self.insert_user(data)
      user = self.new(data)
      #check saving user is successfull(fail=>null)
      if((user.save rescue nil))
        self.return_result({code: STATUS_OK, description:"Account is created successfully",
          messages:"Successful",data: nil})
      else
        self.return_result({code: ERROR_VALIDATE, description:MSG_VALIDATE,
          messages:user.errors,data:nil})
      end
    end

    #function to user can login to their account
    def self.login(username,password)
      #check username && password existed
      if self.check_username_and_password_existed(username,password)
        #Create token
        str = @get_user_by_username[0][:id].to_s+@get_user_by_username[0][:username]+DateTime.parse(Time.now.to_s).to_s
        str_token = Digest::MD5.hexdigest str

        #Update token
        get_user_by_id = self.find(@get_user_by_username[0][:id])
        get_user_by_id[:token] = str_token
        if(get_user_by_id.save rescue nil)
          data = {
            id: get_user_by_id[:id],
            token: get_user_by_id[:token],
            username: get_user_by_id[:username],
            firstname: get_user_by_id[:firstname],
            lastname: get_user_by_id[:lastname],
            avatar: get_user_by_id[:avatar]
          }
          self.return_result({code:STATUS_OK, description:"Login successfully",
          messages:"Successful",data:data})
        else
          self.return_result({code:ERROR_UPDATE_TOKEN, description:MSG_UPDATE_TOKEN,
          messages:"Update token failed",data:nil})
        end 
      else
        self.return_result({code:ERROR_LOGIN_FAILED, description:MSG_LOGIN_FAILED,
          messages:"Unsuccessful",data:nil})
      end
    end

    #function to update user' s info
    def self.update_user(user_id,data)
      user = self.find(user_id)
      if(user.update(data) rescue nil)
        return_result({code:STATUS_OK,description:"Update user info successfully",
          messages:"Successful",data:nil})
      else
        return_result({code:ERROR_VALIDATE,description:MSG_VALIDATE,
          messages:user.errors,data:nil})
      end
    end

    #function to update token to nil
    def self.update_token(user_id)
      user = self.find(user_id) rescue nil
      if user
        user.token = ""
        if(user.save rescue nil)
          return true
        else
          return false
        end
      else
        return false
      end
    end

    #function to user can change their password
    def self.change_user_password(user_id,data)
      user = (self.find(user_id) rescue nil)

      #Check current password
      if user && user.password == BCrypt::Engine.hash_secret(data[:current_password],user.salt_password)

        #Create new salt password
        salt_password = BCrypt::Engine.generate_salt

        #Create new password
        if data[:password] != "" #check new password is null
          if data[:password].length >=6 #check length of new password >=6 
            password = BCrypt::Engine.hash_secret(data[:password],salt_password)
          else
            password = data[:password]
          end
        else
          password = ""
        end

        #Create new password confirmation
        if data[:password_confirmation] != "" #check new password confirmation is null
          if data[:password_confirmation].length >=6 #check length of new password confirmation >=6
            retype_password = BCrypt::Engine.hash_secret(data[:password_confirmation],salt_password)
          else
            retype_password = data[:password_confirmation]
          end
        else
          retype_password = ""
        end

        data = {
          salt_password: salt_password,
          password: password,
          password_confirmation: retype_password
        }

        #Update new password
        if((user.update(data) rescue nil))
          return return_result({code:STATUS_OK,description:"Change password successfully",
          messages:"Successful",data:nil})
        else
          return return_result({code:ERROR_VALIDATE,description:MSG_VALIDATE,
          messages:user.errors,data:nil})
        end
      else
        return return_result({code:ERROR_PASSWORD_INCORRECT,description:MSG_PASSWORD_INCORRECT,
          messages:"Unsuccessful",data:nil})
      end      
    end

    #function to get a user's info
    def self.get_user_info(user_id)
      user = (self.find(user_id) rescue nil)
      if user
        data = {
          id: user.id,
          username:user.username,
          firstname:user.firstname,
          lastname:user.lastname,
          avatar:user.avatar,
          birthday:user.birthday,
          gender:user.gender,
          email:user.email,
          address:user.address,
          city:user.city,
          mobile:user.mobile,
          created_at:user.created_at,
          updated_at:user.updated_at
        }
        return_result({code:STATUS_OK,description:"Get user info successfully",
          messages:"Successful",data:data})
      else
        return_result({code:ERROR_GET_USER,description:MSG_GET_USER,
          messages:"Unsuccessful",data:nil})
      end
    end

    #function to get all user by keyword
    def self.search_user_by_name(keyword,page,per_page)
      if !(page.present?)
        page = 1
      end
      if !(per_page.present?)
        per_page = 2
      end
      if keyword.present?
        users = User.search(keyword).page(page).per(per_page)
        data = []
        for user in users
          temp_data = {id: user.id, username: user.username, firstname: user.firstname,
            lastname: user.lastname, avatar: user.avatar}
          data << temp_data
        end
        return_result({code:STATUS_OK,description:"Get user info successfully",
          messages:"Successful",data:data})
      else
        # return_result({code:ERROR_VALIDATE,description:MSG_VALIDATE,
        #   messages:"Keyword is blank",data:nil})
        users = User.page(page).per(per_page)
        data = []
        for user in users
          temp_data = {id: user.id, username: user.username, firstname: user.firstname,
            lastname: user.lastname, avatar: user.avatar}
          data << temp_data
        end
        return_result({code:STATUS_OK,description:"Get user info successfully",
          messages:"Successful",data:data}) 
      end
    end

    #function to check user logined in or not(true=>logined)
    def self.check_login(session_id,session_token)
      #check session id & session token existed
      if session_id && session_token
        user = self.find(session_id)
        #check session token match token from DB(true=>match)
        if user && user.token == session_token
          return true
        else
          return false
        end
      else
        return false
      end    
    end

    #function to return hash result
    def self.return_result(options)
      return {
        meta:{
          code: options[:code],
          description: options[:description],
          messages: options[:messages]
          },
          data: options[:data]
      }
    end

    # function to get all posts of a user
    def self.get_all_post_user(user_id)
      posts = (V1::Post.where("user_id = #{user_id}") rescue nil)
      if posts
        return_result({code:STATUS_OK,description:"Get all post successfully",
          messages:"Successful",data:posts})
      else
        return_result({code:ERROR_GET_ALL_POST_USER_FAILED,description:MSG_GET_ALL_POST_USER_FAILED,
          messages:"Unsuccessful",data:nil})
      end
    end

    # function to get all comments of a user
    def self.get_all_comments_user(user_id)
      comments = (V1::Comment.where("user_id = #{user_id}") rescue nil)
      if comments
        return_result({code:STATUS_OK,description:"Get all comments successfully",
          messages:"Successful",data:comments})
      else
        return_result({code:ERROR_GET_ALL_COMMENT_USER_ERROR,description:MSG_GET_ALL_COMMENT_USER_ERROR,
          messages:"Unsuccessful",data:nil})
      end
    end

    private
    #function to check birthday is day type(using for validate) 
    def check_birthday_valid
      if((Date.parse(birthday.to_s) rescue ArgumentError) == ArgumentError)
        errors.add(:birthday, 'must be a valid day')
      end
    end

    #fucntion to encrypt password before saving
    def encrypt_password
      if password.present?
        #create salt password
        self.salt_password = BCrypt::Engine.generate_salt
        #create hash password
        self.password = BCrypt::Engine.hash_secret(password,salt_password)
      end
    end

    #function to check username && password existed (true=>existed)
    def self.check_username_and_password_existed(username,password)
      @get_user_by_username = self.where(username: username).limit(1)
      if @get_user_by_username.count() > 0 && 
      @get_user_by_username[0][:password] == BCrypt::Engine.hash_secret(password,@get_user_by_username[0][:salt_password])
        return true
      else
        return false
      end
    end

  end
end

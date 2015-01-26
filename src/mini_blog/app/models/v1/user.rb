require 'date'
require "digest"
module V1
  class User < ActiveRecord::Base
    # attr_accessor :password
    #Encrypt password(using salt & hash) before info of user is saved
    before_create :encrypt_password, :on => :create

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

    #validate retype password match password
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
        data = {
          id: user.id,
          username: user.username,
          firstname: user.firstname,
          lastname: user.lastname
        }
        self.return_result({code: 200, description:"Account is created successfully",
          messages:"Successful",data: data})
      else
        self.return_result({code: 1001, description:"Account is created unsuccessfully",
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
          self.return_result({code:200, description:"Login successfully",
          messages:"Successful",data:data})
        else
          self.return_result({code:1005, description:"Update token failed",
          messages:"Update token failed",data:nil})
        end 
      else
        self.return_result({code:1003, description:"User or password incorrect",
          messages:"Unsuccessful",data:nil})
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

    private
    #function to check birthday is day type(using for validate) 
    def check_birthday_valid
      if((Date.parse(birthday.to_s) rescue ArgumentError) == ArgumentError)
        errors.add(:birthday, 'must be a valid day')
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

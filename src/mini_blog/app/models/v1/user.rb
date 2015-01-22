require 'date'
module V1
  class User < ActiveRecord::Base
    # attr_accessor :password
    #Encrypt password(using salt & hash) before info of user is saved
    before_save :encrypt_password

    #validate values not allow null
    validates :username, :password, :password_confirmation,
    :firstname, :lastname, :gender, :email, presence: true

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
  end
end

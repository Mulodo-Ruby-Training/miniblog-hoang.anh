require 'date'
module V1
	class User < ActiveRecord::Base
		# attr_accessor :password
		before_save :encrypt_password

		validates :username, :password, :password_confirmation,
		:firstname, :lastname, :gender, :email, presence: true

		validates :username, length: {minimum: 3}
		validates :password, length: {minimum: 6}

		validates :password, confirmation: true

		validates :username, :email, uniqueness: true

		validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

		validate :check_birthday_valid

		def self.insert_user(data)
			user = self.new(data)
			if((user.save rescue nil))
				self.return_result({code: 200, description:"Account is created successfully",
					messages:"Successful",data: nil})
			else
				self.return_result({code: 1001, description:"Account is created unsuccessfully",
					messages:user.errors,data:nil})
			end
		end

		private
		def check_birthday_valid
			if((Date.parse(birthday.to_s) rescue ArgumentError) == ArgumentError)
				errors.add(:birthday, 'must be a valid day')
			end
		end

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

		def encrypt_password
			if password.present?
				self.salt_password = BCrypt::Engine.generate_salt
				self.password = BCrypt::Engine.hash_secret(password,salt_password)
			end
		end
	end
end

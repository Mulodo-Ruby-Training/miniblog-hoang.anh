class User
	extend CarrierWave::Mount
	mount_uploader :image, ImageUploader

	def save
		self.store_image!
	end

	def self.upload(file)
		u = User.new
		u.image = file
		if(u.save rescue nil)
			return u.image.url
		else
			return false
		end
	end
end
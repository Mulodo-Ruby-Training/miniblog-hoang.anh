module V1
  class Post < ActiveRecord::Base
    #Relationship to users and comments
    has_many :comment, dependent: :destroy
    belongs_to :user

    validates_presence_of :title
    validates_presence_of :content
    validates_presence_of :user_id
    validates_presence_of :status

    # function to insert post into database
    def self.insert_post(data)
      post = self.new(data)
      if(post.save rescue nil)
        V1::User.return_result({code: 200, description:"Post is created successfully",
            messages:"Successful",data: nil})
      else
        V1::User.return_result({code: 1001, description:"Post is created unsuccessfully",
            messages:post.errors,data: nil})
      end
    end

  end
end

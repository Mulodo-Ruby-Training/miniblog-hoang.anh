class Comment < ActiveRecord::Base
  #Relationship to posts and users
  belongs_to :user
  belongs_to :post
end

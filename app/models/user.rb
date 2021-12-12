class User < ActiveRecord::Base 

    has_many :finstagram_posts
    has_many :comments
    has_many :likes

    # using active records to validate information
    validates :email, :username, uniqueness: true
    validates :email, :avatar_url, :username, :password, presence: true

end
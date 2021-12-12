class FinstagramPost < ActiveRecord::Base

    belongs_to :user
    has_many :comments
    has_many :likes

    validates_presence_of :user
    
    validates :photo_url, :user, presence:true

    def humanized_time_ago
        time_ago_in_seconds = Time.now - self.created_at
        time_ago_in_minutes = time_ago_in_seconds / 60
        
        #condition if post is days old
        if time_ago_in_minutes >= 1440
            "#{(time_ago_in_minutes / (24*60)).to_i } days ago"
        #condition if post is days old and hours old
        elsif time_ago_in_minutes >= 60 && time_ago_in_minutes < 1440
            "#{time_ago_in_minutes.to_i / 60} hour ago"
        # condition if post is quite recent
        elsif time_ago_in_minutes < 60 && time_ago_in_minutes > 1 
            "#{time_ago_in_minutes.to_i} minute ago"
        else
            "#{(time_ago_in_minutes * 60)} seconds ago"
        end
    end

    # adding a comment counter
    def comment_count
        self.comments.size
    end

    #adding a like counter
    def like_count
        self.likes.size
    end

end
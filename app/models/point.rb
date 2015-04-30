class Point < ActiveRecord::Base
	has_many :counterpoints, class_name: "Point",
													 foreign_key: "counterpoint_to_id"
  belongs_to :user
	default_scope -> { order('created_at DESC') }
	mount_uploader :picture, PictureUploader
	validates :user_id, presence: true
	validates :content, presence: true, length: { maximum: 3000 }
	validate	:picture_size

	def Point.from_users_followed_by(user)
		following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
		where("user_id IN (#{following_ids}) OR user_id = :user_id", following_ids: following_ids, user_id: user)
	end

	private

		def picture_size
			if picture.size > 5.megabytes
				errors.add(:picture, "should be less than 5MB")
			end
		end
end

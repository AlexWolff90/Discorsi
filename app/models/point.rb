class Point < ActiveRecord::Base
	has_many :counterpoints, class_name: "Point",
													 foreign_key: "counterpoint_to_id"
  belongs_to :user
	has_many :votes, dependent: :destroy
	default_scope -> { order('created_at DESC') }
	mount_uploader :picture, PictureUploader
	validates :user_id, presence: true
	validates :counterpoint_to_id, uniqueness: { scope: :user_id, message: "You cannot post two counterpoints to the same point" }, unless: "counterpoint_to_id.nil?"
	validates :content, presence: true, length: { maximum: 3000 }
	validate	:point_counterpoint_different_user
	validate	:picture_size

	def Point.from_users_followed_by(user)
		following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
		where("user_id IN (#{following_ids}) OR user_id = :user_id", following_ids: following_ids, user_id: user)
	end

	def user
		User.find(user_id)
	end

	def countered_user
		User.find(Point.find(counterpoint_to_id).user_id)
	end

	def vote(user,type)
		vote = votes.build(user: user, vote_type: type)
		vote.save if vote.valid?
	end

	def upvote(user)
		vote = votes.build(user: user, vote_type: 'upvote')
		vote.save if vote.valid?
	end

	def downvote(user)
		vote = votes.build(user: user, vote_type: 'downvote')
		vote.save if vote.valid?
	end

	def upvoted_by?(user)
		vote = Vote.where(point_id: id, user_id: user.id).first
		vote.vote_type == 'upvote' unless vote.nil?
	end

	def downvoted_by?(user)
		vote = Vote.where(point_id: id, user_id: user.id).first
		vote.vote_type == 'downvote' unless vote.nil?
	end

	def unvote(user)
		vote = Vote.where(point_id: id, user_id: user.id).first
		vote.destroy if !vote.nil?
	end

	def unupvote(user)
		vote = Vote.where(point_id: id, user_id: user.id).first
		vote.destroy if !vote.nil? && vote.vote_type == 'upvote'
	end
		
	def undownvote(user)
		vote = Vote.where(point_id: id, user_id: user.id).first
		vote.destroy if !vote.nil? && vote.vote_type == 'downvote'
	end

	def upvote_count
		Vote.where(point_id: id, vote_type: 'upvote').count
	end

	def downvote_count
		Vote.where(point_id: id, vote_type: 'downvote').count
	end

	private

		def point_counterpoint_different_user
			if !counterpoint_to_id.nil? && user_id == Point.find(counterpoint_to_id).user_id
				errors.add(:user_id, "counterpoint should not be by the same user as the point")
			end
		end

		def picture_size
			if picture.size > 5.megabytes
				errors.add(:picture, "should be less than 5MB")
			end
		end
end

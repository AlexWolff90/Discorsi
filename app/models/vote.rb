class Vote < ActiveRecord::Base
	belongs_to :user
	belongs_to :point
	validates :user_id, uniqueness: { scope: :point_id }, presence: true
	validates :vote_type, presence: true
	validates :point_id, presence: true
	validate :vote_type_valid

	@@valid_vote_types = ['upvote', 'downvote']

	private

		def vote_type_valid
			valid_vote = false
			@@valid_vote_types.each do |valid_type|
				valid_vote |= (vote_type == valid_type)
			end
			unless valid_vote
				errors.add(:vote_type, "vote must be of a valid type")
			end
		end
end

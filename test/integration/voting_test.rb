require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:alex)
		@point = points(:ants)
		log_in_as(@user)
	end

	test "point page with upvote count" do
		get point_path(@point)
		assert_match @point.votes.count.to_s, response.body
	end

	test "should upvote a point" do
		assert_difference "@point.votes.count", 1 do
			post votes_path, point_id: @point.id, vote_type: 'upvote'
		end
		@point.unvote(@user)
		assert_difference "@point.votes.count", 1 do
			xhr :post, votes_path, point_id: @point.id, vote_type: 'upvote'
		end
	end

	test "should unvote a point" do
		@point.upvote(@user)
		vote = @point.votes.find_by(user_id: @user.id)
		assert_difference '@point.votes.count', -1 do
			delete vote_path(vote), vote: vote.id
		end
		@point.upvote(@user)
		vote = @point.votes.find_by(user_id: @user.id)
		assert_difference '@point.votes.count', -1 do
			xhr :delete, vote_path(vote), vote: vote.id
		end
	end
end

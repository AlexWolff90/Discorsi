require 'test_helper'

class VoteTest < ActiveSupport::TestCase

	def setup
		@point = points(:ants)
		@user = users(:alex)
	end

	test "should not be able to vote twice" do
		vote = @point.votes.build(user: @user, vote_type: 'upvote')
		vote.save
		vote2 = @point.votes.build(user: @user, vote_type: 'upvote')
		assert_not vote2.valid?
	end

	test "should require all collumns to be filled" do
		vote = @point.votes.build(user: @user)
		assert_not vote.valid?
		vote = @point.votes.build(vote_type: 'upvote')
		assert_not vote.valid?
		vote = @user.votes.build(vote_type: 'downvote')
		assert_not vote.valid?
	end

	test "vote should be of valid type" do
		vote = @point.votes.build(user: @user, vote_type: 'upvote')
		assert vote.valid?
		vote = @point.votes.build(user: @user, vote_type: 'downvote')
		assert vote.valid?
		vote = @point.votes.build(user: @user, vote_type: 'badvote')
		assert_not vote.valid?
	end
end

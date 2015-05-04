require 'test_helper'

class PointTest < ActiveSupport::TestCase
	
	def setup
		@user = users(:alex)
		@point = @user.points.build(content: "Lorem ipsum")
		@point2 = @user.points.build(content: "Lorem ipsum")
		@archer_point = points(:zone)
	end

	test "point should be valid" do
		assert @point.valid?
	end

	test "user id should be present" do
		@point.user_id = nil
		assert_not @point.valid?
	end

	test "content should be present" do
		@point.content = " "
		assert_not @point.valid?
	end

	test "content should be at most 3000 characters" do
		@point.content = "a" * 3001
		assert_not @point.valid?
	end

	test "order should be most recent first" do
		assert_equal Point.first, points(:most_recent)
	end

	test "point and counterpoint should not have the same user" do
		# Invalid if same user
		@point.save
		@point2.counterpoint_to_id = @point.id
		assert_not @point2.valid?
		# Valid if different user
		@archer_point.counterpoint_to_id = @point.id
		assert @archer_point.valid?
	end

	test "user should not be able to post two counterpoints to the same point" do
		@point.counterpoint_to_id = @archer_point.id
		@point.save
		@point2.counterpoint_to_id = @archer_point.id
		assert_not @point2.valid?
	end
end

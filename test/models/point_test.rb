require 'test_helper'

class PointTest < ActiveSupport::TestCase
	
	def setup
		@user = users(:alex)
		@point = @user.points.build(content: "Lorem ipsum")
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
end

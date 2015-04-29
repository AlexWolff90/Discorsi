require 'test_helper'

class PointsInterfaceTest < ActionDispatch::IntegrationTest
	
	def setup
		@user = users(:alex)
	end

	test "point interface" do
		log_in_as(@user)
		get root_path
		assert_select 'div.pagination'
		# Invalid submission
		post points_path, point: { content: "" }
		assert_select 'div#error_explanation'
		# Valid submission
		content = "This point really ties the room together"
		assert_difference 'Point.count', 1 do
			post points_path, point: { content: content }
		end
		follow_redirect!
		assert_match content, response.body
		# Delete a post
		assert_select 'a', 'delete'
		first_point = @user.points.paginate(page: 1).first
		assert_difference 'Point.count', -1 do
			delete point_path(first_point)
		end
		# Visit a different user.
		get user_path(users(:archer))
		assert_select 'a', { text: 'delete', count: 0 }
	end
end

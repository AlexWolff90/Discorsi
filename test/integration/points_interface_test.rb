require 'test_helper'

class PointsInterfaceTest < ActionDispatch::IntegrationTest
	
	def setup
		@user = users(:alex)
		@point = points(:ants)
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

	test "new counterpoint" do
		log_in_as(@user)
		get point_path(@point)
		assert_select 'a', 'Counter'
		get new_point_path(counterpoint_to_id: @point.id)
		assert_select 'span.content', @point.content
		assert_select 'a', { text: 'Counter', count: 0 }
		content = "This is a sweet counterpoint"
		assert_difference 'Point.count', 1 do
			post points_path(counterpoint_to_id: @point.id), point: { content: content }
		end
		follow_redirect!
		assert_match content, response.body
		get point_path(@point)
		assert_select '.main-point a', { text: 'Counter', count: 0 }
	end
end

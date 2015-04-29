require 'test_helper'

class PointsInterfaceTest < ActionDispatch::IntegrationTest
	
	def setup
		@user = users(:alex)
	end

	test "point interface" do
		log_in_as(@user)
		get root_path
		assert_select 'div.pagination'
		assert_select 'input[type=file]'
		# Invalid submission
		post points_path, point: { content: "" }
		assert_select 'div#error_explanation'
		# Valid submission
		content = "This point really ties the room together"
		picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
		assert_difference 'Point.count', 1 do
			post points_path, point: { content: content, picture: picture }
		end
		assert assigns(:point).picture?
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

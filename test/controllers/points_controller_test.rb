require 'test_helper'

class PointsControllerTest < ActionController::TestCase

	def setup
		@point = points(:orange)
	end

	test "should redirect create when not logged in" do
		assert_no_difference 'Point.count' do
			post :create, point: { content: "Lorem ipsum" }
		end
		assert_redirected_to login_url
	end

	test "should redirect destroy when not logged in" do
		assert_no_difference 'Point.count' do
			delete :destroy, id: @point
		end
		assert_redirected_to login_url
	end

	test "should redirect destroy for wrong micropost" do
		log_in_as(users(:alex))
		point = points(:ants)
		assert_no_difference 'Point.count' do
			delete :destroy, id: point
		end
		assert_redirected_to root_url
	end
end

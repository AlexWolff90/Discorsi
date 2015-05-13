require 'test_helper'

class PointsShowTest < ActionDispatch::IntegrationTest

	def setup
		@point = points(:orange)
	end

	test "show point page" do
		get point_path(@point)
		assert_template 'points/show'
		@point.counterpoints.each do |counterpoint|
			assert_select "a[href=?]", point_path(counterpoint)
		end
	end
end

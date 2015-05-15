require 'test_helper'

class DebatesControllerTest < ActionController::TestCase

	def setup
		@point1 = points(:ants)
		@point2 = points(:tone)
		@point3 = points(:zone)
		@point4 = points(:van)
		@point5 = points(:orange)
		@point5.update(counterpoint_to_id: @point4.id)
		@point4.update(counterpoint_to_id: @point3.id)
		@point3.update(counterpoint_to_id: @point2.id)
		@point2.update(counterpoint_to_id: @point1.id)
	end

	test "should return correct debate items" do
		# Test right number of points for each legitimate point passed to it
		get :show, point_id: @point4.id
		@debate_items = assigns(:debate_items)
		assert_same @debate_items.count, 4
		get :show, point_id: @point3.id
		@debate_items = assigns(:debate_items)
		assert_same @debate_items.count, 4
		get :show, point_id: @point2.id
		@debate_items = assigns(:debate_items)
		assert_same @debate_items.count, 4
		@point5.update(counterpoint_to_id: @point3.id)
		get :show, point_id: @point3.id
		@debate_items = assigns(:debate_items)
		assert_same @debate_items.count, 4
	end

	test "should return correct number of debate items for invalid points to pass" do
		# These points aren't valid points to pass to controller
		# But controller should still be able to handle them
		get :show, point_id: @point1.id
		@debate_items = assigns(:debate_items)
		assert_same @debate_items.count, 1
		get :show, point_id: @point5.id
		@debate_items = assigns(:debate_items)
		assert_same @debate_items.count, 2
	end
end

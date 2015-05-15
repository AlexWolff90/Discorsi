require 'test_helper'

class DebatesTest < ActionDispatch::IntegrationTest

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

	test "should not be recognized as a debate" do
		assert_not @point5.is_debate?
	end

	test "should be recognized as a debate" do
		assert @point4.is_debate?
		assert @point2.is_debate?
	end

	test "should show debate link on point page" do
		get point_path(@point1)
		assert_select ".show-view-debate"
	end

	test "debate view should show all points" do
		get debates_show_path(point_id: @point2.id)
		@debate_items = assigns(:debate_items)
		@debate_items.each do |point|
			assert_select "a[href=?]", point_path(point)
		end
	end
end

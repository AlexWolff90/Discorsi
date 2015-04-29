require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
	include ApplicationHelper

	def setup
		@user = users(:alex)
	end

	test "profile display" do
		get user_path(@user)
		assert_select 'title', full_title("#{@user.first_name} #{@user.last_name}")
		assert_match "#{@user.first_name} #{@user.last_name}", response.body
		assert_select 'img.gravatar'
		assert_match @user.points.count.to_s, response.body
		assert_select 'div.pagination'
		@user.points.paginate(page: 1).each do |point|
			assert_match point.content, response.body
		end
	end
end

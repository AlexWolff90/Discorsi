require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest

	def setup
		@non_activated = users(:lana)
	end

	test "show user if activated and get root if not" do
		# Test for non-activated user
		@non_activated.toggle!(:activated)
		get user_path(@non_activated)
		assert_redirected_to root_path
		# Test for activated user
		@non_activated.toggle!(:activated)
		get user_path(@non_activated)
		assert_template 'users/show'
	end
end

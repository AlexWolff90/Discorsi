require 'test_helper'

class VotesControllerTest < ActionController::TestCase

	test "create should require logged-in user" do
		assert_no_difference 'Vote.count' do
			post :create
		end
		assert_redirected_to login_url
	end

	test "destroy should require logged-in user" do
		assert_no_difference 'Vote.count' do
			delete :destroy, id: votes(:one)
		end
		assert_redirected_to login_url
	end
end

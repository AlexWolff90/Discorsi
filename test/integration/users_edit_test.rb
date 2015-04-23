require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:alex)
	end

	test "unsuccessful edit" do
		log_in_as(@user)
		get edit_user_path(@user)
		assert_template 'users/edit'
		patch user_path(@user), user: { name: "",
																		email: "foo@invalid",
																		password:								"foo",
																		password_confirmation:	"bar" }
		assert_template 'users/edit'
	end

	test "successful edit with friendly forwarding" do
		get edit_user_path(@user)
		log_in_as(@user)
		assert_redirected_to edit_user_path(@user)
		first_name = "Foo"
		last_name = "Bar"
		email = "foo@bar.com"
		patch user_path(@user), user: { first_name: first_name,
																		last_name: last_name,
																		email: email,
																		password:								"",
																		password_confirmation:	"" }
		assert_not flash.empty?
		assert_redirected_to @user
		@user.reload
		assert_equal @user.first_name, first_name
		assert_equal @user.last_name, last_name
		assert_equal @user.email, email
	end
end

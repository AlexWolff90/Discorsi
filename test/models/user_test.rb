require 'test_helper'

class UserTest < ActiveSupport::TestCase
	def setup
		@user = User.new(first_name: "Example", last_name: "User", email: "user@example.com",
										 password: "foobarbif", password_confirmation: "foobarbif")
	end

	test "should be valid" do
		assert @user.valid?
	end

	test "first name should be present" do
		@user.first_name = "       "
		assert_not @user.valid?
	end

	test "last name should be present" do
		@user.last_name = "			"
		assert_not @user.valid?
	end

	test "email should be present" do
		@user.email = "      "
		assert_not @user.valid?
	end

	test "first name should not be too long" do
		@user.first_name = "a" * 31
		assert_not @user.valid?
	end

	test "last name should not be too long" do
		@user.last_name = "a" * 31
		assert_not @user.valid?
	end

	test "email should not be too long" do
		@user.email = "a" * 256
		assert_not @user.valid?
	end

	test "email validation should accept valid addresses" do
		valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp allice+bob@baz.cn]
		valid_addresses.each do |valid_address|
			@user.email = valid_address
			assert @user.valid?, "#{valid_address.inspect} should be valid"
		end
	end

	test "email validation should reject invalid addresses" do
		invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
		invalid_addresses.each do |invalid_address|
			@user.email = invalid_address
			assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
		end
	end

	test "email addresses should be unique" do
		duplicate_user = @user.dup
		duplicate_user.email = @user.email.upcase
		@user.save
		assert_not duplicate_user.valid?
	end

	test "email addresses should be saved as lower-case" do
		mixed_case_email = "Foo@ExAMPle.CoM"
		@user.email = mixed_case_email
		@user.save
		assert_equal mixed_case_email.downcase, @user.reload.email
	end

	test "password should have a minimum length" do
		@user.password = @user.password_confirmation = "a" * 7
		assert_not @user.valid?
	end

	test "authenticated? should return false for a user with nil digest" do
		assert_not @user.authenticated?(:remember, '')
	end

	test "associated points should be destroyed" do
		@user.save
		@user.points.create!(content: "Lorem ipsum")
		assert_difference 'Point.count', -1 do
			@user.destroy
		end
	end

	test "should follow and unfollow a user" do
		alex = users(:alex)
		archer = users(:archer)
		assert_not alex.following?(archer)
		alex.follow(archer)
		assert alex.following?(archer)
		assert archer.followed_by?(alex)
		alex.unfollow(archer)
		assert_not alex.following?(archer)
	end

	test "feed should have the right posts" do
		alex = users(:alex)
		archer = users(:archer)
		lana = users(:lana)
		# Posts from followed user
		lana.points.each do |post_following|
			assert alex.feed.include?(post_following)
		end
		# Posts from self
		alex.points.each do |post_self|
			assert alex.feed.include?(post_self)
		end
		# Posts from unfollowed user
		archer.points.each do |post_unfollowed|
			assert_not alex.feed.include?(post_unfollowed)
		end
	end
end

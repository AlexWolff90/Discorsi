class VotesController < ApplicationController
	before_action :logged_in_user

	def create
		@point = Point.find(params[:point_id])
		@point.unvote(current_user)
		@point.vote(current_user, params[:vote_type])
		@point.reload
		respond_to do |format|
			format.html do
				redirect_back_or current_user
			end
			format.js
		end
	end

	def destroy
		@point = Vote.find(params[:id]).point
		@point.unvote(current_user)
		@point.reload
		respond_to do |format|
			format.html do
				redirect_back_or current_user
			end
			format.js
		end
	end
end

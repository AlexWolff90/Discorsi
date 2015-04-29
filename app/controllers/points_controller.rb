class PointsController < ApplicationController
	before_action :logged_in_user,	only: [:create, :destroy]
	before_action :correct_user,		only: :destroy

	def create
		@point = current_user.points.build(point_params)
		if @point.save
			flash[:success] = "Point created!"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@point.destroy
		flash[:success] = "Point deleted"
		redirect_to request.referrer || root_url
	end

	private

		def point_params
			params.require(:point).permit(:content, :picture)
		end

		def correct_user
			@point = current_user.points.find_by(id: params[:id])
			redirect_to root_url if @point.nil?
		end
end

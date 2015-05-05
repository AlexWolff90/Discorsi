class PointsController < ApplicationController
	before_action :logged_in_user,	only: [:create, :destroy]
	before_action :correct_user,		only: :destroy

	def new
		@counterpoint_to = Point.find(params[:counterpoint_to_id]) unless params[:counterpoint_to_id].nil?
		@point = Point.new
	end

	def create
		@point = current_user.points.build(point_params)
		@point.counterpoint_to_id = params[:counterpoint_to_id] unless params[:counterpoint_to_id].nil?
		if @point.save
			flash[:success] = "Point created!"
			redirect_to params[:counterpoint_to_id].nil? ? point_path(@point) : point_path(params[:counterpoint_to_id])
		else
			@counterpoint_to = Point.find(params[:counterpoint_to_id]) unless params[:counterpoint_to_id].nil?
			render 'new'
		end
	end

	def show
		@point = Point.find(params[:id])
		@counterpoints = @point.counterpoints.paginate(page: params[:page])
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

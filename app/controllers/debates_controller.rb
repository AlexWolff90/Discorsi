class DebatesController < ApplicationController
  def show
		@debate_items = [Point.find(params[:point_id])]
		@debate_items = add_previous_items(@debate_items)
		@debate_items = add_next_items(@debate_items)
		@debate_items = @debate_items.paginate(page: params[:page])
  end

	private
		
		def add_previous_items(items)
			unless items.first.counterpoint_to_id.nil?
				user_cp = items.first.user
				user_p = items.first.countered_user
				until items.first.counterpoint_to_id.nil? || (items.first.countered_user != user_cp && items.first.countered_user != user_p) do
					items.unshift(Point.find(items.first.counterpoint_to_id))
				end
			end
			items
		end

		def add_next_items(items)
			unless items.count == 1
				until items.last.counterpoints.find_by(user: items.last.countered_user).nil? do
					items.push(items.last.counterpoints.find_by(user: items.last.countered_user))
				end
			end
			items
		end
end

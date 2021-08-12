class ItemsController < ApplicationController
	def index
		@items = User.find(params[:user_id]).items

		render json: @items, status: 200
	end

	def show
		@item = User.find(params[:user_id]).items.find_by(id: params[:id])

		render json: @item, status: :ok
	end

	def create
		@item = User.find(params[:user_id]).items.new(item_params)

		if @item.save
			render json: @item, status: :created
		else
			render json: { message: "Item not created!" }, status: :bad_request
		end
	end

	def update
		@item = User.find(params[:user_id]).items.find_by(id: params[:id])

		if @item.update(item_params)
			render json: @item, status: :ok
		else
			render json: { message: "Item not updated!" }, status: :bad_request
		end
	end

	def destroy
		@item = User.find(params[:user_id]).items.find_by(id: params[:id])
		@item.destroy

		render json: { message: "Record deleted!" }, status: :no_content
	end

	private

	def item_params
		params.require(:item).permit(:name)
	end
end

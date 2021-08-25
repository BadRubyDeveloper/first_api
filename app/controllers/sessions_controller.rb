class SessionsController < ApplicationController
	def create
		user = User.find_by!(email: login_params[:email])

		if user.password_right?(login_params[:password])
			render json: { token: TokensCreator.new(user).call }, status: 201
		else
			render json: { message: "Email or Password is wrong" }, status: 400
		end
	end

	private

	def login_params
		params.require(:login_data).permit(:email, :password)
	end
end

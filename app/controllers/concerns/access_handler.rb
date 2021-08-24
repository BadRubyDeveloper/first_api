module AccessHandler
	extend ActiveSupport::Concern

	def authenticate!
		check_bearer
	end

	private

	def check_bearer
		return render_unauthorize if request.env["HTTP_AUTHORIZATION"].nil?
		return render_unauthorize if request.env["HTTP_AUTHORIZATION"].include?("Bearer undefined")
		
		unpack_token
	end

	def unpack_token
		token = request.env["HTTP_AUTHORIZATION"].split(' ').last
		decoded_token = JWT.decode token, nil, false

		verify_information(decoded_token.first)
	end

	def verify_information(user_info)
		user = User.find(user_info["user_id"])

		if user_info["email"] == user.email
			@current_user = user
		else
			render_unauthorize
		end
	end
end
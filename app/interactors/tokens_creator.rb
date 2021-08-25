class TokensCreator
	def initialize(user)
		@payload = {
			user_id: user.id,
			email: user.email,
			username: user.name,
			salt: generate_salt
		}
	end

	def call
		JWT.encode @payload, nil, "HS256"
	end

	private

	def generate_salt
		values_arr = ['1', '2', '3', 'a', 'b', 'c']
		salt = ''

		10.times do
			salt += values_arr.sample
		end

		salt
	end
end
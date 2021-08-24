module ItemsPolicy
	extend ActiveSupport::Concern

	def can_write?(item, user)
		return true if item.user_id == user.id

		false
	end
end
module ItemsPolicy
	extend ActiveSupport::Concern

	def can_write?(item, current_user)
		admin_present = current_user.roles.find_by(permission: "admin")
		return true if admin_present
		return true if item.user_id == current_user.id

		false
	end
end